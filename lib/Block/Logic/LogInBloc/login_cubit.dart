import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository loginRepository;

  LoginCubit(this.loginRepository) : super(LoginInitial());

  Future<void> postLogIn(Map<String, dynamic> data) async {
    emit(LoginLoading());
    try {
      final response = await loginRepository.postLogin(data);
      if (response != null) {
        if (response.settings?.success == 1) {
          emit(LoginSuccessState(
            loginModel: response,
            message: response.settings?.message ?? "",
          ));
        } else {
          emit(LoginError(message: response.settings?.message ?? ""));
        }
      } else {
        emit(LoginError(message: "No response received."));
      }
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }
}
