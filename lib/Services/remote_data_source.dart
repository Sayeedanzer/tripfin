import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripfin/Model/GetPrevousTripModel.dart';
import 'package:tripfin/Model/PiechartExpenceModel.dart';
import '../Model/CategoryResponseModel.dart';
import '../Model/ExpenseDetailModel.dart';
import '../Model/FinishTripModel.dart';
import '../Model/GetCurrencyModel.dart';
import '../Model/GetProfileModel.dart';
import '../Model/GetTripModel.dart';
import '../Model/RegisterModel.dart';
import '../Model/SuccessModel.dart';
import '../Model/TripsSummaryResponse.dart';
import 'ApiClient.dart';
import 'api_endpoint_urls.dart';

abstract class RemoteDataSource {
  Future<RegisterModel?> registerApi(Map<String, dynamic> data);
  Future<SuccessModel?> loginApi(Map<String, dynamic> data);
  Future<GetTripModel?> getTrip();
  Future<GetPrevousTripModel?> getPrevousTrip();
  Future<GetprofileModel?> getProfiledetails();
  Future<TripsSummaryResponse?> getTripcount();
  Future<Categoryresponsemodel?> getcategory();
  Future<ExpenseDetailModel?> getExpenseDetails(String id);
  Future<GetCurrencyModel?> getCurrency();
  Future<SuccessModel?> postExpense(Map<String, dynamic> data);
  Future<Piechartexpencemodel?> Piechartdata(String? tripid);
  Future<SuccessModel?> updateExpensedata(Map<String, dynamic> data, String Id);
  Future<SuccessModel?> deleteExpenseDetails(String id);
  Future<SuccessModel?> postTrip(Map<String, dynamic> data);
  Future<FinishTripModel?> finishtrip(Map<String, dynamic> data);
  Future<SuccessModel?> updateprofile(Map<String, dynamic> data);
  Future<SuccessModel?> updateCurrentTrip(Map<String, dynamic> data, String Id);
  Future<SuccessModel?> deletCurrentTrip(String id);
  Future<SuccessModel?> ForgotpasswordApi(Map<String, dynamic> data);
  Future<SuccessModel?> VerifyOtp(Map<String, dynamic> data);
  Future<SuccessModel?> ChangePassword(Map<String, dynamic> data);
  Future<SuccessModel?> deleteAccount();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  Future<FormData> buildFormData(Map<String, dynamic> data) async {
    final formMap = <String, dynamic>{};
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value == null) continue;

