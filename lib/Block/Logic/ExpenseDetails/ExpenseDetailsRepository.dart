import 'package:tripfin/Model/SuccessModel.dart';
import 'package:tripfin/Services/remote_data_source.dart';

import '../../../Model/ExpenseDetailModel.dart';

abstract class GetExpenseDetailRepo {
  Future<ExpenseDetailModel?> getExpensiveDetails(String id);
  Future<SuccessModel?> deleteExpensiveDetails(String id);
  Future<SuccessModel?> putExpensiveDetails(Map<String, dynamic> data,String Id);
  Future<SuccessModel?> postExpenseUpdate(Map<String, dynamic> data);
}

class GetExpenseDetailImpl implements GetExpenseDetailRepo {
  final RemoteDataSource remoteDataSource;
  GetExpenseDetailImpl({required this.remoteDataSource});

  @override
  Future<ExpenseDetailModel?> getExpensiveDetails(id) async {
    return await remoteDataSource.getExpenseDetails(id);
  }

  @override
  Future<SuccessModel?> putExpensiveDetails( Map<String, dynamic> data,String Id) async {
    return await remoteDataSource.updateExpensedata(data,Id);
  }

  @override
  Future<SuccessModel?> postExpenseUpdate(Map<String, dynamic> data) async {
    return await remoteDataSource.postExpense(data);
  }
  @override
  Future<SuccessModel?> deleteExpensiveDetails(String id) async {
    return await remoteDataSource.deleteExpenseDetails(id);
  }
}
