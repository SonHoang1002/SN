import 'package:market_place/apis/api_root.dart';

class ProvincesApi {
  Future getProvinces(dynamic params) async { 
    return await Api().getRequestBase('/api/v1/provinces', params);
  }
 
}
