
import '../../../Model/FinishTripModel.dart';
import '../../../Services/remote_data_source.dart';

abstract class TripFinishRepository{
  Future<FinishTripModel?> finishtrip(Map<String, dynamic> data);
}

class FinishTripImpl implements TripFinishRepository {
  final RemoteDataSource remoteDataSource;

  const FinishTripImpl({required this.remoteDataSource});

  @override
  Future<FinishTripModel?> finishtrip(Map<String, dynamic> data) async {
    return await remoteDataSource.finishtrip(data);
  }
}
