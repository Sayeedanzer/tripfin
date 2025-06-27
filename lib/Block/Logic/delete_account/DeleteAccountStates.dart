import 'package:equatable/equatable.dart';
import 'package:tripfin/Model/SuccessModel.dart';

abstract class DeleteAccountState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class DeleteAccountIntially extends DeleteAccountState {}

class DeleteAccountLoading extends DeleteAccountState {}

class DeleteAccountSuccessState extends DeleteAccountState {
  final String message;
  final SuccessModel successModel;
  DeleteAccountSuccessState(this.successModel,this.message);
  @override
  List<Object?> get props => [successModel,message];
}

class DeleteAccountError extends DeleteAccountState {
  final String message;
  DeleteAccountError(this.message);

}