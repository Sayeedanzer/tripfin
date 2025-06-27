import 'package:equatable/equatable.dart';
import '../../../Model/SuccessModel.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

// Initial state when the registration process has not started
class LoginInitial extends LoginState {
  const LoginInitial();
}

// Loading state when the registration API call is in progress
class LoginLoading extends LoginState {
  const LoginLoading();
}

// Success state when registration is successful
class LoginSuccessState extends LoginState {
  final SuccessModel loginModel;
  final String message;

  const LoginSuccessState({
    required this.loginModel,
    required this.message,
  });

  @override
  List<Object?> get props => [SuccessModel, message];
}

// Error state when registration fails
class LoginError extends LoginState {
  final String message;

  const LoginError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}