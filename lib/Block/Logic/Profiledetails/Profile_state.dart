import 'package:equatable/equatable.dart';
import 'package:tripfin/Model/GetProfileModel.dart';


abstract class GetProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProfileIntailly extends GetProfileState {}

class GetProfileLoading extends GetProfileState {}

class GetProfileLoaded extends GetProfileState {
  final GetprofileModel getprofileModel;
  GetProfileLoaded({required this.getprofileModel});
}

class GetProfileError extends GetProfileState {
  final String message;
  GetProfileError({required this.message});
}
