import '../../../Model/SuccessModel.dart';
import '../../../Services/remote_data_source.dart';

abstract class ForgotPasswordRepository {
  Future<SuccessModel?> forgotPassword(Map<String, dynamic> data);
  Future<SuccessModel?> VerifyOtp(Map<String, dynamic> data);
  Future<SuccessModel?> PasswordChange(Map<String, dynamic> data);
}

class ForgotPasswordImpl implements ForgotPasswordRepository {
  final RemoteDataSource remoteDataSource;

  ForgotPasswordImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> forgotPassword(Map<String, dynamic> data) async {
    return await remoteDataSource.ForgotpasswordApi(data);
  }
  @override
  Future<SuccessModel?> VerifyOtp(Map<String, dynamic> data) async {
    return await remoteDataSource.VerifyOtp(data);
  }
  @override
  Future<SuccessModel?> PasswordChange(Map<String, dynamic> data) async {
    return await remoteDataSource.ChangePassword(data);
  }
}
