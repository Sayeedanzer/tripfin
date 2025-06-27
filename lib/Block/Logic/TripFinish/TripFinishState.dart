import 'package:equatable/equatable.dart';
import 'package:tripfin/Model/FinishTripModel.dart';
import '../../../Model/SuccessModel.dart';

abstract class TripFinishState extends Equatable {
  const TripFinishState();

  @override
  List<Object?> get props => [];
}

class FinishTripInitial extends TripFinishState {}

class FinishTripLoading extends TripFinishState {}

class FinishTripSuccessState extends TripFinishState {
  final FinishTripModel finishTripModel;

  const FinishTripSuccessState({required this.finishTripModel});

}

class FinishTripError extends TripFinishState {
  final String message;

  const FinishTripError({required this.message});

  @override
  List<Object?> get props => [message];
}