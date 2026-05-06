part of 'customer_reports_bloc.dart';

enum CustomerReportAction {
  contacts,
  lastVisits,
}

class CustomerReportsState {
  final bool isContactsExporting;
  final bool isLastVisitsExporting;
  final bool isBirthdaysLoading;
  final int birthdayDaysBefore;
  final CustomerBirthdayRemindersResponseModel? birthdayReminders;
  final CustomerCsvExportModel? csvExport;
  final CustomerReportAction? lastCompletedAction;
  final String? errorMessage;
  final bool forbidden;

  CustomerReportsState({
    required this.isContactsExporting,
    required this.isLastVisitsExporting,
    required this.isBirthdaysLoading,
    required this.birthdayDaysBefore,
    this.birthdayReminders,
    this.csvExport,
    this.lastCompletedAction,
    this.errorMessage,
    required this.forbidden,
  });

  factory CustomerReportsState.initial() {
    return CustomerReportsState(
      isContactsExporting: false,
      isLastVisitsExporting: false,
      isBirthdaysLoading: false,
      birthdayDaysBefore: 7,
      forbidden: false,
    );
  }

  CustomerReportsState copyWith({
    bool? isContactsExporting,
    bool? isLastVisitsExporting,
    bool? isBirthdaysLoading,
    int? birthdayDaysBefore,
    CustomerBirthdayRemindersResponseModel? birthdayReminders,
    CustomerCsvExportModel? csvExport,
    CustomerReportAction? lastCompletedAction,
    String? errorMessage,
    bool? forbidden,
    bool clearCsvExport = false,
    bool clearError = false,
  }) {
    return CustomerReportsState(
      isContactsExporting: isContactsExporting ?? this.isContactsExporting,
      isLastVisitsExporting:
          isLastVisitsExporting ?? this.isLastVisitsExporting,
      isBirthdaysLoading: isBirthdaysLoading ?? this.isBirthdaysLoading,
      birthdayDaysBefore: birthdayDaysBefore ?? this.birthdayDaysBefore,
      birthdayReminders: birthdayReminders ?? this.birthdayReminders,
      csvExport: clearCsvExport ? null : csvExport ?? this.csvExport,
      lastCompletedAction: clearCsvExport
          ? null
          : lastCompletedAction ?? this.lastCompletedAction,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      forbidden: forbidden ?? this.forbidden,
    );
  }
}
