import 'package:flutter_bloc/flutter_bloc.dart';
import 'ExpenseDetailsRepository.dart';
import 'ExpenseDetailsState.dart';

class GetExpenseDetailCubit extends Cubit<GetExpenseDetailsState> {
  final GetExpenseDetailRepo ExpenseDetailRepo;
  GetExpenseDetailCubit(this.ExpenseDetailRepo) : super(GetExpenseDetailIntailly());

  Future<void> GetExpenseDetails(String id) async {
    emit(GetExpenseDetailLoading());
    try {
      final res = await ExpenseDetailRepo.getExpensiveDetails(id);
      if (res != null && res.settings?.success == 1) {
        emit(GetExpenseDetailLoaded(expenseDetailModel: res));
      } else {
        emit(GetExpenseDetailError(message: res?.settings?.message ?? "Failed to fetch expense details"));
      }
    } catch (e) {
      emit(GetExpenseDetailError(message: "An error occurred: $e"));
    }
  }

  Future<void> updateExpenseDetails(Map<String, dynamic> data, String id) async {
    emit(SaveExpenseDetailLoading());
    try {
      final res = await ExpenseDetailRepo.putExpensiveDetails(data, id);
      if (res != null && res.settings?.success == 1) {
        emit(ExpenceDetailSuccess(successModel: res));
      } else {
        emit(GetExpenseDetailError(message: res?.settings?.message ?? "Failed to update expense"));
      }
    } catch (e) {
      emit(GetExpenseDetailError(message: "An error occurred: $e"));
    }
  }

  Future<void> addExpense(Map<String, dynamic> data) async {
    emit(SaveExpenseDetailLoading());
    try {
      final res = await ExpenseDetailRepo.postExpenseUpdate(data);
      if (res != null && res.settings?.success == 1) {
        emit(ExpenceDetailSuccess(successModel: res));
      } else {
        emit(GetExpenseDetailError(message: res?.settings?.message ?? "Failed to add expense"));
      }
    } catch (e) {
      emit(GetExpenseDetailError(message: "An error occurred: $e"));
    }
  }

  Future<void> deleteExpenseDetails(String id) async {
    emit(GetExpenseDetailLoading());
    try {
      final res = await ExpenseDetailRepo.deleteExpensiveDetails(id);
      if (res != null && res.settings?.success == 1) {
        emit(ExpenceDetailSuccess(successModel: res));
      } else {
        emit(GetExpenseDetailError(message: res?.settings?.message ?? "Failed to delete expense"));
      }
    } catch (e) {
      emit(GetExpenseDetailError(message: "An error occurred: $e"));
    }
  }
}