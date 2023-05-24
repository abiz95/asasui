// import 'AuthData.dart';

import 'dart:convert';

class AuthModel {
  String? message;
  // List<AuthData>? Data;
  int? status;
  String? data;

  AuthModel(this.message, this.status, this.data);

  AuthModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'][0];
    // if (json['data'].toString().isNotEmpty) {
    //   if (json['data'][0] is String) {
    //     data = json['data'][0];
    //   } else {
    //     data = jsonDecode(json['data'][0]);
    //   }
           
    // } else {
    //        data = [];
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = message;
    data['status'] = status;
    data['data'] = data;
    return data;
  }
}

class AuthData {
  int? userid;
  String? firstname;
  String? lastname;
  String? phonenumber;
  String? email;
  int? statusind;
  String? usertype;

  AuthData(this.userid, this.firstname, this.lastname, this.phonenumber,
      this.email, this.statusind, this.usertype);

  AuthData.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phonenumber = json['phonenumber'];
    email = json['email'];
    statusind = json['statusind'];
    usertype = json['usertype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userid'] = userid;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['phonenumber'] = phonenumber;
    data['email'] = email;
    data['statusind'] = statusind;
    data['usertype'] = usertype;
    return data;
  }
}
