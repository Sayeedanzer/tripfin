import 'package:equatable/equatable.dart';
import 'package:tripfin/Model/CategoryResponseModel.dart';

abstract class Categorystate extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoryIntailly extends Categorystate {}

class CategoryLoading extends Categorystate {}

class CategoryLoaded extends Categorystate {
  final Categoryresponsemodel categoryresponsemodel;
  CategoryLoaded({required this.categoryresponsemodel});
}

class CategoryError extends Categorystate {
  final String message;
  CategoryError({required this.message});
}