      if (value is File &&
          (key.contains('image') ||
              key.contains('file') ||
              key.contains('picture') ||
              key.contains('payment_screenshot'))) {
        formMap[key] = await MultipartFile.fromFile(
          value.path,
          filename: value.path.split('/').last,
        );
      } else {
        formMap[key] = value.toString();
      }
    }

    return FormData.fromMap(formMap);
  }

  @override
  Future<SuccessModel?> deleteAccount() async {
    Response response = await ApiClient.delete(APIEndpointUrls.delete_account);
    try {
      if (response.statusCode == 200) {
        debugPrint('deleteAccount:${response.data}');
        return SuccessModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      debugPrint('Error deleteAccount::$e');
      return null;
    }
  }

  @override
  Future<RegisterModel?> registerApi(Map<String, dynamic> data) async {
    try {
      Response response = await ApiClient.post(
        APIEndpointUrls.register,
        data: data,
      );
      if (response.statusCode == 200) {
        debugPrint('registerApi:${response.data}');
        return RegisterModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error registerApi::$e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> loginApi(Map<String, dynamic> data) async {
    try {
      Response response = await ApiClient.post(
        APIEndpointUrls.login,
        data: data,
      );
      if (response.statusCode == 200) {
        debugPrint('loginApi:${response.data}');
        return SuccessModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error loginApi::$e');
      return null;
    }
  }

  @override
  Future<GetTripModel?> getTrip() async {
    try {
      Response res = await ApiClient.get(APIEndpointUrls.getTrip);
      if (res.statusCode == 200) {
        debugPrint('getTrip:${res.data}');
        return GetTripModel.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error getTrip::$e');
      return null;
    }
  }

  @override
  Future<GetPrevousTripModel?> getPrevousTrip() async {
    try {
      Response res = await ApiClient.get(APIEndpointUrls.getPreviousTrip);
      if (res.statusCode == 200) {
        debugPrint('getPrevousTrip:${res.data}');
        return GetPrevousTripModel.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error getPrevousTrip::$e');
      return null;
    }
  }

  @override
  Future<GetprofileModel?> getProfiledetails() async {
    try {
      Response res = await ApiClient.get(APIEndpointUrls.userdetail);
      if (res.statusCode == 200) {
        debugPrint('getProfile:${res.data}');
        return GetprofileModel.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error ProfileApi::$e');
      return null;
    }
  }

  @override
  Future<TripsSummaryResponse?> getTripcount() async {
    try {
      Response res = await ApiClient.get(APIEndpointUrls.tripcount);
      if (res.statusCode == 200) {
        debugPrint('getProfile:${res.data}');
        return TripsSummaryResponse.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error ProfileApi::$e');
      return null;
    }
  }

  @override
  Future<Categoryresponsemodel?> getcategory() async {
    try {
      Response res = await ApiClient.get(APIEndpointUrls.getCategory);
      if (res.statusCode == 200) {
        debugPrint('getcategory:${res.data}');
        return Categoryresponsemodel.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error getcategory::$e');
      return null;
    }
  }

  @override
  Future<ExpenseDetailModel?> getExpenseDetails(String id) async {
    try {
      Response res = await ApiClient.get(
        "${APIEndpointUrls.getExpenseDetails}/$id",
      );
      if (res.statusCode == 200) {
        debugPrint('getExpenseDetails:${res.data}');
        return ExpenseDetailModel.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error getExpenseDetails::$e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> deleteExpenseDetails(String id) async {
    try {
      Response res = await ApiClient.delete(
        "${APIEndpointUrls.deleteExpenseDetails}/$id",
      );
      if (res.statusCode == 200) {
        debugPrint('deleteExpenseDetails:${res.data}');
        return SuccessModel.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error deleteExpenseDetails::$e');
      return null;
    }
  }

  @override
  Future<GetCurrencyModel?> getCurrency() async {
    try {
      Response res = await ApiClient.get(APIEndpointUrls.getCurrency);
      if (res.statusCode == 200) {
        debugPrint('getCurrency:${res.data}');
        return GetCurrencyModel.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error getCurrency::$e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> postExpense(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.post(
        APIEndpointUrls.postExpence,
        data: data,
      );
      if (response.statusCode == 200) {
        debugPrint('postExpense: ${response.data}');
        return SuccessModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error postExpense: $e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> postTrip(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.post(
        APIEndpointUrls.postTrip,
        data: data,
      );
      if (response.statusCode == 200) {
        debugPrint('postTrip: ${response.data}');
        return SuccessModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error postTrip: $e');
      return null;
    }
  }

  @override
  Future<Piechartexpencemodel?> Piechartdata(String? tripid) async {
    try {
      final response = await ApiClient.get(
        "${APIEndpointUrls.piechartdata}?trip_id=$tripid",
      );
      if (response.statusCode == 200) {
        debugPrint('chartExpense: ${response.data}');
        return Piechartexpencemodel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error chartExpense: $e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> updateExpensedata(
    Map<String, dynamic> data,
    String Id,
  ) async {
    try {
      final response = await ApiClient.put(
        "${APIEndpointUrls.putExpenseDetails}/$Id",
        data: data,
      );
      if (response.statusCode == 200) {
        debugPrint('Edit Expense data: ${response.data}');
        return SuccessModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error EditExpense data: $e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> updateprofile(Map<String, dynamic> data) async {
    var formdata = await buildFormData(data);
    try {
      final response = await ApiClient.put(
        APIEndpointUrls.updateprofile,
        data: formdata,
      );
      if (response.statusCode == 200) {
        debugPrint('updateProfile: ${response.data}');
        return SuccessModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error updateProfile: $e');
      return null;
    }
  }

  @override
  Future<FinishTripModel?> finishtrip(data) async {
    try {
      final response = await ApiClient.post(
        APIEndpointUrls.finishtrip,
        data: data,
      );
      if (response.statusCode == 200) {
        debugPrint('finishtrip: ${response.data}');
        return FinishTripModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error finishtrip: $e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> updateCurrentTrip(
    Map<String, dynamic> data,
    String Id,
  ) async {
    try {
      final response = await ApiClient.put(
        "${APIEndpointUrls.updatecurrenttrip}/$Id",
        data: data,
      );
      if (response.statusCode == 200) {
        debugPrint('Edit updateCurrentTrip data: ${response.data}');
        return SuccessModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error updateCurrentTrip data: $e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> deletCurrentTrip(String id) async {
    try {
      Response res = await ApiClient.delete(
        "${APIEndpointUrls.deleteCurrentTrip}/$id",
      );
      if (res.statusCode == 200) {
        debugPrint('deletCurrentDetails:${res.data}');
        return SuccessModel.fromJson(res.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error deletCurrentDetails::$e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> ForgotpasswordApi(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.post(
        APIEndpointUrls.fotgotpassword,
        data: data,
      );
      if (response.statusCode == 200) {
        debugPrint('Forgot Password: ${response.data}');
        return SuccessModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error Forgot Password: $e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> VerifyOtp(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.post(
        APIEndpointUrls.verifyotp,
        data: data,
      );
      if (response.statusCode == 200) {
        debugPrint('verify otp: ${response.data}');
        return SuccessModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error Verifyotp: $e');
      return null;
    }
  }

  @override
  Future<SuccessModel?> ChangePassword(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.post(
        APIEndpointUrls.changePassword,
        data: data,
      );
      if (response.statusCode == 200) {
        debugPrint('ChangePassword : ${response.data}');
        return SuccessModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error ChangePassword: $e');
      return null;
    }
  }
}
