import 'package:equatable/equatable.dart';
import 'package:tripfin/Model/SuccessModel.dart';

import '../../../Model/GetTripModel.dart';

abstract class GetTripState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetTripIntailly extends GetTripState {}

class GetTripLoading extends GetTripState {}

class GetTripLoaded extends GetTripState {
  final GetTripModel getTripModel;
  GetTripLoaded({required this.getTripModel});
}


class GetTripError extends GetTripState {
  final String message;
  GetTripError({required this.message});
}
