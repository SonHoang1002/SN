import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/review_product_apis.dart';

class ReviewProductState {
  List<dynamic> commentList;
  ReviewProductState({this.commentList = const []});
  ReviewProductState copyWith(List<dynamic> list) {
    return ReviewProductState(commentList: list);
  }
}

final reviewProductProvider =
    StateNotifierProvider<ReviewProductController, ReviewProductState>(
        (ref) => ReviewProductController());

class ReviewProductController extends StateNotifier<ReviewProductState> {
  ReviewProductController() : super(ReviewProductState());

  getReviewProduct(dynamic id) async {
    final response = await ReviewProductApi().getReviewProductApi(id);
    final data = List.from(response);
    state = state.copyWith(response);
 
  }

  createReviewProduct(dynamic id, dynamic data) async {
    final response = await ReviewProductApi().createReviewProductApi(id, data);
    // state = state.copyWith(response);
 
  }

  deleteReviewproduct(dynamic productId, dynamic reviewId) async {
    final response =
        await ReviewProductApi().deleteReviewProductApi(productId, reviewId);
    // state = state.copyWith(response); 
  }
}
