import 'package:tripfin/Model/GetPrevousTripModel.dart';
import 'package:tripfin/Services/remote_data_source.dart';


abstract class GetPreviousTripRepo {
  Future<GetPrevousTripModel?> getPreviousTripHistory();
}

class GetPreviousTripImpl implements GetPreviousTripRepo {
  final RemoteDataSource remoteDataSource;
  GetPreviousTripImpl({required this.remoteDataSource});

  Future<GetPrevousTripModel?> getPreviousTripHistory() async {
    return await remoteDataSource.getPrevousTrip();
  }
}
