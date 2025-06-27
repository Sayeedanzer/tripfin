import 'package:equatable/equatable.dart';

import '../../../Model/GetCurrencyModel.dart';


abstract class GetCurrenecyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCurrencyIntailly extends GetCurrenecyState {}

class GetCurrencyLoading extends GetCurrenecyState {}

class GetCurrencyLoaded extends GetCurrenecyState {
  final GetCurrencyModel currencyModel;
  GetCurrencyLoaded({required this.currencyModel});
}

class GetCurrencyError extends GetCurrenecyState {
  final String message;
  GetCurrencyError({required this.message});
}
