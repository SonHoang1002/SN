import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/product_categories_api.dart';
import 'package:social_network_app_mobile/data/market_place_datas/product_categories_data.dart';

class ProductCategoriesState {
  List<ProductCategoriesItem> list;
  ProductCategoriesState({this.list = const []});
  ProductCategoriesState copyWith(
      {List<ProductCategoriesItem> list = const []}) {
    return ProductCategoriesState(list: list);
  }
}

class ProductCategoriesItem {
  final String id;
  final String text;
  final List<ProductCategoriesItem> subcategories;

  ProductCategoriesItem(
      {this.id = "", this.text = "", this.subcategories = const []});

  ProductCategoriesItem copyWith(
      {String id = "",
      String text = "",
      List<ProductCategoriesItem> subcategories = const []}) {
    return ProductCategoriesItem(
        id: id, text: text, subcategories: subcategories);
  }

  factory ProductCategoriesItem.fromJson(
    Map<String, dynamic> json,
  ) {
    String id = "";
    String text = "";
    List<ProductCategoriesItem> subcategories = [];
    id = json["id"];
    text = json["text"];
    if (json['subcategories'] != null) {
      subcategories = [];
      json['subcategories'].forEach((v) {
        subcategories.add(ProductCategoriesItem.fromJson(v));
      });
    }
    return ProductCategoriesItem(
        id: id, text: text, subcategories: subcategories);
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['text'] = this.text;
  //   if (this.subcategories != null) {
  //     data['subcategories'] =
  //         this.subcategories!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

final productCategoriesProvider =
    StateNotifierProvider<ProductCategoriesController, ProductCategoriesState>(
        (ref) => ProductCategoriesController());

class ProductCategoriesController
    extends StateNotifier<ProductCategoriesState> {
  ProductCategoriesController() : super(ProductCategoriesState());

  getListProductCategories() async {
    // final response = await ProductCategoriesApi().getListProductCategoriesApi();

    List<ProductCategoriesItem> list = [];
    productCategories.forEach((e) {
      list.add(ProductCategoriesItem.fromJson(e));
    });
    state = state.copyWith(list: list);
  }
}
