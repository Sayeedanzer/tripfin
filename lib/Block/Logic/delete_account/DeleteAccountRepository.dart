

import 'package:tripfin/Model/SuccessModel.dart';

import '../../../Services/remote_data_source.dart';

abstract class Deleteaccountrepository {
  Future<SuccessModel?> deleteAccount();
}

class DeleteaccountrepositoryImpl implements Deleteaccountrepository {
  RemoteDataSource remoteDataSource;
  DeleteaccountrepositoryImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> deleteAccount() async {
    return await remoteDataSource.deleteAccount();
  }
}