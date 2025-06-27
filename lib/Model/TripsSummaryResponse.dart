class TripsSummaryResponse {
  final TripsData data;
  final Settings settings;

  TripsSummaryResponse({required this.data, required this.settings});

  factory TripsSummaryResponse.fromJson(Map<String, dynamic> json) {
    return TripsSummaryResponse(
      data: TripsData.fromJson(json['data']),
      settings: Settings.fromJson(json['settings']),
    );
  }
}

class TripsData {
  final int totalPreviousTrips;
  final double totalExpenses;

  TripsData({required this.totalPreviousTrips, required this.totalExpenses});

  factory TripsData.fromJson(Map<String, dynamic> json) {
    return TripsData(
      totalPreviousTrips: json['total_previous_trips'],
      totalExpenses: (json['total_expenses'] as num).toDouble(),
    );
  }
}

class Settings {
  final int success;
  final String message;
  final int status;

  Settings({
    required this.success,
    required this.message,
    required this.status,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      success: json['success'],
      message: json['message'],
      status: json['status'],
    );
  }
}
