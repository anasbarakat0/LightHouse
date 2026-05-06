part of 'customer_reports_bloc.dart';

abstract class CustomerReportsEvent {}

class ExportCustomerContacts extends CustomerReportsEvent {}

class ExportCustomersByLastVisit extends CustomerReportsEvent {
  final bool includeNeverVisited;

  ExportCustomersByLastVisit({
    required this.includeNeverVisited,
  });
}

class GetCustomerBirthdayReminders extends CustomerReportsEvent {
  final int daysBefore;

  GetCustomerBirthdayReminders({
    this.daysBefore = 7,
  });
}
