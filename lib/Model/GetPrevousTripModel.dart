class GetPrevousTripModel {
  List<PreviousTrip>? previousTrips;
  Settings? settings;

  GetPrevousTripModel({this.previousTrips, this.settings});

  factory GetPrevousTripModel.fromJson(Map<String, dynamic> json) {
    return GetPrevousTripModel(
      previousTrips: json['data'] != null
          ? (json['data'] as List<dynamic>)
          .map((v) => PreviousTrip.fromJson(v))
          .toList()
          : [],
      settings: json['settings'] != null
          ? Settings.fromJson(json['settings'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (previousTrips != null) {
      data['data'] = previousTrips!.map((v) => v.toJson()).toList();
    }
    if (settings != null) {
      data['settings'] = settings!.toJson();
    }
    return data;
  }
}

class PreviousTrip {
  String? tripId;
  String? destination;
  String? startDate;
  String? endDate;
  double? budget;
  double? totalExpense; // Changed to double? to match JSON
  String? status;

  PreviousTrip({
    this.tripId,
    this.destination,
    this.startDate,
    this.endDate,
    this.budget,
    this.totalExpense,
    this.status,
  });

  factory PreviousTrip.fromJson(Map<String, dynamic> json) {
    return PreviousTrip(
      tripId: json['trip_id'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      budget: _parseDouble(json['budget']),
      totalExpense: _parseDouble(json['total_expense']),
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trip_id'] = tripId;
    data['destination'] = destination;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['budget'] = budget;
    data['total_expense'] = totalExpense;
    data['status'] = status;
    return data;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class Settings {
  int? success;
  String? message;
  int? status;

  Settings({this.success, this.message, this.status});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      success: _parseInt(json['success']),
      message: json['message'] as String? ?? '',
      status: _parseInt(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['status'] = status;
    return data;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}