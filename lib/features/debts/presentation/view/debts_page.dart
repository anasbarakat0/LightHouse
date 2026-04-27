import 'dart:math';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/common/widget/header.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/features/debts/data/models/debt_account_model.dart';
import 'package:lighthouse/features/debts/data/models/debt_transaction_model.dart';
import 'package:lighthouse/features/debts/data/source/local/debts_local_source.dart';
import 'package:lighthouse/features/debts/data/source/remote/debts_sheet_sync_service.dart';
import 'package:lighthouse/features/premium_client/data/models/get_all_premiumClient_response_model.dart'
    as client_model;
import 'package:lighthouse/features/premium_client/data/repository/get_all_premium_clients_repo.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/get_all_premium_clients_service.dart';
import 'package:lighthouse/features/premium_client/domain/usecase/get_premium_clients_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _DebtFilter {
  all,
  withDebt,
  settled,
}

class DebtsPage extends StatefulWidget {
  const DebtsPage({super.key});

  @override
  State<DebtsPage> createState() => _DebtsPageState();
}

class _DebtsPageState extends State<DebtsPage> {
  late final DebtsLocalSource _localSource;
  late final DebtsSheetSyncService _syncService;
  final _searchController = TextEditingController();
  final _random = Random();

  List<DebtAccount> _accounts = [];
  List<DebtTransaction> _transactions = [];
  List<client_model.Body> _clients = [];

  bool _loading = true;
  bool _loadingClients = false;
  bool _syncing = false;
  String? _clientsError;
  _DebtFilter _filter = _DebtFilter.all;
  String _searchQuery = '';
  Future<void>? _clientsLoadFuture;

