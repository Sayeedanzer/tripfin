import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripfin/Block/Logic/GetCurrency/GetCurrencyRepository.dart';

import 'GetCurrencyState.dart';


class GetCurrencyCubit extends Cubit<GetCurrenecyState> {
  CurrencyRepo currencyRepo;

  GetCurrencyCubit(this.currencyRepo) : super(GetCurrencyIntailly());
  Future<void> GetCurrency() async {
    emit(GetCurrencyLoading());
    try {
      final res = await currencyRepo.getCurrency();
      if (res != null) {
        if (res.settings?.success == 1) {
          emit(GetCurrencyLoaded(currencyModel: res));
        }
      } else {
        emit(GetCurrencyError(message: res?.settings?.message ?? ""));
      }
    } catch (e) {
      emit(GetCurrencyError(message: "An Error Occured: $e"));
    }
  }
}
