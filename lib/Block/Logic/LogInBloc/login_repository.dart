import '../../../Model/SuccessModel.dart';
import '../../../Services/remote_data_source.dart';

abstract class LoginRepository {
  Future<SuccessModel?> postLogin(Map<String, dynamic> data);
}

class LoginImpl implements LoginRepository {
  final RemoteDataSource remoteDataSource;

  LoginImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> postLogin(Map<String, dynamic> data) async {
    return await remoteDataSource.loginApi(data);
  }


}
