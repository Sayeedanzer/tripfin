import 'package:tripfin/Model/GetProfileModel.dart';

import '../../../Services/remote_data_source.dart';

abstract class GetProfileRepo {
  Future<GetprofileModel?> getProfile();
}

class GetProfileImpl implements GetProfileRepo {
  final RemoteDataSource remoteDataSource;
  GetProfileImpl({required this.remoteDataSource});

  Future<GetprofileModel?> getProfile() async {
    return await remoteDataSource.getProfiledetails();
  }
}