import 'package:tripfin/Model/CategoryResponseModel.dart';

import '../../../Services/remote_data_source.dart';

abstract class Categoryrepository {
  Future<Categoryresponsemodel?> getcategory();
}

class GetcategoryImpl implements Categoryrepository {
  final RemoteDataSource remoteDataSource;
  GetcategoryImpl({required this.remoteDataSource});

  Future<Categoryresponsemodel?> getcategory() async {
    return await remoteDataSource.getcategory();
  }
}