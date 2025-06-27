import 'package:equatable/equatable.dart';
import '../../../Model/SuccessModel.dart';

abstract class postTripState extends Equatable {
  const postTripState();

  @override
  List<Object?> get props => [];
}

class PostTripInitial extends postTripState {

}

class PostTripLoading extends postTripState {
}
class PostTripSuccessState extends postTripState {
  final SuccessModel successModel;
  const PostTripSuccessState({required this.successModel});

  @override
  List<Object?> get props => [SuccessModel];
}

class PostTripError extends postTripState {
  final String message;

  const PostTripError({required this.message});

  @override
  List<Object?> get props => [message];
}
