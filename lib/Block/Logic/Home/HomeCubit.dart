import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tripfin/Model/GetTripModel.dart';

import '../../../Model/GetPrevousTripModel.dart';
import '../../../Model/GetProfileModel.dart';
import '../../../Services/AuthService.dart';
import '../GetPreviousTripHistory/GetPreviousTripHistoryRepository.dart';
import '../GetTrip/GetTripRepository.dart';
import '../Profiledetails/Profile_repository.dart';
import 'HomeState.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetTripRep getTripRep;
  final GetPreviousTripRepo getPreviousTripRepo;
  final GetProfileRepo getProfileRepo;

  HomeCubit(this.getTripRep, this.getPreviousTripRepo, this.getProfileRepo)
    : super(HomeInitial());

  Future<void> fetchHomeData() async {
    emit(HomeLoading());
    try {
      final futures = <Future<dynamic>>[];
      final isGuest = await AuthService.isGuest;

      GetTripModel? tripData;
      GetPrevousTripModel? previousTrips;
      GetprofileModel? profile;

      if (!isGuest) {
        futures.add(getTripRep.getTrip());
        futures.add(getPreviousTripRepo.getPreviousTripHistory());
        futures.add(getProfileRepo.getProfile());
        final results = await Future.wait(futures);

        tripData = results[0] as GetTripModel;
        previousTrips = results[1] as GetPrevousTripModel;
        profile = results[2] as GetprofileModel;
      }

      emit(HomeLoaded(
        getTripModel: tripData,               // may be null
        getPrevousTripModel: previousTrips,   // may be null
        profileModel: profile,                // may be null
      ));

    } catch (e, stackTrace) {
      debugPrint("HomeCubit Error: $e\n$stackTrace");
      emit(HomeError("Failed to fetch home data. Please try again later."));
    }
  }

}
