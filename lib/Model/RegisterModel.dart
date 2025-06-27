class RegisterModel {
  Data? data;
  Settings? settings;

  RegisterModel({this.data, this.settings});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      settings: json['settings'] != null ? Settings.fromJson(json['settings']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (data != null) 'data': data!.toJson(),
      if (settings != null) 'settings': settings!.toJson(),
    };
  }
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class Settings {
  int? success;
  String? message;
  int? status;

  Settings({this.success, this.message, this.status});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
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
