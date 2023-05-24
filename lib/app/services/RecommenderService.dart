import 'package:asasui/app/services/RemoteDataService.dart';

import '../utils/Constants.dart';

class RecommenderService{

    Future getProductRecommendations(String productType, int productId, int storeId) async {
    try {
      String url = '${Constants.mlURL}/recommender/recommendation/$productType/$productId/$storeId';

      return RemoteDataService().getHttp(url);
    } catch (e) {
      throw Exception('[RecommenderService][getProductRecommendations] Exception caught: $e');
    }
  }
}