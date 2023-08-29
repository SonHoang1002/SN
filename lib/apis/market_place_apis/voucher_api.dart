import 'package:market_place/apis/api_root.dart';

class VoucerApis {
  Future getVoucher(String pageId, String type, int limit) async {
    return await Api().getRequestBase("/api/v1/vouchers",
        {"page_id": pageId, "time": type, "limit": limit, "offset": 0});
  }
}
