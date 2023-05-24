import 'package:asasui/app/services/RemoteDataService.dart';

import '../utils/Constants.dart';

class OrderService {
  Future getClientBillList(var clientId) async {
    try {
      String url = '${Constants.baseURL}/order/bill/list/$clientId';

      return RemoteDataService().getHttp(url);
    } catch (e) {
      throw Exception('[OrderService][getClientBillList] Exception caught: $e');
    }
  }

  Future getBillSummary(String billingId) async {
    try {
      String url = '${Constants.baseURL}/order/bill/summary/$billingId';

      return RemoteDataService().getHttp(url);
    } catch (e) {
      throw Exception('[OrderService][getBillSummary] Exception caught: $e');
    }
  }

  Future getBillAmountDetail(String billingId) async {
    try {
      String url = '${Constants.baseURL}/payment/detail/$billingId';

      return RemoteDataService().getHttp(url);
    } catch (e) {
      throw Exception('[OrderService][getBillSummary] Exception caught: $e');
    }
  }
}
