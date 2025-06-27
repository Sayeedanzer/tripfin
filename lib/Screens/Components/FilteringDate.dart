import 'package:intl/intl.dart';

class DateUtil {

  static String formatDate(String? date) {
    if (date == null || date.isEmpty) {
      return "N/A";
    }
    try {
      final parsedDate = DateTime.parse(date);
      final formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
      return formattedDate;
    } catch (e) {
      print("Error formatting date: $e");
      return "Invalid date";  // Return a default message in case of an error
    }
  }
}
String capitalize(String value) {
  if (value.isEmpty) return "";
  return value[0].toUpperCase() + value.substring(1).toLowerCase();
}


