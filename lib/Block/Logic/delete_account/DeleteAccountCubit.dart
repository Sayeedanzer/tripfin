import 'package:flutter_bloc/flutter_bloc.dart';
import 'DeleteAccountRepository.dart';
import 'DeleteAccountStates.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  Deleteaccountrepository deleteaccountrepository;

  DeleteAccountCubit(this.deleteaccountrepository) : super(DeleteAccountIntially());

  Future<void> deleteAccount() async {
    emit(DeleteAccountLoading());
    try {
      final response = await deleteaccountrepository.deleteAccount();

      if (response != null) {
        if (response.settings?.success == 1) {
          emit(DeleteAccountSuccessState(response, response.settings?.message ?? "Deleted successfully!"));
        } else {
          emit(DeleteAccountError("${response.settings?.message}"));
        }
      } else {
        emit(DeleteAccountError("Unexpected error occurred. Please try again later."));
      }
    } catch (e) {
      emit(DeleteAccountError(
          "An error occurred while logging in. Please check your network connection and try again."));
    }
  }
}