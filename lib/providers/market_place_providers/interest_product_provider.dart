import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/follwer_product_api.dart';
// import 'package:social_network_app_mobile/apis/market_place_apis/follwer_product_api.dart';

final interestProductsProvider =
    StateNotifierProvider<InterestProductsController, InterestProductsState>(
        (ref) => InterestProductsController());

class InterestProductsController extends StateNotifier<InterestProductsState> {
  InterestProductsController() : super(InterestProductsState());

  addInterestProductItem(dynamic newItem) async {
    if (newItem == null || newItem.isEmpty) {
      state = state.copyWith(state.listInterest);
    } else {
      state = state.copyWith([...state.listInterest, newItem]);
    }
  }

  deleleInterestProductItem(dynamic id) async {
    List<dynamic> interestList = state.listInterest;
    for (int i = 0; i < interestList.length; i++) {
      if (interestList[i]["id"] == id) {
        interestList.removeAt(i);
        return;
      }
    }
    state = state.copyWith(interestList);
  }

  getFollwerProduct() async {
    final response = await FollwerProductsApi().getFollwerProductsApi();
    state = state.copyWith(response);
  }
}

class InterestProductsState {
  List<dynamic> listInterest;
  InterestProductsState({this.listInterest = const []});
  InterestProductsState copyWith(List<dynamic> list) {
    return InterestProductsState(listInterest: list);
  }
}
