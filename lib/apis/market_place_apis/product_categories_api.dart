import 'package:social_network_app_mobile/apis/api_root.dart';

class ProductCategoriesApi {
  Future getListProductCategoriesApi() async {
    return await Api().getRequestBase('/api/v1/product_categories', null);
    // final String path = await rootBundle
    //     .loadString("data/market_place_datas/product_categories_data.json");
    // // final response = await json.decode(path);
    // final response = jsonDecode(path);
    // final nextDayModel = print(nextDayModel.list!.length);
    // return nextDayModel;
  }
}
