import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/buffet/data/models/get_all_products_response_model.dart'
    as products;
import 'package:lighthouse/features/buffet/data/repository/get_all_products_repo.dart';
import 'package:lighthouse/features/buffet/data/source/remote/get_all_products_service.dart';
import 'package:lighthouse/features/buffet/domain/usecase/get_all_products_usecase.dart';
import 'package:lighthouse/features/buffet/presentation/bloc/get_all_products_bloc.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/features/debts/data/models/debt_account_model.dart';
import 'package:lighthouse/features/debts/data/models/debt_transaction_model.dart';
import 'package:lighthouse/features/debts/data/source/local/debts_local_source.dart';
import 'package:lighthouse/features/debts/data/source/remote/debts_sheet_sync_service.dart';
import 'package:lighthouse/features/home/data/models/buffet_order_request_model.dart';
import 'package:lighthouse/features/home/data/models/get_premium_session_response.dart';
import 'package:lighthouse/features/home/presentation/widget/detail_row.dart';
import 'package:lighthouse/features/home/presentation/widget/session_duration_formatter.dart';
import 'package:lighthouse/features/home/presentation/widget/session_time_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [onEndSession] انهاء الجلسة بدون طباعة فاتورة
/// [onEndSessionWithPrint] انهاء الجلسة مع طباعة فاتورة
void premiumSessionDialog(
  BuildContext context,
  Body sessionData,
  void Function() onEndSession,
  void Function() onEndSessionWithPrint, {
  void Function(List<BuffetOrderRequestModel> orders)? onAddBuffetOrders,
  void Function(String orderId, int quantity)? onUpdateBuffetOrder,
  void Function(String orderId)? onDeleteBuffetOrder,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 680, maxHeight: 760),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A2F4A),
                Color(0xFF0F1E2E),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SessionDialogHeader(
                onClose: () => Navigator.of(context).pop(),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SessionSummary(sessionData: sessionData),
                      const SizedBox(height: 14),
                      _SessionDebtStatus(sessionData: sessionData),
                      const SizedBox(height: 16),
                      Divider(
                        thickness: 1,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      const SizedBox(height: 16),
                      _BuffetInvoicesSection(
                        parentContext: context,
                        sessionData: sessionData,
                        onAddBuffetOrders: onAddBuffetOrders,
                        onUpdateBuffetOrder: onUpdateBuffetOrder,
                        onDeleteBuffetOrder: onDeleteBuffetOrder,
                      ),
                      const SizedBox(height: 24),
                      _TotalPricePanel(sessionData: sessionData),
                    ],
                  ),
                ),
              ),
              _SessionDialogFooter(
                onEndSession: onEndSession,
                onEndSessionWithPrint: onEndSessionWithPrint,
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _SessionDialogHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _SessionDialogHeader({
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            yellow.withOpacity(0.2),
            yellow.withOpacity(0.1),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          bottom: BorderSide(
            color: yellow.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  yellow.withOpacity(0.3),
                  yellow.withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: yellow.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.stars_rounded,
              color: yellow,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'session_info'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            tooltip: "cancel".tr(),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _SessionSummary extends StatelessWidget {
  final Body sessionData;

  const _SessionSummary({
    required this.sessionData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DetailRow(
          title: "${"date".tr()}: ",
          value: sessionData.date,
        ),
        DetailRow(
          title: "${"started_at".tr()}: ",
          value: formatPremiumSessionTime(
            context,
            sessionData.startTime,
          ),
        ),
        DetailRow(
          title: "${"first_name".tr()}: ",
          value: sessionData.firstName,
        ),
        DetailRow(
          title: "${"last_name".tr()}: ",
          value: sessionData.lastName,
        ),
        DetailRow(
          title: "${"created_by".tr()}: ",
          value: sessionData.createdBy.firstName,
        ),
        if (sessionData.sessionInvoice != null) ...[
          DetailRow(
            title: "${"num_of_hours".tr()}: ",
            value: formatPremiumSessionDuration(
              context,
              sessionData.sessionInvoice!.hoursAmount,
            ),
          ),
          DetailRow(
            title: "${"sessionInvoicePrice".tr()}: ",
            value:
                "${_formatPrice(sessionData.sessionInvoice!.hoursAmount * sessionData.sessionInvoice!.hourlyPrice)} ${"s.p".tr()}",
          ),
        ],
        DetailRow(
          title: "${"buffetInvoicePrice".tr()}: ",
          value:
              "${_formatPrice(sessionData.buffetInvoicePrice)} ${"s.p".tr()}",
        ),
      ],
    );
  }
}

class _SessionDebtStatus extends StatefulWidget {
  final Body sessionData;

  const _SessionDebtStatus({
    required this.sessionData,
  });

  @override
  State<_SessionDebtStatus> createState() => _SessionDebtStatusState();
}

class _SessionDebtStatusState extends State<_SessionDebtStatus> {
  late final DebtsLocalSource _localSource;
  late final DebtsSheetSyncService _syncService;
  List<DebtAccount> _accounts = [];
  List<DebtTransaction> _transactions = [];
  bool _isSavingPayment = false;

  @override
  void initState() {
    super.initState();
    _localSource = DebtsLocalSource(
      preferences: memory.get<SharedPreferences>(),
    );
    _syncService = DebtsSheetSyncService(dio: Dio());
    _loadDebts();
  }

  void _loadDebts() {
    _accounts = _localSource.getAccounts();
    _transactions = _localSource.getTransactions();
  }

  DebtAccount? get _account {
    for (final account in _accounts) {
      if (!account.archived && account.clientId == widget.sessionData.userId) {
        return account;
      }
    }
    return null;
  }

  double get _balance {
    final account = _account;
    if (account == null) {
      return 0;
    }

    return _transactions
        .where((transaction) => transaction.accountId == account.id)
        .fold<double>(
            0, (total, transaction) => total + transaction.signedAmount);
  }

  String _currentUserId() {
    final prefs = memory.get<SharedPreferences>();
    return prefs.getString('userId') ??
        prefs.getString('userEmail') ??
        'local_user';
  }

  String _newTransactionId() {
    return 'debt_transaction_${DateTime.now().microsecondsSinceEpoch}';
  }

  Future<void> _markDebtAsPaid() async {
    final account = _account;
    final balance = _balance;

    if (account == null || balance <= 0 || _isSavingPayment) {
      return;
    }

    final confirmed = await _showConfirmPaymentDialog(balance);
    if (!mounted || !confirmed) {
      return;
    }

    setState(() => _isSavingPayment = true);

    final transaction = DebtTransaction(
      id: _newTransactionId(),
      accountId: account.id,
      type: DebtTransactionType.payment,
      amount: balance,
      note: '${'premium_session_debt_payment'.tr()} ${widget.sessionData.id}',
      createdAt: DateTime.now(),
      createdBy: _currentUserId(),
    );

    final updatedTransactions = List<DebtTransaction>.from(_transactions)
      ..add(transaction);

    await _localSource.saveTransactions(updatedTransactions);

    var finalTransaction = transaction;
    final sheetUrl = _localSource.getSheetUrl().trim();
    if (sheetUrl.isNotEmpty) {
      try {
        if (account.syncedAt == null) {
          await _syncService.syncAccount(
            sheetUrl: sheetUrl,
            sheetToken: _localSource.getSheetToken(),
            account: account,
          );
          final accountIndex = _accounts.indexWhere(
            (item) => item.id == account.id,
          );
          if (accountIndex != -1) {
            _accounts[accountIndex] = account.copyWith(
              syncedAt: DateTime.now(),
            );
            await _localSource.saveAccounts(_accounts);
          }
        }
        await _syncService.syncTransaction(
          sheetUrl: sheetUrl,
          sheetToken: _localSource.getSheetToken(),
          transaction: transaction,
        );
        finalTransaction = transaction.copyWith(syncedAt: DateTime.now());
        final index = updatedTransactions.indexWhere(
          (item) => item.id == transaction.id,
        );
        if (index != -1) {
          updatedTransactions[index] = finalTransaction;
          await _localSource.saveTransactions(updatedTransactions);
        }
      } catch (_) {
        // Keep the payment locally; the Debts page can sync it later.
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _transactions = updatedTransactions;
      _isSavingPayment = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          'debt_paid_success'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<bool> _showConfirmPaymentDialog(double balance) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text('confirm_debt_payment_title'.tr()),
          content: Text(
            'confirm_debt_payment_message'.tr(
              args: [_formatPrice(balance), 's.p'.tr()],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text('Cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('confirm'.tr()),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final balance = _balance;
    final hasDebt = balance > 0;
    final accentColor = hasDebt ? Colors.redAccent : Colors.greenAccent;
    final icon =
        hasDebt ? Icons.warning_amber_rounded : Icons.verified_outlined;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasDebt ? 'client_has_debt'.tr() : 'client_has_no_debt'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasDebt
                      ? '${'balance'.tr()}: ${_formatPrice(balance)} ${'s.p'.tr()}'
                      : 'debt_status_clear'.tr(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.68),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (hasDebt) ...[
            const SizedBox(width: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isSavingPayment)
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation<Color>(orange),
                    ),
                  )
                else
                  Checkbox(
                    value: false,
                    onChanged: (_) => _markDebtAsPaid(),
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.72),
                      width: 1.6,
                    ),
                  ),
                Text(
                  'mark_as_paid'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _BuffetInvoicesSection extends StatelessWidget {
  final BuildContext parentContext;
  final Body sessionData;
  final void Function(List<BuffetOrderRequestModel> orders)? onAddBuffetOrders;
  final void Function(String orderId, int quantity)? onUpdateBuffetOrder;
  final void Function(String orderId)? onDeleteBuffetOrder;

  const _BuffetInvoicesSection({
    required this.parentContext,
    required this.sessionData,
    required this.onAddBuffetOrders,
    required this.onUpdateBuffetOrder,
    required this.onDeleteBuffetOrder,
  });

  bool get _canManageBuffet {
    return sessionData.active &&
        (onAddBuffetOrders != null ||
            onUpdateBuffetOrder != null ||
            onDeleteBuffetOrder != null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.restaurant_menu_rounded,
              color: orange,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "buffet_invoice".tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (_canManageBuffet && onAddBuffetOrders != null)
              Tooltip(
                message: "add_buffet_order".tr(),
                child: InkWell(
                  onTap: () {
                    _showAddBuffetOrdersDialog(
                      parentContext,
                      onAddBuffetOrders!,
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: yellow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: navy,
                      size: 24,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (sessionData.buffetInvoices.isNotEmpty)
          ...sessionData.buffetInvoices.map(
            (invoice) => _BuffetInvoiceCard(
              parentContext: parentContext,
              invoice: invoice,
              canManage: _canManageBuffet,
              onUpdateBuffetOrder: onUpdateBuffetOrder,
              onDeleteBuffetOrder: onDeleteBuffetOrder,
            ),
          )
        else
          _EmptyBuffetPanel(
            canAdd: _canManageBuffet && onAddBuffetOrders != null,
            onAdd: () {
              _showAddBuffetOrdersDialog(
                parentContext,
                onAddBuffetOrders!,
              );
            },
          ),
      ],
    );
  }
}

class _BuffetInvoiceCard extends StatelessWidget {
  final BuildContext parentContext;
  final BuffetInvoice invoice;
  final bool canManage;
  final void Function(String orderId, int quantity)? onUpdateBuffetOrder;
  final void Function(String orderId)? onDeleteBuffetOrder;

  const _BuffetInvoiceCard({
    required this.parentContext,
    required this.invoice,
    required this.canManage,
    required this.onUpdateBuffetOrder,
    required this.onDeleteBuffetOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.03),
            ],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.white.withOpacity(0.65),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    invoice.invoiceTime.isEmpty
                        ? "buffet_invoice".tr()
                        : formatPremiumSessionTime(
                            context,
                            invoice.invoiceTime,
                          ),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.72),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...invoice.orders.map(
              (order) => _EditableBuffetOrderRow(
                parentContext: parentContext,
                order: order,
                canManage: canManage,
                onUpdateBuffetOrder: onUpdateBuffetOrder,
                onDeleteBuffetOrder: onDeleteBuffetOrder,
              ),
            ),
            const SizedBox(height: 12),
            Divider(
              thickness: 1,
              color: Colors.white.withOpacity(0.1),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "invoice_price".tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${_formatPrice(invoice.totalPrice)} ${"s.p".tr()}",
                  style: const TextStyle(
                    color: orange,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EditableBuffetOrderRow extends StatelessWidget {
  final BuildContext parentContext;
  final Order order;
  final bool canManage;
  final void Function(String orderId, int quantity)? onUpdateBuffetOrder;
  final void Function(String orderId)? onDeleteBuffetOrder;

  const _EditableBuffetOrderRow({
    required this.parentContext,
    required this.order,
    required this.canManage,
    required this.onUpdateBuffetOrder,
    required this.onDeleteBuffetOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.productName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "${"quantity".tr()}: ${order.quantity}  •  ${_formatPrice(order.price)} ${"s.p".tr()}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.62),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (canManage && onUpdateBuffetOrder != null) ...[
            const SizedBox(width: 8),
            _OrderIconButton(
              tooltip: "update_buffet_quantity".tr(),
              icon: Icons.edit_rounded,
              color: yellow,
              onTap: () {
                _showUpdateBuffetOrderDialog(
                  parentContext,
                  order,
                  (quantity) => onUpdateBuffetOrder!(order.id, quantity),
                );
              },
            ),
          ],
          if (canManage && onDeleteBuffetOrder != null) ...[
            const SizedBox(width: 8),
            _OrderIconButton(
              tooltip: "delete".tr(),
              icon: Icons.delete_outline_rounded,
              color: Colors.redAccent,
              onTap: () {
                _showDeleteBuffetOrderDialog(
                  parentContext,
                  order,
                  () => onDeleteBuffetOrder!(order.id),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderIconButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _OrderIconButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.14),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: color.withOpacity(0.35),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 19,
          ),
        ),
      ),
    );
  }
}

class _EmptyBuffetPanel extends StatelessWidget {
  final bool canAdd;
  final VoidCallback onAdd;

  const _EmptyBuffetPanel({
    required this.canAdd,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.restaurant_menu_outlined,
            size: 44,
            color: Colors.white.withOpacity(0.32),
          ),
          const SizedBox(height: 12),
          Text(
            "no_buffet_items".tr(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.62),
              fontSize: 14,
            ),
          ),
          if (canAdd) ...[
            const SizedBox(height: 14),
            _PrimarySmallButton(
              label: "add_buffet_order".tr(),
              icon: Icons.add_rounded,
              onTap: onAdd,
            ),
          ],
        ],
      ),
    );
  }
}

class _TotalPricePanel extends StatelessWidget {
  final Body sessionData;

  const _TotalPricePanel({
    required this.sessionData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            orange.withOpacity(0.2),
            orange.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: orange.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "total_price".tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            "${_formatPrice(_asDouble(sessionData.totalPrice))} ${"s.p".tr()}",
            style: const TextStyle(
              color: orange,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionDialogFooter extends StatelessWidget {
  final VoidCallback onEndSession;
  final VoidCallback onEndSessionWithPrint;

  const _SessionDialogFooter({
    required this.onEndSession,
    required this.onEndSessionWithPrint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 52,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onEndSession,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          orange.withOpacity(0.3),
                          orange.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: orange.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.stop_circle_rounded,
                          color: orange,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            "end_session".tr(),
                            style: const TextStyle(
                              color: orange,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Tooltip(
            message: "end_session_with_invoice".tr(),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onEndSessionWithPrint,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: orange.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: orange,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showAddBuffetOrdersDialog(
  BuildContext parentContext,
  void Function(List<BuffetOrderRequestModel> orders) onAddBuffetOrders,
) {
  showDialog(
    context: parentContext,
    builder: (context) {
      return BlocProvider(
        create: (context) => GetAllProductsBloc(
          GetAllProductsUsecase(
            getAllProductsRepo: GetAllProductsRepo(
              getAllProductsService: GetAllProductsService(dio: Dio()),
              networkConnection: NetworkConnection.createDefault(),
            ),
          ),
        )..add(GetAllProducts(page: 0, size: 10000)),
        child: _AddBuffetOrdersDialog(
          onSubmit: (orders) {
            Navigator.of(parentContext).pop();
            onAddBuffetOrders(orders);
          },
        ),
      );
    },
  );
}

class _AddBuffetOrdersDialog extends StatefulWidget {
  final void Function(List<BuffetOrderRequestModel> orders) onSubmit;

  const _AddBuffetOrdersDialog({
    required this.onSubmit,
  });

  @override
  State<_AddBuffetOrdersDialog> createState() => _AddBuffetOrdersDialogState();
}

class _AddBuffetOrdersDialogState extends State<_AddBuffetOrdersDialog> {
  final TextEditingController _searchController = TextEditingController();
  final Map<String, int> _selectedQuantities = {};
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int get _selectedItemsCount {
    return _selectedQuantities.values.fold(0, (sum, value) => sum + value);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 720),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A2F4A),
              Color(0xFF0F1E2E),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            _NestedDialogHeader(
              title: "add_buffet_order".tr(),
              icon: Icons.add_shopping_cart_rounded,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value.trim()),
                decoration: InputDecoration(
                  hintText: "search_products".tr(),
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.45),
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.white.withOpacity(0.55),
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.06),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: yellow,
                      width: 1,
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<GetAllProductsBloc, GetAllProductsState>(
                builder: (context, state) {
                  if (state is LoadingGetProducts ||
                      state is GetAllProductsInitial) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(yellow),
                      ),
                    );
                  }

                  if (state is SuccessGettingProducts) {
                    final allProducts = _sortProducts(state.response.body);
                    final visibleProducts = _filterProducts(allProducts);

                    if (visibleProducts.isEmpty) {
                      return _AddDialogEmptyState(
                        message: "no_available_products".tr(),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      itemCount: visibleProducts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final product = visibleProducts[index];
                        return _SelectableProductRow(
                          product: product,
                          quantity: _selectedQuantities[product.id] ?? 0,
                          onChanged: (quantity) {
                            setState(() {
                              if (quantity <= 0) {
                                _selectedQuantities.remove(product.id);
                              } else {
                                _selectedQuantities[product.id] = quantity;
                              }
                            });
                          },
                        );
                      },
                    );
                  }

                  if (state is ExceptionGetProducts) {
                    return _AddDialogEmptyState(message: state.message);
                  }

                  if (state is ForbiddenGetProducts) {
                    return _AddDialogEmptyState(message: state.message);
                  }

                  return _AddDialogEmptyState(
                    message: "no_available_products".tr(),
                  );
                },
              ),
            ),
            BlocBuilder<GetAllProductsBloc, GetAllProductsState>(
              builder: (context, state) {
                final allProducts = state is SuccessGettingProducts
                    ? state.response.body
                    : <products.Body>[];
                return _AddBuffetFooter(
                  selectedItemsCount: _selectedItemsCount,
                  selectedTotal: _selectedTotal(allProducts),
                  canSubmit: _selectedQuantities.isNotEmpty,
                  onCancel: () => Navigator.of(context).pop(),
                  onSubmit: () {
                    final orders = _selectedQuantities.entries
                        .map(
                          (entry) => BuffetOrderRequestModel(
                            productId: entry.key,
                            quantity: entry.value,
                          ),
                        )
                        .toList();
                    Navigator.of(context).pop();
                    widget.onSubmit(orders);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<products.Body> _sortProducts(List<products.Body> allProducts) {
    return [
      ...allProducts.where((product) => product.quantity > 0),
      ...allProducts.where((product) => product.quantity <= 0),
    ];
  }

  List<products.Body> _filterProducts(List<products.Body> allProducts) {
    final query = _query.toLowerCase();
    if (query.isEmpty) return allProducts;

    return allProducts.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.barCode.toLowerCase().contains(query);
    }).toList();
  }

  double _selectedTotal(List<products.Body> allProducts) {
    double total = 0;
    final productsById = {
      for (final product in allProducts) product.id: product,
    };

    for (final entry in _selectedQuantities.entries) {
      final product = productsById[entry.key];
      if (product != null) {
        total += product.consumptionPrice * entry.value;
      }
    }

    return total;
  }
}

class _SelectableProductRow extends StatelessWidget {
  final products.Body product;
  final int quantity;
  final void Function(int quantity) onChanged;

  const _SelectableProductRow({
    required this.product,
    required this.quantity,
    required this.onChanged,
  });

  bool get _isOutOfStock => product.quantity <= 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(_isOutOfStock ? 0.035 : 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isOutOfStock
              ? Colors.redAccent.withOpacity(0.26)
              : Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    color: _isOutOfStock
                        ? Colors.white.withOpacity(0.45)
                        : Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 10,
                  runSpacing: 6,
                  children: [
                    _ProductMetaChip(
                      icon: Icons.payments_outlined,
                      label:
                          "${_formatPrice(product.consumptionPrice)} ${"s.p".tr()}",
                      color: yellow,
                    ),
                    _ProductMetaChip(
                      icon: Icons.inventory_2_outlined,
                      label: "${"stock".tr()}: ${product.quantity}",
                      color: _isOutOfStock ? Colors.redAccent : Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _QuantityStepper(
            quantity: quantity,
            min: 0,
            max: product.quantity < 100 ? product.quantity : 100,
            enabled: !_isOutOfStock,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ProductMetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ProductMetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: color.withOpacity(0.22),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final int min;
  final int max;
  final bool enabled;
  final void Function(int quantity) onChanged;

  const _QuantityStepper({
    required this.quantity,
    required this.min,
    required this.max,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final canDecrease = enabled && quantity > min;
    final canIncrease = enabled && quantity < max;

    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove_rounded,
            enabled: canDecrease,
            onTap: () => onChanged(quantity - 1),
          ),
          SizedBox(
            width: 42,
            child: Text(
              quantity.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: enabled ? Colors.white : Colors.white.withOpacity(0.35),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add_rounded,
            enabled: canIncrease,
            onTap: () => onChanged(quantity + 1),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _StepperButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 34,
        height: 36,
        child: Icon(
          icon,
          color: enabled ? yellow : Colors.white.withOpacity(0.24),
          size: 20,
        ),
      ),
    );
  }
}

class _AddBuffetFooter extends StatelessWidget {
  final int selectedItemsCount;
  final double selectedTotal;
  final bool canSubmit;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const _AddBuffetFooter({
    required this.selectedItemsCount,
    required this.selectedTotal,
    required this.canSubmit,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${"selected_items".tr()}: $selectedItemsCount",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.72),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${_formatPrice(selectedTotal)} ${"s.p".tr()}",
                  style: const TextStyle(
                    color: yellow,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onCancel,
            child: Text(
              "cancel".tr(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.68),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          _PrimarySmallButton(
            label: "add_to_session".tr(),
            icon: Icons.check_rounded,
            enabled: canSubmit,
            onTap: onSubmit,
          ),
        ],
      ),
    );
  }
}

class _PrimarySmallButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _PrimarySmallButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: enabled ? yellow : Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: enabled ? navy : Colors.white.withOpacity(0.38),
                size: 19,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: enabled ? navy : Colors.white.withOpacity(0.38),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddDialogEmptyState extends StatelessWidget {
  final String message;

  const _AddDialogEmptyState({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.62),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

void _showUpdateBuffetOrderDialog(
  BuildContext parentContext,
  Order order,
  void Function(int quantity) onUpdate,
) {
  showDialog(
    context: parentContext,
    builder: (context) {
      return _UpdateBuffetOrderDialog(
        order: order,
        onUpdate: (quantity) {
          Navigator.of(parentContext).pop();
          onUpdate(quantity);
        },
      );
    },
  );
}

class _UpdateBuffetOrderDialog extends StatefulWidget {
  final Order order;
  final void Function(int quantity) onUpdate;

  const _UpdateBuffetOrderDialog({
    required this.order,
    required this.onUpdate,
  });

  @override
  State<_UpdateBuffetOrderDialog> createState() =>
      _UpdateBuffetOrderDialogState();
}

class _UpdateBuffetOrderDialogState extends State<_UpdateBuffetOrderDialog> {
  late int _quantity = widget.order.quantity;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A2F4A),
              Color(0xFF0F1E2E),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NestedDialogHeader(
              title: "update_buffet_quantity".tr(),
              icon: Icons.edit_rounded,
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  Text(
                    widget.order.productName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _QuantityStepper(
                    quantity: _quantity,
                    min: 1,
                    max: 100,
                    enabled: true,
                    onChanged: (quantity) {
                      setState(() => _quantity = quantity);
                    },
                  ),
                ],
              ),
            ),
            _TwoButtonFooter(
              primaryLabel: "edit".tr(),
              primaryIcon: Icons.check_rounded,
              primaryColor: yellow,
              onCancel: () => Navigator.of(context).pop(),
              onPrimary: _quantity == widget.order.quantity
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      widget.onUpdate(_quantity);
                    },
            ),
          ],
        ),
      ),
    );
  }
}

void _showDeleteBuffetOrderDialog(
  BuildContext parentContext,
  Order order,
  VoidCallback onDelete,
) {
  showDialog(
    context: parentContext,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A2F4A),
                Color(0xFF0F1E2E),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NestedDialogHeader(
                title: "delete".tr(),
                icon: Icons.delete_outline_rounded,
                iconColor: Colors.redAccent,
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Text(
                  "delete_buffet_order_message".tr(args: [order.productName]),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.82),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                  ),
                ),
              ),
              _TwoButtonFooter(
                primaryLabel: "delete".tr(),
                primaryIcon: Icons.delete_outline_rounded,
                primaryColor: Colors.redAccent,
                onCancel: () => Navigator.of(context).pop(),
                onPrimary: () {
                  Navigator.of(context).pop();
                  Navigator.of(parentContext).pop();
                  onDelete();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _NestedDialogHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;

  const _NestedDialogHeader({
    required this.title,
    required this.icon,
    this.iconColor = yellow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: iconColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _TwoButtonFooter extends StatelessWidget {
  final String primaryLabel;
  final IconData primaryIcon;
  final Color primaryColor;
  final VoidCallback onCancel;
  final VoidCallback? onPrimary;

  const _TwoButtonFooter({
    required this.primaryLabel,
    required this.primaryIcon,
    required this.primaryColor,
    required this.onCancel,
    required this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPrimary != null;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: onCancel,
            child: Text(
              "cancel".tr(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.68),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPrimary,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: enabled
                      ? primaryColor.withOpacity(0.86)
                      : Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      primaryIcon,
                      color: Colors.white,
                      size: 19,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      primaryLabel,
                      style: TextStyle(
                        color: Colors.white.withOpacity(enabled ? 1 : 0.42),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatPrice(num value) {
  final doubleValue = value.toDouble();
  if (doubleValue == doubleValue.roundToDouble()) {
    return doubleValue.toStringAsFixed(0);
  }
  return doubleValue.toStringAsFixed(2);
}

double _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
