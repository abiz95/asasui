import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Constants.dart';
import '../utils/Cors.dart';

class AuthService {
  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  Future signin(email, password) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseURL}/client/authenticate'),
        headers: CORS,
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );
      return response;

      // if (response.statusCode == 200) {
      //   // If the server did return a 200 OK response,
      //   // then parse the JSON.
      //   // return AuthModel.fromJson(jsonDecode(response.body));
      //   return response;
      // } else {
      //   // If the server did not return a 200 OK response,
      //   // then throw an exception.

      // }
    } catch (e) {
      // print(e);
      throw Exception('[AuthService][signin] Exception caught: $e');
    }
  }

  Future signUp(
      firstName, lastName, email, password, phoneNumber, address, dob) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseURL}/client/register'),
        headers: CORS,
        body: jsonEncode(<String, String>{
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
          'address': address,
          'dob': dob,
        }),
      );
      return response;
    } catch (e) {
      // print(e);
      throw Exception('[AuthService][signUp] Exception caught: $e');
    }
  }

  Future refreshToken(token) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseURL}/client/authenticate/$token'),
        headers: CORS,
      );
      return response;

      // if (response.statusCode == 200) {
      //   // If the server did return a 200 OK response,
      //   // then parse the JSON.
      //   // return AuthModel.fromJson(jsonDecode(response.body));
      //   return response;
      // } else {
      //   // If the server did not return a 200 OK response,
      //   // then throw an exception.

      // }
    } catch (e) {
      // print(e);
      throw Exception('[AuthService][refreshToken] Exception caught: $e');
    }
  }

  decodeJwt(String claim) async {
    var token = await AuthService().getToken();
    Map<String, dynamic> tokenDecoded = parseJwt(token['token']);
    return tokenDecoded[claim];
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  Future saveToken(
    String token,
  ) async {
    // var sharedPreferenceObj = getSharedPreferences();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return <String, String>{
      "token": prefs.getString('token').toString(),
    };
  }

  Future removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
}
