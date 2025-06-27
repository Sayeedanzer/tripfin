class Updateprofilemodel {
  final Settings settings;

  Updateprofilemodel({required this.settings});

  factory Updateprofilemodel.fromJson(Map<String, dynamic> json) {
    return Updateprofilemodel(
      settings: Settings.fromJson(json['settings'] ?? {}),
    );
  }
}

class Settings {
  final int success;
  final String message;

  Settings({required this.success, required this.message});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      success: json['success'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  @override
  String toString() => 'Settings(success: $success, message: $message)';
}