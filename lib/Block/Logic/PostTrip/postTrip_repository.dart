import '../../../Model/SuccessModel.dart';
import '../../../Services/remote_data_source.dart';

abstract class PostTripRepository {
  Future<SuccessModel?> postTrip(Map<String, dynamic> data);
  Future<SuccessModel?> putTrip(Map<String, dynamic> data, String Id);
  Future<SuccessModel?> deleteTrip(String Id);
}

class PostTripImpl implements PostTripRepository {
  final RemoteDataSource remoteDataSource;

  PostTripImpl({required this.remoteDataSource});

  @override
  Future<SuccessModel?> postTrip(Map<String, dynamic> data) async {
    return await remoteDataSource.postTrip(data);
  }

  Future<SuccessModel?> putTrip(Map<String, dynamic> data, String Id) async {
    return await remoteDataSource.updateCurrentTrip(data, Id);
  }

  Future<SuccessModel?> deleteTrip(String Id) async {
    return await remoteDataSource.deletCurrentTrip(Id);
  }
}
