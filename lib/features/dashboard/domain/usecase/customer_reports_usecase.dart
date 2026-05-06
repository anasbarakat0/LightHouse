import 'package:dartz/dartz.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/dashboard/data/models/customer_birthday_reminders_response_model.dart';
import 'package:lighthouse/features/dashboard/data/models/customer_csv_export_model.dart';
import 'package:lighthouse/features/dashboard/data/repository/customer_reports_repo.dart';

class CustomerReportsUsecase {
  final CustomerReportsRepo customerReportsRepo;

  CustomerReportsUsecase({
    required this.customerReportsRepo,
  });

  Future<Either<Failures, CustomerCsvExportModel>>
      exportCustomerContacts() async {
    return await customerReportsRepo.exportCustomerContacts();
  }

  Future<Either<Failures, CustomerCsvExportModel>> exportCustomersByLastVisit({
    required bool includeNeverVisited,
  }) async {
    return await customerReportsRepo.exportCustomersByLastVisit(
      includeNeverVisited: includeNeverVisited,
    );
  }

  Future<Either<Failures, CustomerBirthdayRemindersResponseModel>>
      getBirthdayReminders({
    required int daysBefore,
  }) async {
    return await customerReportsRepo.getBirthdayReminders(
      daysBefore: daysBefore,
    );
  }
}
