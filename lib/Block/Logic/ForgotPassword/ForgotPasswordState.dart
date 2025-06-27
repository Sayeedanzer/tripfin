import 'package:equatable/equatable.dart';
import 'package:tripfin/Model/SuccessModel.dart';

abstract class ForgotPasswordState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForgotPasswordIntailly extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final SuccessModel successModel;
  ForgotPasswordSuccess({required this.successModel});

  @override
  List<Object?> get props => [successModel];
}

class ForgotPasswordError extends ForgotPasswordState {
  final String message;
  ForgotPasswordError({required this.message});

  @override
  List<Object?> get props => [message];
}
