import 'package:asasui/app/services/RemoteDataService.dart';

import '../utils/Constants.dart';

class CartService {
  Future getCartList(var clientId) async {
    try {
      String url = '${Constants.baseURL}/order/client/$clientId';

      return RemoteDataService().getHttp(url);
    } catch (e) {
      throw Exception('[CartService][getCartList] Exception caught: $e');
    }
  }

  Future getProductDetailFromBarcode(
      int storeId, String productBarcode, String clientId) async {
    try {
      String url =
          '${Constants.baseURL}/product/detect/$storeId/$productBarcode/$clientId';

      return RemoteDataService().getHttp(url);
    } catch (e) {
      throw Exception(
          '[CartService][getProductDetailFromBarcode] Exception caught: $e');
    }
  }

  Future saveOrder(var data) async {
    try {
      String url = '${Constants.baseURL}/order/add';

      return RemoteDataService().postHttp(url, data);
    } catch (e) {
      throw Exception('[CartService][saveOrder] Exception caught: $e');
    }
  }

  Future removeFromCart(int orderId) async {
    try {
      String url = '${Constants.baseURL}/order/delete/$orderId';

      return RemoteDataService().deleteHttp(url);
    } catch (e) {
      throw Exception('[CartService][removeFromCart] Exception caught: $e');
    }
  }

  Future updateProductQty(int orderId, int orderQty) async {
    try {
      String url = '${Constants.baseURL}/order/update/$orderId/$orderQty';

      return RemoteDataService().putHttp(url, null);
    } catch (e) {
      throw Exception('[CartService][updateProductQty] Exception caught: $e');
    }
  }

  Future getProductDetail(int storeId, int productId) async {
    try {
      String url = '${Constants.baseURL}/product/view/$storeId/$productId';

      return RemoteDataService().getHttp(url);
    } catch (e) {
      throw Exception('[CartService][getProductDetail] Exception caught: $e');
    }
  }
}
