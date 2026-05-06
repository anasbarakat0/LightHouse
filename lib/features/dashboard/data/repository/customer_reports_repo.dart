import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/exception.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/features/dashboard/data/models/customer_birthday_reminders_response_model.dart';
import 'package:lighthouse/features/dashboard/data/models/customer_csv_export_model.dart';
import 'package:lighthouse/features/dashboard/data/sources/remote/customer_reports_service.dart';

class CustomerReportsRepo {
  final CustomerReportsService customerReportsService;
  final NetworkConnection networkConnection;

  CustomerReportsRepo({
    required this.customerReportsService,
    required this.networkConnection,
  });

  Future<Either<Failures, CustomerCsvExportModel>>
      exportCustomerContacts() async {
    if (await networkConnection.isConnected) {
      try {
        final data = await customerReportsService.exportCustomerContacts();
        return Right(data);
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(
          ServerFailure(
            message:
                e.response?.data?.toString() ?? e.message ?? 'Unknown error',
          ),
        );
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failures, CustomerCsvExportModel>> exportCustomersByLastVisit({
    required bool includeNeverVisited,
  }) async {
    if (await networkConnection.isConnected) {
      try {
        final data = await customerReportsService.exportCustomersByLastVisit(
          includeNeverVisited: includeNeverVisited,
        );
        return Right(data);
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(
          ServerFailure(
            message:
                e.response?.data?.toString() ?? e.message ?? 'Unknown error',
          ),
        );
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failures, CustomerBirthdayRemindersResponseModel>>
      getBirthdayReminders({
    required int daysBefore,
  }) async {
    if (await networkConnection.isConnected) {
      try {
        final response = await customerReportsService.getBirthdayReminders(
          daysBefore: daysBefore,
        );
        final data = CustomerBirthdayRemindersResponseModel.fromMap(
          response.data,
        );
        return Right(data);
      } on Forbidden {
        return Left(ForbiddenFailure(message: forbiddenMessage));
      } on BAD_REQUEST catch (e) {
        return Left(ServerFailure(message: e.message));
      } on DioException catch (e) {
        return Left(
          ServerFailure(
            message:
                e.response?.data?.toString() ?? e.message ?? 'Unknown error',
          ),
        );
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
