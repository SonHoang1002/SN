import 'package:social_network_app_mobile/apis/api_root.dart';

Future updateProduct(String id, dynamic data) async {
  return await Api().patchRequestBase('/api/v1/products/$id', data);
}
