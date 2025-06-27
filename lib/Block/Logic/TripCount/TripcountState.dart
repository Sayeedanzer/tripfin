import 'package:equatable/equatable.dart';
import 'package:tripfin/Model/TripsSummaryResponse.dart';

abstract class Tripcountstate extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetTripcountIntailly extends Tripcountstate {}

class GetTripcountLoading extends Tripcountstate {}

class GetTripcountLoaded extends Tripcountstate {
  final TripsSummaryResponse getTripModel;
  GetTripcountLoaded({required this.getTripModel});

}

class GetTripcountError extends Tripcountstate {
  final String message;
  GetTripcountError({required this.message});

}