  @override
  void initState() {
    super.initState();
    _localSource = DebtsLocalSource(
      preferences: memory.get<SharedPreferences>(),
    );
    _syncService = DebtsSheetSyncService(dio: Dio());
    _loadLocalData();
    _clientsLoadFuture = _loadClients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadLocalData() {
    setState(() {
      _accounts = _localSource.getAccounts();
      _transactions = _localSource.getTransactions();
      _loading = false;
    });
  }

  Future<void> _loadClients() async {
    setState(() {
      _loadingClients = true;
      _clientsError = null;
    });

    final result = await GetPremiumClientsUsecase(
      getAllPremiumClientsRepo: GetAllPremiumClientsRepo(
        getAllPremiumClientsService: GetAllPremiumClientsService(dio: Dio()),
        networkConnection: NetworkConnection.createDefault(),
      ),
    ).call(1, 10000);

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        setState(() {
          _clientsError = _failureMessage(failure);
          _loadingClients = false;
        });
      },
      (response) {
        setState(() {
          _clients = response.body;
          _loadingClients = false;
        });
      },
    );
  }

  Future<void> _refreshClients() {
    final future = _loadClients();
    _clientsLoadFuture = future;
    return future;
  }

  String _failureMessage(Failures failure) {
    if (failure is OfflineFailure) {
      return connectionMessage;
    }
    if (failure is ServerFailure) {
      return failure.message;
    }
    if (failure is ForbiddenFailure) {
      return failure.message;
    }
    if (failure is NoDataFailure) {
      return failure.message;
    }
    return 'error'.tr();
  }

  List<DebtAccount> get _visibleAccounts {
    final query = _searchQuery.toLowerCase();
    final accounts = _accounts.where((account) {
      if (account.archived) {
        return false;
      }

      final balance = _balanceFor(account.id);
      final matchesFilter = switch (_filter) {
        _DebtFilter.all => true,
        _DebtFilter.withDebt => balance > 0,
        _DebtFilter.settled => balance <= 0,
      };

      final searchable =
          '${account.fullName} ${account.phoneNumber ?? ''}'.toLowerCase();
      return matchesFilter && searchable.contains(query);
    }).toList();

    accounts.sort((a, b) {
      final balanceCompare = _balanceFor(b.id).compareTo(_balanceFor(a.id));
      if (balanceCompare != 0) {
        return balanceCompare;
      }
      return a.fullName.compareTo(b.fullName);
    });

    return accounts;
  }

  double get _totalDebts {
    return _accounts.fold<double>(
      0,
      (total, account) {
        final balance = _balanceFor(account.id);
        return total + (balance > 0 ? balance : 0);
      },
    );
  }

  int get _activeDebtors {
    return _accounts.where((account) => _balanceFor(account.id) > 0).length;
  }

  int get _pendingSyncCount {
    final accounts = _accounts.where((account) => account.syncedAt == null);
    final transactions =
        _transactions.where((transaction) => transaction.syncedAt == null);
    return accounts.length + transactions.length;
  }

  double _balanceFor(String accountId) {
    return _transactions
        .where((transaction) => transaction.accountId == accountId)
        .fold<double>(
            0, (total, transaction) => total + transaction.signedAmount);
  }

  List<DebtTransaction> _transactionsFor(String accountId) {
    final items = _transactions
        .where((transaction) => transaction.accountId == accountId)
        .toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  DebtTransaction? _latestTransactionFor(String accountId) {
    final items = _transactionsFor(accountId);
    if (items.isEmpty) {
      return null;
    }
    return items.first;
  }

  String _newId(String prefix) {
    return '${prefix}_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(999999)}';
  }

  String _currentUserId() {
    final prefs = memory.get<SharedPreferences>();
    return prefs.getString('userId') ??
        prefs.getString('userEmail') ??
        'local_user';
  }

  String _clientName(client_model.Body client) {
    return '${client.firstName} ${client.lastName}'.trim();
  }

  bool _hasAccountForClient(String clientId) {
    return _accounts.any(
      (account) => account.clientId == clientId && !account.archived,
    );
  }

  Future<void> _saveAccounts() async {
    await _localSource.saveAccounts(_accounts);
  }

  Future<void> _saveTransactions() async {
    await _localSource.saveTransactions(_transactions);
  }

  Future<void> _addAccountFromClient(client_model.Body client) async {
    if (_hasAccountForClient(client.uuid)) {
      _showSnackBar('client_already_added'.tr(), isError: true);
      return;
    }

    final account = DebtAccount(
      id: _newId('debt_account'),
      clientId: client.uuid,
      firstName: client.firstName,
      lastName: client.lastName,
      phoneNumber: client.phoneNumber,
      createdAt: DateTime.now(),
      createdBy: _currentUserId(),
    );

    setState(() {
      _accounts.add(account);
    });

    await _saveAccounts();
    await _syncAccountIfConfigured(account);

    if (!mounted) {
      return;
    }

    _showSnackBar('client_added_to_debts'.tr());
  }

  Future<void> _addTransaction({
    required DebtAccount account,
    required DebtTransactionType type,
    required double amount,
    required String note,
  }) async {
    final transaction = DebtTransaction(
      id: _newId('debt_transaction'),
      accountId: account.id,
      type: type,
      amount: amount,
      note: note.trim(),
      createdAt: DateTime.now(),
      createdBy: _currentUserId(),
    );

    setState(() {
      _transactions.add(transaction);
    });

    await _saveTransactions();
    await _syncTransactionIfConfigured(transaction);

    if (!mounted) {
      return;
    }

    _showSnackBar(
      type == DebtTransactionType.debt
          ? 'debt_saved'.tr()
          : 'payment_saved'.tr(),
    );
  }

  Future<void> _syncAccountIfConfigured(DebtAccount account) async {
    final sheetUrl = _localSource.getSheetUrl().trim();
    if (sheetUrl.isEmpty) {
      return;
    }

    try {
      await _syncService.syncAccount(
        sheetUrl: sheetUrl,
        sheetToken: _localSource.getSheetToken(),
        account: account,
      );
      if (!mounted) {
        return;
      }
      final index = _accounts.indexWhere((item) => item.id == account.id);
      if (index == -1) {
        return;
      }

      setState(() {
        _accounts[index] = _accounts[index].copyWith(
          syncedAt: DateTime.now(),
        );
      });
      await _saveAccounts();
    } catch (_) {
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _syncTransactionIfConfigured(
    DebtTransaction transaction,
  ) async {
    final sheetUrl = _localSource.getSheetUrl().trim();
    if (sheetUrl.isEmpty) {
      return;
    }

    try {
      await _syncService.syncTransaction(
        sheetUrl: sheetUrl,
        sheetToken: _localSource.getSheetToken(),
        transaction: transaction,
      );
      if (!mounted) {
        return;
      }
      final index =
          _transactions.indexWhere((item) => item.id == transaction.id);
      if (index == -1) {
        return;
      }

      setState(() {
        _transactions[index] = _transactions[index].copyWith(
          syncedAt: DateTime.now(),
        );
      });
      await _saveTransactions();
    } catch (_) {
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _syncPendingRecords() async {
    final sheetUrl = _localSource.getSheetUrl().trim();
    if (sheetUrl.isEmpty) {
      _showSheetSettingsDialog();
      return;
    }

    setState(() => _syncing = true);

    final sheetToken = _localSource.getSheetToken();
    var accounts = List<DebtAccount>.from(_accounts);
    var transactions = List<DebtTransaction>.from(_transactions);
    var syncedCount = 0;
    var failedCount = 0;
    String? pullFailureMessage;

    for (var index = 0; index < accounts.length; index++) {
      final account = accounts[index];
      if (account.syncedAt != null) {
        continue;
      }

      try {
        await _syncService.syncAccount(
          sheetUrl: sheetUrl,
          sheetToken: sheetToken,
          account: account,
        );
        accounts[index] = account.copyWith(syncedAt: DateTime.now());
        syncedCount++;
      } catch (_) {
        failedCount++;
      }
    }

    for (var index = 0; index < transactions.length; index++) {
      final transaction = transactions[index];
      if (transaction.syncedAt != null) {
        continue;
      }

      try {
        await _syncService.syncTransaction(
          sheetUrl: sheetUrl,
          sheetToken: sheetToken,
          transaction: transaction,
        );
        transactions[index] = transaction.copyWith(syncedAt: DateTime.now());
        syncedCount++;
      } catch (_) {
        failedCount++;
      }
    }

    try {
      final snapshot = await _syncService.fetchAll(
        sheetUrl: sheetUrl,
        sheetToken: sheetToken,
      );
      final merged = _mergeSheetSnapshot(
        localAccounts: accounts,
        localTransactions: transactions,
        snapshot: snapshot,
      );
      accounts = merged.accounts;
      transactions = merged.transactions;
    } catch (error) {
      pullFailureMessage = _sheetPullFailureMessage(error);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _accounts = accounts;
      _transactions = transactions;
      _syncing = false;
    });
    await _saveAccounts();
    await _saveTransactions();

    if (failedCount > 0) {
      _showSnackBar(
        '${'sync_partial'.tr()} ($syncedCount/${syncedCount + failedCount})',
        isError: true,
      );
      return;
    }

    if (pullFailureMessage != null) {
      _showSnackBar(
        '${'sheet_pull_failed'.tr()}\n$pullFailureMessage',
        isError: true,
      );
      return;
    }

    _showSnackBar('sync_completed'.tr());
  }

  ({
    List<DebtAccount> accounts,
    List<DebtTransaction> transactions,
  }) _mergeSheetSnapshot({
    required List<DebtAccount> localAccounts,
    required List<DebtTransaction> localTransactions,
    required DebtsSheetSnapshot snapshot,
  }) {
    final accountMap = <String, DebtAccount>{
      for (final account in localAccounts)
        if (account.id.isNotEmpty) account.id: account,
    };
    final transactionMap = <String, DebtTransaction>{
      for (final transaction in localTransactions)
        if (transaction.id.isNotEmpty) transaction.id: transaction,
    };

    for (final account in snapshot.accounts) {
      final localAccount = accountMap[account.id];

      if (localAccount != null && localAccount.syncedAt == null) {
        continue;
      }

      accountMap[account.id] = account.copyWith(
        syncedAt: account.syncedAt ?? DateTime.now(),
      );
    }

    for (final transaction in snapshot.transactions) {
      final localTransaction = transactionMap[transaction.id];

      if (localTransaction != null && localTransaction.syncedAt == null) {
        continue;
      }

      transactionMap[transaction.id] = transaction.copyWith(
        syncedAt: transaction.syncedAt ?? DateTime.now(),
      );
    }

    final accounts = accountMap.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final transactions = transactionMap.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return (
      accounts: accounts,
      transactions: transactions,
    );
  }

  String _formatMoney(double value) {
    return '${NumberFormat('#,##0.##').format(value)} ${'S.P'.tr()}';
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd hh:mm a', context.locale.languageCode)
        .format(date);
  }

  String _sheetPullFailureMessage(Object error) {
    if (error is DioException && error.message != null) {
      return error.message!;
    }

    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }

    return message;
  }

  double? _parseAmount(String value) {
    final normalized = value.replaceAll(',', '').trim();
    return double.tryParse(normalized);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.redAccent.shade700 : Colors.green,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: darkNavy,
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: orange),
              )
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        if (Responsive.isDesktop(context)) _buildDesktopTitle(),
                        if (isMobile) HeaderWidget(title: 'debts'.tr()),
                        if (isMobile) const SizedBox(height: 18),
                        _buildSummaryCards(),
                        const SizedBox(height: 16),
                        _buildToolbar(),
                        const SizedBox(height: 16),
                        _buildFilterRow(),
                        const SizedBox(height: 16),
                        _buildAccountsSection(),
                        const SizedBox(height: 12),
                        _buildBottomTotalPanel(),
                        const SizedBox(height: 12),
                      ]),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDesktopTitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: yellow.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: yellow.withValues(alpha: 0.32)),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: yellow,
              size: 32,
            ),
          ),
          const SizedBox(width: 18),
          Text(
            'debts'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final cards = [
      _DebtSummaryCard(
        icon: Icons.payments_outlined,
        label: 'total_debts'.tr(),
        value: _formatMoney(_totalDebts),
        color: orange,
      ),
      _DebtSummaryCard(
        icon: Icons.groups_outlined,
        label: 'active_debtors'.tr(),
        value: _activeDebtors.toString(),
        color: yellow,
      ),
      _DebtSummaryCard(
        icon: _pendingSyncCount == 0 ? Icons.cloud_done_outlined : Icons.sync,
        label: 'pending_sync'.tr(),
        value: _pendingSyncCount.toString(),
        color: _pendingSyncCount == 0 ? Colors.greenAccent : Colors.lightBlue,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 760) {
          return Column(
            children: [
              for (var index = 0; index < cards.length; index++) ...[
                cards[index],
                if (index != cards.length - 1) const SizedBox(height: 10),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (var index = 0; index < cards.length; index++) ...[
              Expanded(child: cards[index]),
              if (index != cards.length - 1) const SizedBox(width: 12),
            ],
          ],
        );
      },
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2D4A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 760;
          final searchField = TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() => _searchQuery = value.trim());
            },
            style: const TextStyle(color: Colors.white),
            decoration: _darkInputDecoration(
              hint: 'search_debts_hint'.tr(),
              icon: Icons.search,
            ),
          );

          final actions = Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: _showAddClientDialog,
                icon: const Icon(Icons.person_add_alt_1_outlined),
                label: Text('add_debt_person'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: _syncing ? null : _syncPendingRecords,
                icon: _syncing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.cloud_sync_outlined),
                label: Text('sync_now'.tr()),
                style: _outlineButtonStyle(),
              ),
              IconButton(
                tooltip: 'sync_settings'.tr(),
                onPressed: _showSheetSettingsDialog,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          );

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                searchField,
                const SizedBox(height: 12),
                actions,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: searchField),
              const SizedBox(width: 14),
              actions,
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChipButton(
            label: 'all_debts'.tr(),
            selected: _filter == _DebtFilter.all,
            onTap: () => setState(() => _filter = _DebtFilter.all),
          ),
          const SizedBox(width: 8),
          _FilterChipButton(
            label: 'with_debt'.tr(),
            selected: _filter == _DebtFilter.withDebt,
            onTap: () => setState(() => _filter = _DebtFilter.withDebt),
          ),
          const SizedBox(width: 8),
          _FilterChipButton(
            label: 'settled'.tr(),
            selected: _filter == _DebtFilter.settled,
            onTap: () => setState(() => _filter = _DebtFilter.settled),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountsSection() {
    final accounts = _visibleAccounts;

    if (accounts.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        for (final account in accounts) ...[
          _buildAccountCard(account),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildBottomTotalPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: orange.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.summarize_outlined,
              color: orange,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'total_debts'.tr(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _formatMoney(_totalDebts),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${_activeDebtors.toString()} ${'active_debtors'.tr()}',
            style: const TextStyle(
              color: yellow,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasQuery = _searchQuery.isNotEmpty || _filter != _DebtFilter.all;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 42),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Icon(
            hasQuery
                ? Icons.search_off_outlined
                : Icons.account_balance_wallet_outlined,
            color: Colors.white70,
            size: 48,
          ),
          const SizedBox(height: 14),
          Text(
            hasQuery ? 'no_debts_match'.tr() : 'no_debts_yet'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (!hasQuery) ...[
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _showAddClientDialog,
              icon: const Icon(Icons.person_add_alt_1_outlined),
              label: Text('add_from_clients'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAccountCard(DebtAccount account) {
    final balance = _balanceFor(account.id);
    final latest = _latestTransactionFor(account.id);
    final isSynced = account.syncedAt != null &&
        !_transactionsFor(account.id).any(
          (transaction) => transaction.syncedAt == null,
        );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2D4A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: balance > 0
              ? orange.withValues(alpha: 0.28)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 700;
          final info = _buildAccountInfo(account, latest, isSynced);
          final balanceWidget = _buildBalanceBlock(balance);
          final actions = _buildAccountActions(account);

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                info,
                const SizedBox(height: 14),
                balanceWidget,
                const SizedBox(height: 14),
                actions,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: info),
              const SizedBox(width: 16),
              balanceWidget,
              const SizedBox(width: 16),
              actions,
            ],
          );
        },
      ),
    );
  }

  Widget _buildAccountInfo(
    DebtAccount account,
    DebtTransaction? latest,
    bool isSynced,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: yellow.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.person_outline,
            color: yellow,
            size: 28,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account.fullName.isEmpty ? 'client'.tr() : account.fullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _MiniPill(
                    icon: Icons.phone_outlined,
                    label: account.phoneNumber?.isNotEmpty == true
                        ? account.phoneNumber!
                        : 'no_phone'.tr(),
                  ),
                  _MiniPill(
                    icon: isSynced
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_upload_outlined,
                    label: isSynced ? 'synced'.tr() : 'local_only'.tr(),
                    color: isSynced ? Colors.greenAccent : Colors.lightBlue,
                  ),
                  if (latest != null)
                    _MiniPill(
                      icon: Icons.schedule_outlined,
                      label: _formatDate(latest.createdAt),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceBlock(double balance) {
    final color = balance > 0 ? orange : Colors.greenAccent;

    return Container(
      constraints: const BoxConstraints(minWidth: 140),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'balance'.tr(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.68),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatMoney(balance),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountActions(DebtAccount account) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.end,
      children: [
        OutlinedButton.icon(
          onPressed: () => _showTransactionDialog(
            account: account,
            type: DebtTransactionType.debt,
          ),
          icon: const Icon(Icons.add_card_outlined),
          label: Text('add_debt'.tr()),
          style: _outlineButtonStyle(color: orange),
        ),
        OutlinedButton.icon(
          onPressed: () => _showTransactionDialog(
            account: account,
            type: DebtTransactionType.payment,
          ),
          icon: const Icon(Icons.check_circle_outline),
          label: Text('add_payment'.tr()),
          style: _outlineButtonStyle(color: Colors.greenAccent),
        ),
        IconButton(
          tooltip: 'transactions'.tr(),
          onPressed: () => _showAccountDetailsDialog(account),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.08),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.receipt_long_outlined),
        ),
      ],
    );
  }

  Future<void> _showAddClientDialog() async {
    if (_clients.isEmpty && (_loadingClients || _clientsError == null)) {
      await (_clientsLoadFuture ?? _refreshClients());
      if (!mounted) {
        return;
      }
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        var query = '';

        return StatefulBuilder(
          builder: (context, setDialogState) {
            final filteredClients = _clients.where((client) {
              if (_hasAccountForClient(client.uuid)) {
                return false;
              }

              final searchable =
                  '${_clientName(client)} ${client.phoneNumber ?? ''}'
                      .toLowerCase();
              return searchable.contains(query.toLowerCase());
            }).toList();

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Container(
                width: 560,
                constraints: const BoxConstraints(maxHeight: 620),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: darkNavy,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildDialogHeader(
                      title: 'choose_client'.tr(),
                      icon: Icons.person_add_alt_1_outlined,
                      onClose: () => Navigator.of(dialogContext).pop(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (value) {
                        setDialogState(() => query = value.trim());
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: _darkInputDecoration(
                        hint: 'search_by_client_name'.tr(),
                        icon: Icons.search,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Flexible(
                      child: _buildClientPickerList(
                        dialogContext: dialogContext,
                        filteredClients: filteredClients,
                        setDialogState: setDialogState,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildClientPickerList({
    required BuildContext dialogContext,
    required List<client_model.Body> filteredClients,
    required StateSetter setDialogState,
  }) {
    if (_loadingClients) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(28),
          child: CircularProgressIndicator(color: orange),
        ),
      );
    }

    if (_clientsError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _clientsError!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                await _refreshClients();
                if (dialogContext.mounted) {
                  setDialogState(() {});
                }
              },
              icon: const Icon(Icons.refresh),
              label: Text('loading_clients'.tr()),
              style: _outlineButtonStyle(),
            ),
          ],
        ),
      );
    }

    if (filteredClients.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Text(
            'no_clients_available'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: filteredClients.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final client = filteredClients[index];
        return Material(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.of(dialogContext).pop();
              _addAccountFromClient(client);
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.person_outline, color: yellow),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _clientName(client),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          client.phoneNumber?.isNotEmpty == true
                              ? client.phoneNumber!
                              : 'no_phone'.tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.add_circle_outline, color: orange),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showTransactionDialog({
    required DebtAccount account,
    required DebtTransactionType type,
  }) async {
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final isDebt = type == DebtTransactionType.debt;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            width: 460,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: darkNavy,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDialogHeader(
                    title: isDebt ? 'add_debt'.tr() : 'add_payment'.tr(),
                    icon: isDebt
                        ? Icons.add_card_outlined
                        : Icons.check_circle_outline,
                    onClose: () => Navigator.of(dialogContext).pop(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    account.fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: amountController,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      final amount = _parseAmount(value ?? '');
                      if (amount == null || amount <= 0) {
                        return 'amount_required'.tr();
                      }
                      return null;
                    },
                    decoration: _darkInputDecoration(
                      hint: 'amount'.tr(),
                      icon: Icons.payments_outlined,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noteController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: _darkInputDecoration(
                      hint: 'optional_note'.tr(),
                      icon: Icons.notes_outlined,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          style: _outlineButtonStyle(),
                          child: Text('Cancel'.tr()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }

                            final amount = _parseAmount(amountController.text);
                            if (amount == null) {
                              return;
                            }

                            Navigator.of(dialogContext).pop();
                            _addTransaction(
                              account: account,
                              type: type,
                              amount: amount,
                              note: noteController.text,
                            );
                          },
                          icon: Icon(
                            isDebt
                                ? Icons.add_card_outlined
                                : Icons.check_circle_outline,
                          ),
                          label: Text(
                              isDebt ? 'add_debt'.tr() : 'add_payment'.tr()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDebt ? orange : Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    Future<void>.delayed(
      const Duration(milliseconds: 300),
      () {
        amountController.dispose();
        noteController.dispose();
      },
    );
  }

  Future<void> _showAccountDetailsDialog(DebtAccount account) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final transactions = _transactionsFor(account.id);
        final balance = _balanceFor(account.id);

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            width: 720,
            constraints: const BoxConstraints(maxHeight: 720),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: darkNavy,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDialogHeader(
                  title: 'transactions'.tr(),
                  icon: Icons.receipt_long_outlined,
                  onClose: () => Navigator.of(dialogContext).pop(),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        account.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _formatMoney(balance),
                      style: TextStyle(
                        color: balance > 0 ? orange : Colors.greenAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Flexible(
                  child: transactions.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(28),
                            child: Text(
                              'no_transactions'.tr(),
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: transactions.length,
                          separatorBuilder: (_, __) => Divider(
                              color: Colors.white.withValues(alpha: 0.08)),
                          itemBuilder: (context, index) {
                            return _buildTransactionTile(transactions[index]);
                          },
                        ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        _showTransactionDialog(
                          account: account,
                          type: DebtTransactionType.debt,
                        );
                      },
                      icon: const Icon(Icons.add_card_outlined),
                      label: Text('add_debt'.tr()),
                      style: _outlineButtonStyle(color: orange),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        _showTransactionDialog(
                          account: account,
                          type: DebtTransactionType.payment,
                        );
                      },
                      icon: const Icon(Icons.check_circle_outline),
                      label: Text('add_payment'.tr()),
                      style: _outlineButtonStyle(color: Colors.greenAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionTile(DebtTransaction transaction) {
    final isDebt = transaction.type == DebtTransactionType.debt;
    final color = isDebt ? orange : Colors.greenAccent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isDebt ? Icons.add_card_outlined : Icons.check_circle_outline,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDebt ? 'debt'.tr() : 'payment'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(transaction.createdAt),
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                if (transaction.note.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    transaction.note,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatMoney(transaction.amount),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Icon(
                transaction.syncedAt == null
                    ? Icons.cloud_upload_outlined
                    : Icons.cloud_done_outlined,
                color: transaction.syncedAt == null
                    ? Colors.lightBlue
                    : Colors.greenAccent,
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showSheetSettingsDialog() async {
    final urlController = TextEditingController(
      text: _localSource.getSheetUrl(),
    );
    final tokenController = TextEditingController(
      text: _localSource.getSheetToken(),
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            width: 520,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: darkNavy,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDialogHeader(
                  title: 'sync_settings'.tr(),
                  icon: Icons.cloud_sync_outlined,
                  onClose: () => Navigator.of(dialogContext).pop(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: urlController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _darkInputDecoration(
                    hint: 'sheet_url'.tr(),
                    icon: Icons.link_outlined,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: tokenController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _darkInputDecoration(
                    hint: 'sheet_token'.tr(),
                    icon: Icons.key_outlined,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: _outlineButtonStyle(),
                        child: Text('Cancel'.tr()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final navigator = Navigator.of(dialogContext);
                          await _localSource.saveSheetConfig(
                            sheetUrl: urlController.text,
                            sheetToken: tokenController.text,
                          );
                          if (!mounted) {
                            return;
                          }
                          navigator.pop();
                          setState(() {});
                          _showSnackBar('sheet_settings_saved'.tr());
                        },
                        icon: const Icon(Icons.save_outlined),
                        label: Text('save'.tr()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    Future<void>.delayed(
      const Duration(milliseconds: 300),
      () {
        urlController.dispose();
        tokenController.dispose();
      },
    );
  }

  Widget _buildDialogHeader({
    required String title,
    required IconData icon,
    required VoidCallback onClose,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: orange.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: orange),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close, color: Colors.white70),
        ),
      ],
    );
  }

  InputDecoration _darkInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.45)),
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.06),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: orange, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.redAccent.shade200),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.redAccent.shade200),
      ),
      errorStyle: TextStyle(color: Colors.redAccent.shade100),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  ButtonStyle _outlineButtonStyle({Color color = Colors.white}) {
    return OutlinedButton.styleFrom(
      foregroundColor: color,
      side: BorderSide(color: color.withValues(alpha: 0.34)),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _DebtSummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DebtSummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2D4A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.68),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? orange : Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white70,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MiniPill({
    required this.icon,
    required this.label,
    this.color = Colors.white70,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 210),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
