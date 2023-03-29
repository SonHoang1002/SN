import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    List<dynamic> interestList1 = state.listInterest;
    for (int i = 0; i < interestList.length; i++) {
      if (interestList[i]["id"] == id) {
        interestList.removeAt(i);
        return;
      }
    }
    interestList1.whereNot((element) {
      return element["id"] == id;
    }); 
    state = state.copyWith(interestList);
  }
}

class InterestProductsState {
  List<dynamic> listInterest;
  InterestProductsState({this.listInterest = const []});
  InterestProductsState copyWith(List<dynamic> list) {
    return InterestProductsState(listInterest: list);
  }
}
