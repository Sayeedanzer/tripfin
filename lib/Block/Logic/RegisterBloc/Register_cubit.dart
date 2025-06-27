import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripfin/Block/Logic/LogInBloc/login_cubit.dart';
import 'package:tripfin/Block/Logic/LogInBloc/login_repository.dart';

import '../LogInBloc/login_state.dart';
import 'Register_repository.dart';
import 'Register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterRepository registerRepository;
  RegisterCubit(this.registerRepository) : super(RegisterInitial());

  Future<void> postRegister( Map<String,dynamic> data) async {
    emit(RegisterLoading());
    try {
      final reponse = await registerRepository.postRegister(data);
      if (reponse != null) {
        if (reponse.settings?.success == 1) {
          emit(RegisterSuccessState(message: reponse.settings?.message??"",registerModel: reponse));
        } else {
          emit(RegisterError(message: "${reponse.settings?.message??""}"));
        }
      } else {
        emit(RegisterError(message: "${reponse?.settings?.message??""}"));
      }
    } catch (e) {
      emit(RegisterError(message: "${e}"));
    }
  }
}