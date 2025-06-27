import '../../../Model/RegisterModel.dart';
import '../../../Services/remote_data_source.dart';

// Abstract repository interface for registration
abstract class RegisterRepository {
  Future<RegisterModel?> postRegister(Map<String, dynamic> data);
}

// Implementation of the registration repository
class RegisterImpl implements RegisterRepository {
  final RemoteDataSource remoteDataSource;

  const RegisterImpl({
    required this.remoteDataSource,
  });

  @override
  Future<RegisterModel?> postRegister(Map<String, dynamic> data) async {
    return await remoteDataSource.registerApi(data);
  }
}