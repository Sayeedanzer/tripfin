import 'package:tripfin/Model/PiechartExpenceModel.dart';

import '../../../Services/remote_data_source.dart';

abstract class Piechartrepository {
  Future<Piechartexpencemodel?> Piechartdata(String? tripid);
}

class PiedataImpl implements Piechartrepository {
  final RemoteDataSource remoteDataSource;

  PiedataImpl({required this.remoteDataSource});

  @override
  Future<Piechartexpencemodel?> Piechartdata(String? tripid) async {
    return await remoteDataSource.Piechartdata(tripid);
  }


}