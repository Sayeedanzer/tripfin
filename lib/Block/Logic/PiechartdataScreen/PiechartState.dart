import '../../../Model/PiechartExpenceModel.dart';

abstract class PiechartState {}

class PiechartInitial extends PiechartState {}

class PiechartLoading extends PiechartState {}

class PiechartSuccess extends PiechartState {
  final Piechartexpencemodel response;
  final String message;

  PiechartSuccess({required this.response, required this.message});
}

class PiechartError extends PiechartState {
  final String message;

  PiechartError({required this.message});


}
