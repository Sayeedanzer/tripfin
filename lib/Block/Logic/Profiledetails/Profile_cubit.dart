import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripfin/Block/Logic/Profiledetails/Profile_repository.dart';
import 'package:tripfin/Block/Logic/Profiledetails/Profile_state.dart';

class ProfileCubit extends Cubit<GetProfileState> {


  final GetProfileRepo getProfileRepo;

  ProfileCubit(this.getProfileRepo)
      : super(GetProfileIntailly());
  Future<void> GetProfile() async {
    emit(GetProfileLoading());
    try {
      final res = await getProfileRepo.getProfile();
      if (res != null) {
        if (res.settings?.success == 1) {
          emit(GetProfileLoaded(getprofileModel: res));
        }
      } else {
        emit(GetProfileError(message: res?.settings?.message ?? ""));
      }
    } catch (e) {
      emit(GetProfileError(message: "An Error Occured: $e"));
    }
  }
}