import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripfin/Block/Logic/TripFinish/TripFinishRepository.dart';
import 'package:tripfin/Block/Logic/TripFinish/TripFinishState.dart';

class TripFinishCubit extends Cubit<TripFinishState> {
  final TripFinishRepository updateProfileRepository;

  TripFinishCubit(this.updateProfileRepository) : super(FinishTripInitial());

  Future<void> finishTrip(Map<String, dynamic> data) async {
    emit(FinishTripLoading());
    try {
      final res = await updateProfileRepository.finishtrip(data);
      if (res != null) {
        if (res.settings?.success == 1) {
          emit(FinishTripSuccessState(finishTripModel: res));
        }
      } else {
        emit(FinishTripError(message: 'Unexpected null response'));
      }
    } catch (e) {
      emit(FinishTripError(message: e.toString()));
    }
  }
}
