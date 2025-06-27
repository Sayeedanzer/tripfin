import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripfin/Block/Logic/CategoryList/CategoryRepository.dart';
import 'package:tripfin/Block/Logic/CategoryList/CategoryState.dart';

class Categorycubit extends Cubit<Categorystate> {
  final Categoryrepository categoryrepository;

  Categorycubit(this.categoryrepository)
      : super(CategoryIntailly());
  Future<void> GetCategory() async {
    emit(CategoryLoading());
    try {
      final res = await categoryrepository.getcategory();
      if (res != null) {
        if (res.settings?.success == 1) {
          emit(CategoryLoaded(categoryresponsemodel: res));
        }
      } else {
        emit(CategoryError(message: res?.settings?.message ?? ""));
      }
    } catch (e) {
      emit(CategoryError(message: "An Error Occured: $e"));
    }
  }
}