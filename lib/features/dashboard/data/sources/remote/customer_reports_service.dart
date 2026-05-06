import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/app_url.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/utils/service.dart';
import 'package:lighthouse/features/dashboard/data/models/customer_csv_export_model.dart';

class CustomerReportsService extends Service {
  CustomerReportsService({required super.dio});

  Future<CustomerCsvExportModel> exportCustomerContacts() async {
    try {
      response = await dio.get(
        '$baseUrl/api/v1/dashboard/users/export/contacts',
        options: _csvOptions(),
      );

      return CustomerCsvExportModel(
        bytes: _responseBytes(response),
        fileName: _fileNameFromHeaders(
          response,
          'premium-users-contacts.csv',
        ),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<CustomerCsvExportModel> exportCustomersByLastVisit({
    required bool includeNeverVisited,
  }) async {
    try {
      response = await dio.get(
        '$baseUrl/api/v1/dashboard/users/export/last-visits',
        queryParameters: {
          'includeNeverVisited': includeNeverVisited.toString(),
        },
        options: _csvOptions(),
      );

      return CustomerCsvExportModel(
        bytes: _responseBytes(response),
        fileName: _fileNameFromHeaders(
          response,
          'premium-users-last-visits.csv',
        ),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Response> getBirthdayReminders({
    required int daysBefore,
  }) async {
    try {
      response = await dio.get(
        '$baseUrl/api/v1/dashboard/users/birthdays/reminders',
        queryParameters: {
          'daysBefore': daysBefore,
        },
        options: getOptions(auth: true),
      );

      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Options _csvOptions() {
    final authOptions = getOptions(auth: true);
    return Options(
      headers: {
        ...?authOptions.headers,
        'Accept': 'text/csv',
      },
      responseType: ResponseType.bytes,
    );
  }

  List<int> _responseBytes(Response response) {
    final data = response.data;
    if (data is List<int>) {
      return data;
    }
    if (data is List<dynamic>) {
      return data.cast<int>();
    }
    if (data is String) {
      return utf8.encode(data);
    }
    return utf8.encode(data.toString());
  }

  String _fileNameFromHeaders(Response response, String fallback) {
    final contentDisposition = response.headers.value('content-disposition');
    if (contentDisposition == null || contentDisposition.isEmpty) {
      return fallback;
    }

    final match = RegExp(
      r'''filename\*?=(?:UTF-8''|")?([^";]+)"?''',
      caseSensitive: false,
    ).firstMatch(contentDisposition);

    if (match == null) {
      return fallback;
    }

    final fileName = match.group(1);
    if (fileName == null || fileName.trim().isEmpty) {
      return fallback;
    }

    return Uri.decodeFull(fileName.trim());
  }

  void _handleDioError(DioException e) {
    final errorData = _errorData(e);
    final status = errorData?['status'];

    if (status == 'BAD_REQUEST') {
      throw BAD_REQUEST.fromMap(errorData!);
    }

    if (status == 403 ||
        status == 'FORBIDDEN' ||
        e.response?.statusCode == 403) {
      throw Forbidden();
    }
  }

  Map<String, dynamic>? _errorData(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is List<int>) {
      return _decodeJsonMap(utf8.decode(data));
    }

    if (data is String) {
      return _decodeJsonMap(data);
    }

    return null;
  }

  Map<String, dynamic>? _decodeJsonMap(String value) {
    try {
      final decoded = json.decode(value);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      return null;
    }

    return null;
  }
}
