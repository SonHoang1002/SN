import 'dart:convert';

import 'package:social_network_app_mobile/apis/api_root.dart';


class VoucerApis {
  Future getVoucher(String pageId, String type, int limit) async {
    return await Api().getRequestBase("/api/v1/vouchers",
        {"page_id": pageId, "time": type, "limit": limit, "offset": 0});
  }

  Future createVoucher({
    String title = "",
    required String code,
    required String start_time,
    required String end_time,
    required bool display_voucher_early,
    String? start_save_time,
    required String voucher_type,
    required String reward_type,
    required String discount_type,
    required int amount,
    int? maximum_discount_price,
    required int minimum_basket_price,
    required int usage_quantity,
    required int max_distribution_per_buyer,
    required String display_setting,
    required String applicable_products,
    List? product_ids,
    required String page_id,
  }) async {
    return await Api().postRequestBase(
        "/api/v1/vouchers",
        jsonEncode({
          "title": title,
          "code": code,
          "start_time": start_time,
          "end_time": end_time,
          "display_voucher_early": display_voucher_early,
          "start_save_time": start_save_time,
          "voucher_type": voucher_type,
          "reward_type": reward_type,
          "discount_type": discount_type,
          "amount": amount,
          "maximum_discount_price": maximum_discount_price,
          "minimum_basket_price": minimum_basket_price,
          "usage_quantity": usage_quantity,
          "max_distribution_per_buyer": max_distribution_per_buyer,
          "display_setting": display_setting,
          "applicable_products": applicable_products,
          "product_ids": product_ids,
          "page_id": page_id,
        }));
  }
}
