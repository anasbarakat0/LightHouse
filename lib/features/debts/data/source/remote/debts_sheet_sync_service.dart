import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lighthouse/features/debts/data/models/debt_account_model.dart';
import 'package:lighthouse/features/debts/data/models/debt_transaction_model.dart';

class DebtsSheetSnapshot {
  final List<DebtAccount> accounts;
  final List<DebtTransaction> transactions;

  const DebtsSheetSnapshot({
    required this.accounts,
    required this.transactions,
  });
}

class DebtsSheetSyncService {
  final Dio dio;

  const DebtsSheetSyncService({
    required this.dio,
  });

  Future<void> syncAccount({
    required String sheetUrl,
    required String sheetToken,
    required DebtAccount account,
  }) async {
    await _post(
      sheetUrl: sheetUrl,
      sheetToken: sheetToken,
      action: 'upsertAccount',
      payload: account.toMap(),
    );
  }

  Future<void> syncTransaction({
    required String sheetUrl,
    required String sheetToken,
    required DebtTransaction transaction,
  }) async {
    await _post(
      sheetUrl: sheetUrl,
      sheetToken: sheetToken,
      action: 'addTransaction',
      payload: transaction.toMap(),
    );
  }

  Future<DebtsSheetSnapshot> fetchAll({
    required String sheetUrl,
    required String sheetToken,
  }) async {
    final response = await _post(
      sheetUrl: sheetUrl,
      sheetToken: sheetToken,
      action: 'getAll',
      payload: const {},
    );
    final data = _responseMap(response.data);

    if (data['ok'] == false) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: data['message']?.toString() ?? 'Sheet sync failed',
      );
    }

    final payload = (data['data'] as Map?) ?? const {};
    final accounts = ((payload['accounts'] as List?) ?? const [])
        .whereType<Map>()
        .map((item) => DebtAccount.fromMap(Map<String, dynamic>.from(item)))
        .where((account) => account.id.isNotEmpty)
        .toList();
    final transactions = ((payload['transactions'] as List?) ?? const [])
        .whereType<Map>()
        .map(
          (item) => DebtTransaction.fromMap(Map<String, dynamic>.from(item)),
        )
        .where((transaction) => transaction.id.isNotEmpty)
        .toList();

    return DebtsSheetSnapshot(
      accounts: accounts,
      transactions: transactions,
    );
  }

  Future<Response> _post({
    required String sheetUrl,
    required String sheetToken,
    required String action,
    required Map<String, dynamic> payload,
  }) async {
    final response = await dio.post(
      sheetUrl,
      data: {
        'action': action,
        'token': sheetToken,
        'payload': payload,
      },
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = _responseMap(response.data);

    if (data['ok'] == false) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: data['message']?.toString() ?? 'Sheet sync failed',
      );
    }

    return response;
  }

  Map<String, dynamic> _responseMap(dynamic data) {
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    if (data is String && data.trim().isNotEmpty) {
      return Map<String, dynamic>.from(json.decode(data) as Map);
    }

    return const {};
  }
}
