class ExpenseDetailModel {
  Data? data;
  Settings? settings;

  ExpenseDetailModel({this.data, this.settings});

  ExpenseDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    settings =
        json['settings'] != null ? Settings.fromJson(json['settings']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (settings != null) {
      data['settings'] = settings!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? expense;
  String? category;
  String? date;
  String? remarks;
  String? paymentMode;
  String? categoryName;
  String? trip;
  String? billReceipt;

  Data({
    this.id,
    this.expense,
    this.category,
    this.date,
    this.remarks,
    this.paymentMode,
    this.categoryName,
    this.trip,
    this.billReceipt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expense = json['expense'];
    category = json['category'];
    date = json['date'];
    remarks = json['remarks'];
    paymentMode = json['payment_mode'];
    categoryName = json['category_name'];
    trip = json['trip'];
    billReceipt = json['bill_receipt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['expense'] = expense;
    data['category'] = category;
    data['date'] = date;
    data['remarks'] = remarks;
    data['payment_mode'] = paymentMode;
    data['category_name'] = categoryName;
    data['trip'] = trip;
    data['bill_receipt'] = billReceipt;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
