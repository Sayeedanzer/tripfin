import 'package:equatable/equatable.dart';
import '../../../Model/RegisterModel.dart';

// Abstract base state for registration, using Equatable for state comparison
abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

// Initial state when the registration process has not started
class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

// Loading state when the registration API call is in progress
class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

// Success state when registration is successful
class RegisterSuccessState extends RegisterState {
  final RegisterModel registerModel;
  final String message;

  const RegisterSuccessState({
    required this.registerModel,
    required this.message,
  });

  @override
  List<Object?> get props => [registerModel, message];
}

// Error state when registration fails
class RegisterError extends RegisterState {
  final String message;

  const RegisterError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}