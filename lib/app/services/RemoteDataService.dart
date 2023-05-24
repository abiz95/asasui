import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AuthService.dart';

class RemoteDataService {
  var dio = Dio();

  Future getHttp(String url) async {
    try {
      var header = await getHeaders();
      return await dio.get(url, options: Options(headers: header));
    } catch (e) {
      if (e is DioError) {
        throw e.response?.data['errors'][0] ?? "Error";
      }
      throw Exception(
          '[RemoteDataService][getHttp] Exception caught on GET method: $e');
    }
  }

  Future postHttp(String url, var data) async {
    try {
      var header = await getHeaders();
      return await dio.post(url, data: data, options: Options(headers: header));
    } catch (e) {
      throw Exception(
          '[RemoteDataService][postHttp] Exception caught on POST method: $e');
    }
  }

  Future putHttp(String url, var data) async {
    try {
      var header = await getHeaders();
      return await dio.put(url, data: data, options: Options(headers: header));
    } catch (e) {
      throw Exception(
          '[RemoteDataService][putHttp] Exception caught on PUT method: $e');
    }
  }

  Future deleteHttp(String url) async {
    try {
      var header = await getHeaders();
      return await dio.delete(url, options: Options(headers: header));
    } catch (e) {
      throw Exception(
          '[RemoteDataService][deleteHttp] Exception caught on DELETE method: $e');
    }
  }

  Future<String> fetchToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token').toString();
    // var token = await AuthService().getToken();
    // return token['token'];
  }

  Future<Map<String, String>> getHeaders() async {
    // var fetchToken = AuthService().getToken();
    var token = await fetchToken();
    print('map token: $token');
    return <String, String>{
      'Authorization': 'Bearer $token',
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Request-Headers": "*",
      "Access-Control-Request-Method": "*",
      "content-type": "application/json"
    };
  }
}
