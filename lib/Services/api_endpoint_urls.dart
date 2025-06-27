class APIEndpointUrls {
  static const String baseUrl = 'http://travel.ridev.in/';
  // static const String baseUrl = 'http://192.168.80.193:8000/';
  static const String apiUrl = 'api/';
  static const String authUrl = 'auth/';

  /// Auth URls
  static const String register = '${authUrl}register';
  static const String login = '${authUrl}login';
  static const String userdetail = '${authUrl}user-detail';
  static const String refreshtoken = '${authUrl}refresh-token';
  static const String fotgotpassword = '${authUrl}send-email-otp';
  static const String verifyotp = '${authUrl}verify-email-otp';
  static const String changePassword = '${authUrl}change-password';
  static const String delete_account = '${authUrl}user-delete';


  ///Api Urls
  static const String getTrip = '${apiUrl}trip';
  static const String postTrip = '${apiUrl}trip';
  static const String tripcount = '${apiUrl}trip-summary';
  static const String getPreviousTrip = '${apiUrl}previous-trips';
  static const String getCategory = '${apiUrl}category';
  static const String getExpenseDetails = '${apiUrl}expense-detail';
  static const String putExpenseDetails = '${apiUrl}expense-detail';
  static const String deleteExpenseDetails = '${apiUrl}expense-detail';
  static const String getCurrency = '${authUrl}currency';
  static const String postExpence = '${apiUrl}expense';
  static const String piechartdata = '${apiUrl}expense-pie-chart-view';
  static const String editexpense = '${apiUrl}expense-detail';
  static const String updateprofile = '${authUrl}user-detail';
  static const String updatecurrenttrip = '${apiUrl}trip-details';
  static const String finishtrip = '${apiUrl}finshed-trip';
  static const String deleteCurrentTrip = '${apiUrl}trip-details';





}
