import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'UpdateProfileRepository.dart';
import 'UpdateProfileState.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final UpdateProfileRepository updateProfileRepository;

  UpdateProfileCubit(this.updateProfileRepository)
    : super(UpdateProfileInitial());

  Future<void> updateProfile(Map<String, dynamic> data) async {
    emit(UpdateProfileLoading());
    try {
      final res = await updateProfileRepository.UpdateProfile(data);
      if (res != null) {
        if (res.settings?.success == 1) {
          emit(UpdateProfileSuccessState(successModel: res));
        }else{
          emit(UpdateProfileError(message: res.settings?.message??""));
        }
      } else {
        emit(UpdateProfileError(message: 'Unexpected null response'));
      }
    } catch (e) {
      emit(UpdateProfileError(message: e.toString()));
    }
  }
}
