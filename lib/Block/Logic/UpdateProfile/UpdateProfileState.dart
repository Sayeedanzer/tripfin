import 'package:equatable/equatable.dart';
import '../../../Model/SuccessModel.dart';

abstract class UpdateProfileState extends Equatable {
  const UpdateProfileState();

  @override
  List<Object?> get props => [];
}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileSuccessState extends UpdateProfileState {
  final SuccessModel successModel;

  const UpdateProfileSuccessState({required this.successModel});

  @override
  List<Object?> get props => [successModel];
}

class UpdateProfileError extends UpdateProfileState {
  final String message;

  const UpdateProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}
