part of 'admin_by_id_bloc.dart';

@immutable
abstract class AdminByIdState {}

class AdminByIdInitial extends AdminByIdState {}


class SuccessGettingAdmin extends AdminByIdState {
  final AdminByIdResponseModel response;
  SuccessGettingAdmin({
    required this.response,
  });
}

class ExceptionGettingAdmin extends AdminByIdState {
  final String message;
  ExceptionGettingAdmin({
    required this.message,
  });
}

class ForbiddenGetting extends AdminByIdState {
  final String message;
  ForbiddenGetting({
    required this.message,
  });
}

class OfflineGetting extends AdminByIdState {
  final String message;
  OfflineGetting({
    required this.message,
  });
}

class LoadingGettingAdmin extends AdminByIdState{}