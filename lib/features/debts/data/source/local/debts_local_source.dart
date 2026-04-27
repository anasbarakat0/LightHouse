import 'dart:convert';

import 'package:lighthouse/features/debts/data/models/debt_account_model.dart';
import 'package:lighthouse/features/debts/data/models/debt_transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DebtsLocalSource {
  static const String accountsKey = 'debts_v1_accounts';
  static const String transactionsKey = 'debts_v1_transactions';
  static const String sheetUrlKey = 'debts_v1_sheet_url';
  static const String sheetTokenKey = 'debts_v1_sheet_token';

  final SharedPreferences preferences;

  const DebtsLocalSource({
    required this.preferences,
  });

  List<DebtAccount> getAccounts() {
    final data = preferences.getString(accountsKey);
    if (data == null || data.isEmpty) {
      return [];
    }

    try {
      return (json.decode(data) as List<dynamic>)
          .map((item) => DebtAccount.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveAccounts(List<DebtAccount> accounts) async {
    await preferences.setString(
      accountsKey,
      json.encode(accounts.map((account) => account.toMap()).toList()),
    );
  }

  List<DebtTransaction> getTransactions() {
    final data = preferences.getString(transactionsKey);
    if (data == null || data.isEmpty) {
      return [];
    }

    try {
      return (json.decode(data) as List<dynamic>)
          .map((item) => DebtTransaction.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveTransactions(List<DebtTransaction> transactions) async {
    await preferences.setString(
      transactionsKey,
      json.encode(
        transactions.map((transaction) => transaction.toMap()).toList(),
      ),
    );
  }

  String getSheetUrl() => preferences.getString(sheetUrlKey) ?? '';

  String getSheetToken() => preferences.getString(sheetTokenKey) ?? '';

  Future<void> saveSheetConfig({
    required String sheetUrl,
    required String sheetToken,
  }) async {
    await preferences.setString(sheetUrlKey, sheetUrl.trim());
    await preferences.setString(sheetTokenKey, sheetToken.trim());
  }
}
