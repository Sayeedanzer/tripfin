import 'dart:convert';

class Updateexpencemodel {
  final String id;
  final double expense;
  final String trip;
  final String category;
  final DateTime createdAt;

  Updateexpencemodel({
    required this.id,
    required this.expense,
    required this.trip,
    required this.category,
    required this.createdAt,
  });

  factory Updateexpencemodel.fromJson(Map<String, dynamic> json) {
    return Updateexpencemodel(
      id: json['id'],
      expense: json['expense'].toDouble(),
      trip: json['trip'],
      category: json['category'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expense': expense,
      'trip': trip,
      'category': category,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class SettingsModel {
  final int success;
  final String message;
  final int status;

  SettingsModel({
    required this.success,
    required this.message,
    required this.status,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      success: json['success'],
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'status': status,
    };
  }
}

class UpdateExpenceImpl {
  final Updateexpencemodel data;
  final SettingsModel settings;

  UpdateExpenceImpl({
    required this.data,
    required this.settings,
  });

  factory UpdateExpenceImpl.fromJson(Map<String, dynamic> json) {
    return UpdateExpenceImpl(
      data: Updateexpencemodel.fromJson(json['data']),
      settings: SettingsModel.fromJson(json['settings']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'settings': settings.toJson(),
    };
  }

}

