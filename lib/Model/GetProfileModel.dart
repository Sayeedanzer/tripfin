class GetprofileModel {
  final UserData? data;
  final Settings? settings;

  GetprofileModel({this.data, this.settings});

  factory GetprofileModel.fromJson(Map<String, dynamic> json) {
    return GetprofileModel(
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
      settings: json['settings'] != null ? Settings.fromJson(json['settings']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'settings': settings?.toJson(),
    };
  }
}

class UserData {
  final String? id;
  final String? fullName;
  final String? image;
  final String? email;
  final String? mobile;

  UserData({
    this.id,
    this.fullName,
    this.image,
    this.email,
    this.mobile,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      fullName: json['full_name'],
      image: json['image'],
      email: json['email'],
      mobile: json['mobile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'image': image,
      'email': email,
      'mobile': mobile,
    };
  }
}

class Settings {
  final int? success;
  final String? message;
  final int? status;

  Settings({
    this.success,
    this.message,
    this.status,
  });

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
