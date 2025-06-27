class ProfileUpdateResponseModel {
  final Settings settings;

  ProfileUpdateResponseModel({required this.settings});

  factory ProfileUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateResponseModel(
      settings: Settings.fromJson(json['settings']),
    );
  }
}

class Settings {
  final int success;
  final String message;
  final int status;

  Settings({required this.success, required this.message, required this.status});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      success: json['success'],
      message: json['message'],
      status: json['status'],
    );
  }
}
