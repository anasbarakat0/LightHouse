import 'package:bloc/bloc.dart';
import 'package:lighthouse_/core/error/failure.dart';
import 'package:lighthouse_/features/login/data/models/login_model.dart';
import 'package:lighthouse_/features/login/data/models/login_response_model.dart';
import 'package:lighthouse_/features/login/domain/usecase/login_usecase.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;
  LoginBloc(this.loginUsecase) : super(LoginInitial()) {
    on<Login>((event, emit) async {
      print("bloc");
      print("usecase: ${loginUsecase.call(event.user)}");
      var data = await loginUsecase.call(event.user);
      print('data: $data');
      print("${data.runtimeType}");
      data.fold((failure) {
        switch (failure) {
          case OfflineFailure():
          print("case1");
            emit(LoginFailed("Check your network connection"));

            break;
          case LoginFailure():
          print("case2");
            emit(LoginFailed(failure.message));
            break;
          case ServerFailure():
          print("case3");
            emit(LoginFailed(failure.message));
            break;

          default:
          print("case default");
          emit(LoginFailed("Try again later"));
        }
      }, (entity) {
          print("case entity");
        emit(LoginSuccess(data: entity));
      });
    });
  }
}
