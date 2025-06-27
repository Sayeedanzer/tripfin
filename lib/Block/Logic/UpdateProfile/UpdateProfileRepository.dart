import 'package:dio/dio.dart';
import 'package:tripfin/Model/SuccessModel.dart';

import '../../../Model/ProfileUpdateResponseModel.dart';
import '../../../Services/remote_data_source.dart';

abstract class UpdateProfileRepository {
  Future<SuccessModel?> UpdateProfile(Map<String, dynamic> data);
}

class UpdateProfileImpl implements UpdateProfileRepository {
  final RemoteDataSource remoteDataSource;

  const UpdateProfileImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> UpdateProfile(Map<String, dynamic> data) async {
    return await remoteDataSource.updateprofile(data);
  }
}