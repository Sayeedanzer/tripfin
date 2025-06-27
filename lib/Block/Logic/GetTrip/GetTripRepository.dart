import 'package:tripfin/Services/remote_data_source.dart';

import '../../../Model/GetTripModel.dart';
import '../../../Model/SuccessModel.dart';

abstract class GetTripRep {
  Future<GetTripModel?> getTrip();

}

class GetTripImpl implements GetTripRep {
  final RemoteDataSource remoteDataSource;
  GetTripImpl({required this.remoteDataSource});

  Future<GetTripModel?> getTrip() async {
    return await remoteDataSource.getTrip();
  }

}
