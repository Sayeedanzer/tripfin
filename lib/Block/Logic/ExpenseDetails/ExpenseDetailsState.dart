import 'package:equatable/equatable.dart';
import 'package:tripfin/Model/ExpenseDetailModel.dart';
import 'package:tripfin/Model/SuccessModel.dart';

abstract class GetExpenseDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetExpenseDetailIntailly extends GetExpenseDetailsState {}

class GetExpenseDetailLoading extends GetExpenseDetailsState {}

class SaveExpenseDetailLoading extends GetExpenseDetailsState {}

class ExpenceDetailSuccess extends GetExpenseDetailsState {
  final SuccessModel successModel;
  ExpenceDetailSuccess({required this.successModel});

  @override
  List<Object?> get props => [successModel];
}

class GetExpenseDetailLoaded extends GetExpenseDetailsState {
  final ExpenseDetailModel expenseDetailModel;
  GetExpenseDetailLoaded({required this.expenseDetailModel});

  @override
  List<Object?> get props => [expenseDetailModel];
}

class GetExpenseDetailError extends GetExpenseDetailsState {
  final String message;
  GetExpenseDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}