import 'package:equatable/equatable.dart';

import '../../../Model/GetProfileModel.dart';
import '../../../Model/TripsSummaryResponse.dart';


abstract class CombinedProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CombinedProfileInitial extends CombinedProfileState {}

class CombinedProfileLoading extends CombinedProfileState {}

class CombinedProfileLoaded extends CombinedProfileState {
  final GetprofileModel profileModel;
  final TripsSummaryResponse tripSummaryModel;

  CombinedProfileLoaded({
    required this.profileModel,
    required this.tripSummaryModel,
  });

  @override
  List<Object?> get props => [profileModel, tripSummaryModel];
}

class CombinedProfileError extends CombinedProfileState {
  final String message;

  CombinedProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}
