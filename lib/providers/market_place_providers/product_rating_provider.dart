import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/product_rating_apis.dart';

class ProductRatingState {
  List<dynamic> ratingDetailList;
  ProductRatingState({this.ratingDetailList = const []});
  ProductRatingState copyWith(List<dynamic> list) {
    return ProductRatingState(ratingDetailList: list);
  }
}

final ratingDetailProvider =
    StateNotifierProvider<ProductRatingController, ProductRatingState>(
        (ref) => ProductRatingController());

class ProductRatingController extends StateNotifier<ProductRatingState> {
  ProductRatingController() : super(ProductRatingState());

  getProductRatingDetailList(dynamic id) async {
    final response = await ProductRatingApis().getDeliveryAddressApi(id);
    print("productRating getProductRatingDetailList: $response");
    state = state.copyWith(response);
  }
}
