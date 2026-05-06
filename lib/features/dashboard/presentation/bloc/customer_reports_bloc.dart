import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lighthouse/core/constants/messages.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/features/dashboard/data/models/customer_birthday_reminders_response_model.dart';
import 'package:lighthouse/features/dashboard/data/models/customer_csv_export_model.dart';
import 'package:lighthouse/features/dashboard/domain/usecase/customer_reports_usecase.dart';

part 'customer_reports_event.dart';
part 'customer_reports_state.dart';

class CustomerReportsBloc
    extends Bloc<CustomerReportsEvent, CustomerReportsState> {
  final CustomerReportsUsecase customerReportsUsecase;

  CustomerReportsBloc({
    required this.customerReportsUsecase,
  }) : super(CustomerReportsState.initial()) {
    on<ExportCustomerContacts>(_onExportCustomerContacts);
    on<ExportCustomersByLastVisit>(_onExportCustomersByLastVisit);
    on<GetCustomerBirthdayReminders>(_onGetCustomerBirthdayReminders);
  }

  Future<void> _onExportCustomerContacts(
    ExportCustomerContacts event,
    Emitter<CustomerReportsState> emit,
  ) async {
    emit(
      state.copyWith(
        isContactsExporting: true,
        clearCsvExport: true,
        clearError: true,
        forbidden: false,
      ),
    );

    final data = await customerReportsUsecase.exportCustomerContacts();
    data.fold(
      (failure) =>
          emit(_failureState(failure).copyWith(isContactsExporting: false)),
      (csvExport) => emit(
        state.copyWith(
          isContactsExporting: false,
          csvExport: csvExport,
          lastCompletedAction: CustomerReportAction.contacts,
          clearError: true,
          forbidden: false,
        ),
      ),
    );
  }

  Future<void> _onExportCustomersByLastVisit(
    ExportCustomersByLastVisit event,
    Emitter<CustomerReportsState> emit,
  ) async {
    emit(
      state.copyWith(
        isLastVisitsExporting: true,
        clearCsvExport: true,
        clearError: true,
        forbidden: false,
      ),
    );

    final data = await customerReportsUsecase.exportCustomersByLastVisit(
      includeNeverVisited: event.includeNeverVisited,
    );
    data.fold(
      (failure) => emit(
        _failureState(failure).copyWith(isLastVisitsExporting: false),
      ),
      (csvExport) => emit(
        state.copyWith(
          isLastVisitsExporting: false,
          csvExport: csvExport,
          lastCompletedAction: CustomerReportAction.lastVisits,
          clearError: true,
          forbidden: false,
        ),
      ),
    );
  }

  Future<void> _onGetCustomerBirthdayReminders(
    GetCustomerBirthdayReminders event,
    Emitter<CustomerReportsState> emit,
  ) async {
    emit(
      state.copyWith(
        isBirthdaysLoading: true,
        birthdayDaysBefore: event.daysBefore,
        clearError: true,
        forbidden: false,
      ),
    );

    final data = await customerReportsUsecase.getBirthdayReminders(
      daysBefore: event.daysBefore,
    );
    data.fold(
      (failure) =>
          emit(_failureState(failure).copyWith(isBirthdaysLoading: false)),
      (response) => emit(
        state.copyWith(
          isBirthdaysLoading: false,
          birthdayReminders: response,
          birthdayDaysBefore: event.daysBefore,
          clearError: true,
          forbidden: false,
        ),
      ),
    );
  }

  CustomerReportsState _failureState(Failures failure) {
    switch (failure) {
      case ServerFailure():
        return state.copyWith(
          errorMessage: failure.message,
          forbidden: false,
        );
      case OfflineFailure():
        return state.copyWith(
          errorMessage: connectionMessage,
          forbidden: false,
        );
      case ForbiddenFailure():
        return state.copyWith(
          errorMessage: failure.message,
          forbidden: true,
        );
      default:
        return state.copyWith(
          errorMessage: 'Unknown error',
          forbidden: false,
        );
    }
  }
}
