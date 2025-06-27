class Editexpencemodel {
  final Map<String, dynamic> data;
  final Settings settings;

  Editexpencemodel({
    required this.data,
    required this.settings,
  });

  factory Editexpencemodel.fromJson(Map<String, dynamic> json) {
    return Editexpencemodel(
      data: json['data'] as Map<String, dynamic>,
      settings: Settings.fromJson(json['settings'] as Map<String, dynamic>),
    );
  }

  // Method to convert an ExpenseResponse object to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'settings': settings.toJson(),
    };
  }

  @override
  String toString() {
    return 'ExpenseResponse(data: $data, settings: $settings)';
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

  // Factory method to create a Settings object from JSON
  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      success: json['success'] as int,
      message: json['message'] as String,
      status: json['status'] as int,
    );
  }

  // Method to convert a Settings object to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'Settings(success: $success, message: $message, status: $status)';
  }
}