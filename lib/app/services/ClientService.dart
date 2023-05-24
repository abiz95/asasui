import 'package:asasui/app/services/RemoteDataService.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../utils/Constants.dart';

class ClientService {
  Future getClientProfileDetail(var clientId) async {
    try {
      String url = '${Constants.baseURL}/client/details/$clientId';

      return RemoteDataService().getHttp(url);
    } catch (e) {
      throw Exception('[ClientService][getClientProfileDetail] Exception caught: $e');
    }
  }

  Future saveClientProfilePicture(String clientId, var payload) async {
    try {
      String url = '${Constants.baseURL}/client/profile/image/upload/$clientId';

     FormData formdata = FormData.fromMap({
          "file": await MultipartFile.fromFile(
                 payload.path, 
                 filename: basename(payload.path) 
                 //show only filename from path
           ),
      });

      return RemoteDataService().postHttp(url, formdata);
    } catch (e) {
      throw Exception('[ClientService][saveClientProfilePicture] Exception caught: $e');
    }
  }

  Future saveClientVerificationDocument(String clientId, var payload) async {
    try {
      String url = '${Constants.baseURL}/client/file/upload/$clientId';

     FormData formdata = FormData.fromMap({
          "file": await MultipartFile.fromFile(
                 payload.path, 
                 filename: basename(payload.path) 
                 //show only filename from path
           ),
      });
      
      return await RemoteDataService().postHttp(url, formdata);
    } catch (e) {
      throw Exception('[ClientService][saveClientVerificationDocument] Exception caught: $e');
    }
  }
}
