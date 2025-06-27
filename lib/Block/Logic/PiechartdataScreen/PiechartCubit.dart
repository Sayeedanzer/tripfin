import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripfin/Block/Logic/PiechartdataScreen/PiechartRepository.dart';
import 'package:tripfin/Model/PiechartExpenceModel.dart';

import 'PiechartState.dart';

class PiechartCubit extends Cubit<PiechartState> {
  final Piechartrepository piechartrepository;

  PiechartCubit(this.piechartrepository) : super(PiechartInitial());

  Future<void> fetchPieChartData(String? tripid) async {
    emit(PiechartLoading());
    try {
      final response = await piechartrepository.Piechartdata(tripid);
      if (response != null) {
        if (response.settings?.success == 1) {
          emit(PiechartSuccess(
            response: response,
            message: response.settings?.message ?? "Data fetched successfully",
          ));
        } else {
          emit(PiechartError(
            message: response.settings?.message ?? "Failed to fetch data",
          ));
        }
      } else {
        emit(PiechartError(message: "No response received"));
      }
    } catch (e) {
      emit(PiechartError(message: e.toString()));
    }
  }
}