import 'package:asasui/app/utils/Constants.dart';
import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import '../services/AuthService.dart';

class Api {
  final Dio api = Dio();
  String? accessToken;

  // final _storage = const FlutterSecureStorage();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Api() {
    api.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      if (!options.path.contains('http')) {
        options.path = Constants.baseURL + options.path;
      }
      options.headers['Authorization'] = 'Bearer $accessToken';
      return handler.next(options);
    }, onError: (DioError error, handler) async {
      if (error.response?.statusCode == 401) {
        // if (await _storage.containsKey(key: 'refreshToken')) {
          if (await refreshToken()) {
            return handler.resolve(await _retry(error.requestOptions));
          }
        // }
        // Navigator.pushNamed('routeName');
        navigatorKey.currentState?.pushNamed('/signin');
      } else if(error.response?.statusCode == 403) {

      }
      return handler.next(error);
    }));
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return api.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<bool> refreshToken() async {
    // final refreshToken = await _storage.read(key: 'refreshToken');
    // final response = await api
    //     .post('/auth/refresh', data: {'refreshToken': refreshToken});

    final refreshToken = await AuthService().getToken();
    final response = await AuthService().refreshToken(refreshToken);

    if (response.statusCode == 200) {
      accessToken = response.data;
      return true;
    } else {
      // refresh token is wrong
      accessToken = null;
      // _storage.deleteAll();
      await AuthService().removeToken();
      return false;
    }
  }
}
