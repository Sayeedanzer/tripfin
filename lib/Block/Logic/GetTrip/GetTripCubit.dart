import 'package:flutter_bloc/flutter_bloc.dart';
import 'GetTripRepository.dart';
import 'GetTripState.dart';

class GetTripCubit extends Cubit<GetTripState> {
  final GetTripRep getTripRep;

  GetTripCubit(this.getTripRep) : super(GetTripIntailly());
  Future<void> GetTrip() async {
    emit(GetTripLoading());
    try {
      final res = await getTripRep.getTrip();
      if (res != null) {
        if (res.settings?.success == 1) {
          emit(GetTripLoaded(getTripModel: res));
        }
      } else {
        emit(GetTripError(message: res?.settings?.message ?? ""));
      }
    } catch (e) {
      emit(GetTripError(message: "An Error Occured: $e"));
    }
  }


}
