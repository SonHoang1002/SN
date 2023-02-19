import 'package:social_network_app_mobile/apis/api_root.dart';

Future updateProductMarketPlace( dynamic data) async {
  return await Api()
      .patchRequestBase('/api/v1/products/', data);
}

// Future updateProductMarketPlace(
//     String product_category_id, String page_id, dynamic data) async {
//   return await Api()
//       .patchRequestBase('/api/v1/products/$product_category_id', data);
// }