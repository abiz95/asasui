import 'dart:convert';

class UserModel {
  String? message;
  // List<AuthData>? Data;
  int? status;
  List<dynamic>? data;

  UserModel(this.message, this.status, this.data);

  UserModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    // Data = jsonDecode(json['Data']) as List<AuthData>;
    if (json['Data'].toString().isNotEmpty) {
           data = jsonDecode(json['data']);
    } else {
           data = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = message;
    data['status'] = status;
    data['Data'] = data;
    return data;
  }
}

class UserDataModel {
  int? userid;
  String? firstname;
  String? lastname;
  String? phonenumber;
  String? email;
  int? statusind;
  String? usertype;
  DateTime? cre_rec_ts;
  DateTime? upd_rec_ts;

  UserDataModel(
      this.userid,
      this.firstname,
      this.lastname,
      this.phonenumber,
      this.email,
      this.statusind,
      this.usertype,
      this.cre_rec_ts,
      this.upd_rec_ts);

  UserDataModel.fromJson(Map<String, dynamic> json) {
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
    data['cre_rec_ts'] = cre_rec_ts;
    data['upd_rec_ts'] = upd_rec_ts;
    return data;
  }

}
