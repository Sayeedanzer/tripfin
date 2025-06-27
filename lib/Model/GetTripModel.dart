class GetTripModel {
  Data? data;
  dynamic? totalExpense;
  Settings? settings;

  GetTripModel({this.data, this.totalExpense, this.settings});

  GetTripModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    totalExpense = json['total_expense'];
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['total_expense'] = this.totalExpense;
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? destination;
  String? startDate;
  String? budget;
  String? image;

  Data({this.id, this.destination, this.startDate, this.budget, this.image});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    destination = json['destination'];
    startDate = json['start_date'];
    budget = json['budget'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['destination'] = this.destination;
    data['start_date'] = this.startDate;
    data['budget'] = this.budget;
    data['image'] = this.image;
    return data;
  }
}

class Settings {
  int? success;
  String? message;
  int? status;

  Settings({this.success, this.message, this.status});

  Settings.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
