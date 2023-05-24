import 'package:asasui/app/services/RemoteDataService.dart';

import '../utils/Constants.dart';

class PaymentService {

  Future getPaymentGateway(String clientId) async {
    try {
      String url = '${Constants.baseURL}/payment/gateway/$clientId';

      return RemoteDataService().getHttp(url);
    } catch (e) {
      throw Exception('[PaymentService][getPaymentGateway] Exception caught: $e');
    }
  }
}
