import 'package:flutter_bloc/flutter_bloc.dart';

import 'postTrip_repository.dart';
import 'potTrip_state.dart';

class postTripCubit extends Cubit<postTripState> {
  final PostTripRepository postTripRepository;

  postTripCubit(this.postTripRepository) : super(PostTripInitial());

  Future<void> postTrip(Map<String, dynamic> data) async {
    emit(PostTripLoading());
    try {
      final response = await postTripRepository.postTrip(data);
      if (response != null) {
        if (response.settings?.success == 1) {
          emit(PostTripSuccessState(successModel: response));
        } else {
          emit(PostTripError(message: response.settings?.message ?? ""));
        }
      } else {
        emit(PostTripError(message: "No response received."));
      }
    } catch (e) {
      emit(PostTripError(message: e.toString()));
    }
  }

  Future<void> putTrip(Map<String, dynamic> data, String Id) async {
    emit(PostTripLoading());
    try {
      final res = await postTripRepository.putTrip(data, Id);
      if (res != null) {
        if (res.settings?.success == 1) {
          emit(PostTripSuccessState(successModel: res));
        }
      } else {
        emit(PostTripError(message: res?.settings?.message ?? ""));
      }
    } catch (e) {
      emit(PostTripError(message: "An Error Occured: $e"));
    }
  }

  Future<void> deleteTrip(String Id) async {
    emit(PostTripLoading());
    try {
      final res = await postTripRepository.deleteTrip(Id);
      if (res != null) {
        if (res.settings?.success == 1) {
          emit(PostTripSuccessState(successModel: res));
        }
      } else {
        emit(PostTripError(message: res?.settings?.message ?? ""));
      }
    } catch (e) {
      emit(PostTripError(message: "An Error Occured: $e"));
    }
  }
}
