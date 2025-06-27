import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripfin/Block/Logic/CombinedProfile/CombinedProfileState.dart';

import '../Profiledetails/Profile_repository.dart';
import '../TripCount/TripcountRepository.dart';

class CombinedProfileCubit extends Cubit<CombinedProfileState> {
  final GetProfileRepo getProfileRepo;
  final Tripcountrepository tripcountrepository;

  CombinedProfileCubit({
    required this.getProfileRepo,
    required this.tripcountrepository,
  }) : super(CombinedProfileInitial());

  Future<void> fetchCombinedProfile() async {
    try {
      emit(CombinedProfileLoading());

      final profile = await getProfileRepo.getProfile();
      final tripSummary = await tripcountrepository.getTripcount();

      if (profile == null) {
        emit(CombinedProfileError(message: "Failed to fetch profile data"));
        return;
      }

      if (tripSummary == null) {
        emit(CombinedProfileError(message: "Failed to fetch trip summary"));
        return;
      }

      emit(
        CombinedProfileLoaded(
          profileModel: profile,
          tripSummaryModel: tripSummary,
        ),
      );
    } catch (e) {
      emit(CombinedProfileError(message: e.toString()));
    }
  }
}
