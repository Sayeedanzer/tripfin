import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripfin/Block/Logic/GetPreviousTripHistory/GetPreviousTripHistoryRepository.dart';
import 'package:tripfin/Block/Logic/GetPreviousTripHistory/GetPreviousTripHistoryState.dart';

class GetPreviousTripHistoryCubit extends Cubit<GetPrevousTripHistoryState> {
  final GetPreviousTripRepo getPreviousTripRepo;

  GetPreviousTripHistoryCubit(this.getPreviousTripRepo)
    : super(GetPreviousTripIntailly());
  Future<void> GetTrip() async {
    emit(GetPreviousTripLoading());
    try {
      final res = await getPreviousTripRepo.getPreviousTripHistory();
      if (res != null) {
        if (res.settings?.success == 1) {
          emit(GetPreviousTripLoaded(getPrevousTripModel: res));
        }
      } else {
        emit(GetPreviousTripError(message: res?.settings?.message ?? ""));
      }
    } catch (e) {
      emit(GetPreviousTripError(message: "An Error Occured: $e"));
    }
  }
}
