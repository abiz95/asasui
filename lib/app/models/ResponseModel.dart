import 'dart:convert';

class ResponseModel {
  String? message;
  // List<AuthData>? Data;
  int? status;
  List<dynamic>?data;

  ResponseModel(this.message, this.status, this.data);

  ResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'];
    if (json['data'].toString().isNotEmpty) {
           data = jsonDecode(json['data']);
    } else {
           data = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = message;
    data['status'] = status;
    data['data'] = data;
    return data;
  }
}