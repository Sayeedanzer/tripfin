class Piechartexpencemodel {
  Data? data;
  Settings? settings;

  Piechartexpencemodel({this.data, this.settings});

  Piechartexpencemodel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    settings = json['settings'] != null ? Settings.fromJson(json['settings']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    return data;
  }
}

class Data {
  String? tripId;
  String? destination;
  double? totalExpense;
  double? totalBudget;  // Added this field
  List<ExpenseData>? expenseData;

  Data({this.tripId, this.destination, this.totalExpense, this.totalBudget, this.expenseData});

  Data.fromJson(Map<String, dynamic> json) {
    tripId = json['trip_id'];
    destination = json['destination'];
    totalExpense = (json['total_expense'] as num?)?.toDouble();
    totalBudget = (json['total_budget'] as num?)?.toDouble();  // Parsing totalBudget
    if (json['expense_data'] != null) {
      expenseData = <ExpenseData>[];
      json['expense_data'].forEach((v) {
        expenseData!.add(ExpenseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['trip_id'] = tripId;
    data['destination'] = destination;
    data['total_expense'] = totalExpense;
    data['total_budget'] = totalBudget;
    if (expenseData != null) {
      data['expense_data'] = expenseData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExpenseData {
  String? expenseId;
  String? categoryName;
  double? totalExpense;
  double? percentage;
  String? date;
  String? remarks;
  String? paymentMode;
  String? colorCode;

  ExpenseData({
    this.expenseId,
    this.categoryName,
    this.totalExpense,
    this.percentage,
    this.date,
    this.remarks,
    this.paymentMode,
    this.colorCode,
  });

  ExpenseData.fromJson(Map<String, dynamic> json) {
    expenseId = json['expense_id'] as String?;
    categoryName = json['category_name'] as String?;
    totalExpense = (json['total_expense'] as num?)?.toDouble();
    percentage = (json['percentage'] as num?)?.toDouble();
    date = json['date'] as String?;
    remarks = json['remarks'] as String?;
    colorCode = json['color_code'] as String?;
    paymentMode = json['payment_mode'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['expense_id'] = expenseId;
    data['category_name'] = categoryName;
    data['total_expense'] = totalExpense;
    data['percentage'] = percentage;
    data['date'] = date;
    data['remarks'] = remarks;
    data['payment_mode'] = paymentMode;
    data['color_code'] = colorCode;
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
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
