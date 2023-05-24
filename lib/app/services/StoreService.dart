import 'package:asasui/app/services/AuthService.dart';
import 'package:asasui/app/services/RemoteDataService.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Constants.dart';
import '../utils/Cors.dart';

class StoreService {
  var dio = Dio();

  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  Future saveStoreId(
    int token,
  ) async {
    // var sharedPreferenceObj = getSharedPreferences();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('storeId', token);
  }

  Future<int?> getStoreId() async {
    final prefs = await SharedPreferences.getInstance();
    // return <String, int>{
    //   "storeId": prefs.getInt('storeId'),
    // };
    return prefs.getInt('storeId');
  }

  Future removeStoreId() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('storeId');
  }

  // Future getStoreDetails(storeId) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('${Constants.baseURL}/store/location/$storeId'),
  //       headers: CORS,
  //     );

  //     return response;
  //   } catch (e) {
  //     throw Exception('[AuthService][getStoreDetails] Exception caught: $e');
  //   }
  // }
  // Future getStoreDetails(storeId) async {
  //   try {
  //     var fetchToken = await AuthService().getToken();
  //     var token = fetchToken['token'];
  //     final response = await dio.get(
  //         '${Constants.baseURL}/store/location/$storeId',
  //         options: Options(headers: getHeaders()));

  //     return response;
  //   } catch (e) {
  //     throw Exception('[AuthService][getStoreDetails] Exception caught: $e');
  //   }
  // }

  Future getStoreDetails(storeId) async {
    try {
      // var fetchToken = await AuthService().getToken();
      // var token = fetchToken['token'];
      // final response = await dio.get(
      //     '${Constants.baseURL}/store/location/$storeId',
      //     options: Options(headers: getHeaders()));
      String url = '${Constants.baseURL}/store/location/$storeId';

      return RemoteDataService().getHttp(url);
    } catch (e) {
      throw Exception('[StoreService][getStoreDetails] Exception caught: $e');
    }
  }

  Future<String> fetchToken() async {
    var token = await AuthService().getToken();
    return token['token'];
  }

  Map<String, String> getHeaders() {
    // var fetchToken = AuthService().getToken();
    var token = fetchToken();
    return <String, String>{
      'Authorization': 'Bearer $token',
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Request-Headers": "*",
      "Access-Control-Resqust-Method": "*",
      "content-type": "application/json"
    };
  }
}
