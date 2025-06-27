import 'package:tripfin/Services/remote_data_source.dart';

import '../../../Model/GetCurrencyModel.dart';

abstract class CurrencyRepo {
  Future<GetCurrencyModel?> getCurrency();
}

class CurrencyImpl extends CurrencyRepo {
  final RemoteDataSource remoteDataSource;
  CurrencyImpl(this.remoteDataSource);
  @override
  Future<GetCurrencyModel?> getCurrency() async {
    return await remoteDataSource.getCurrency();
  }
}
