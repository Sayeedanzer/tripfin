import '../../../Model/TripsSummaryResponse.dart';
import '../../../Services/remote_data_source.dart';

abstract class Tripcountrepository {

  Future<TripsSummaryResponse?> getTripcount();

}

class GetTripcountImpl implements Tripcountrepository {
  final RemoteDataSource remoteDataSource;
  GetTripcountImpl({required this.remoteDataSource});

  Future<TripsSummaryResponse?> getTripcount() async {
    return await remoteDataSource. getTripcount();
  }


}