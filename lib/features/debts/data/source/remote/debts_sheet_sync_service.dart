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
  static const _locationHeader = 'location';

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
    final data = _responseMap(response);

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
    final response = await _resolveRedirect(
      await dio.post(
        sheetUrl,
        data: {
          'action': action,
          'token': sheetToken,
          'payload': payload,
        },
        options: _jsonOptions(followRedirects: false),
      ),
    );
    final data = _responseMap(response);

    if (data['ok'] == false) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: data['message']?.toString() ?? 'Sheet sync failed',
      );
    }

    return response;
  }

  Future<Response> _resolveRedirect(Response response) async {
    final statusCode = response.statusCode ?? 0;
    if (statusCode < 300 || statusCode >= 400) {
      return response;
    }

    final location = response.headers.value(_locationHeader);
    if (location == null || location.trim().isEmpty) {
      throw DioException(
        requestOptions: response.requestOptions,
        message:
            'Apps Script redirected without a target URL. Check the Web App deployment link.',
      );
    }

    final redirectUrl = response.realUri.resolve(location).toString();

    return dio.get(
      redirectUrl,
      options: _jsonOptions(),
    );
  }

  Options _jsonOptions({bool followRedirects = true}) {
    return Options(
      followRedirects: followRedirects,
      maxRedirects: 5,
      validateStatus: (status) =>
          status != null && status >= 200 && status < 400,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
  }

  Map<String, dynamic> _responseMap(Response response) {
    final data = response.data;

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    if (data is String && data.trim().isNotEmpty) {
      try {
        final decoded = json.decode(data);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {
        throw DioException(
          requestOptions: response.requestOptions,
          message:
              'Sheet did not return JSON. Check the Apps Script URL, deployment access, and token.',
        );
      }
    }

    throw DioException(
      requestOptions: response.requestOptions,
      message:
          'Sheet returned an empty response. Check the Apps Script Web App deployment.',
    );
  }
}
