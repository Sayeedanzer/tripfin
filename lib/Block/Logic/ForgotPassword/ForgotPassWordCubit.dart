import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripfin/Block/Logic/ForgotPassword/ForgotPassWordRepository.dart';
import 'ForgotPasswordState.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordRepository forgotPasswordRepository;

  ForgotPasswordCubit(this.forgotPasswordRepository)
    : super(ForgotPasswordIntailly());

  Future<void> Forgotpassword(Map<String, dynamic> data) async {
    emit(ForgotPasswordLoading());
    try {
      final response = await forgotPasswordRepository.forgotPassword(data);
      if (response != null && response.settings?.success == 1) {
        emit(ForgotPasswordSuccess(successModel: response));
      } else {
        emit(ForgotPasswordError(message: response?.settings?.message??""));
      }
    } catch (e) {
      emit(ForgotPasswordError(message: "An error occurred: $e"));
    }
  }

  Future<void> verifyOtp(Map<String, dynamic> data) async {
    emit(ForgotPasswordLoading());
    try {
      final response = await forgotPasswordRepository.VerifyOtp(data);
      if (response != null && response.settings?.success == 1) {
        emit(ForgotPasswordSuccess(successModel: response));
      } else {
        emit(ForgotPasswordError(message: response?.settings?.message ?? ""));
      }
    } catch (e) {
      emit(ForgotPasswordError(message: "An error occurred: $e"));
    }
  }

  Future<void> confirmPassword(Map<String, dynamic> data) async {
    emit(ForgotPasswordLoading());
    try {
      final response = await forgotPasswordRepository.PasswordChange(data);
      if (response != null && response.settings?.success == 1) {
        emit(ForgotPasswordSuccess(successModel: response));
      } else {
        emit(ForgotPasswordError(message: response?.settings?.message ?? ""));
      }
    } catch (e) {
      emit(ForgotPasswordError(message: "An error occurred: $e"));
    }
  }

}
