import 'package:flutter_bloc/flutter_bloc.dart';
import 'TripcountRepository.dart';
import 'TripcountState.dart';


class Tripcountcubit extends Cubit<Tripcountstate> {
  final Tripcountrepository getTripcountRep;

  Tripcountcubit(this.getTripcountRep) : super(GetTripcountIntailly());
  Future<void> GetTripcount() async {
    emit(GetTripcountLoading());

    try {
      final res = await getTripcountRep.getTripcount();
      if (res != null) {
        if (res.settings.success == 1) {
          emit(GetTripcountLoaded(getTripModel: res));
        }
      } else {
        emit(GetTripcountError(message: res?.settings.message ?? ""));
      }
    } catch (e) {
      emit(GetTripcountError(message: "An Error Occured: $e"));
    }
  }
}
