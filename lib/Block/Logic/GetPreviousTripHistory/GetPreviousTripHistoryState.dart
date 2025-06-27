import 'package:equatable/equatable.dart';
import 'package:tripfin/Model/GetPrevousTripModel.dart';

import '../../../Model/GetTripModel.dart';

abstract class GetPrevousTripHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetPreviousTripIntailly extends GetPrevousTripHistoryState {}

class GetPreviousTripLoading extends GetPrevousTripHistoryState {}

class GetPreviousTripLoaded extends GetPrevousTripHistoryState {
  final GetPrevousTripModel getPrevousTripModel;
  GetPreviousTripLoaded({required this.getPrevousTripModel});
}

class GetPreviousTripError extends GetPrevousTripHistoryState {
  final String message;
  GetPreviousTripError({required this.message});
}
