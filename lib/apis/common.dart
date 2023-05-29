// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:market_place/constant/config.dart';
import 'package:http/http.dart' as http;
import 'package:market_place/screens/Auth/storage.dart';

class ApiCommons {
  Future<dynamic> fetchDataGifApi(params) async {
    try {
      var dataToken = await SecureStorage().getKeyStorage("token");

      var response = await http.get(
        Uri.parse('${urlSocialNetwork}/api/v1/gifts'),
        headers: {"Authorization": 'Bearer $dataToken'},
      );

      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }

    return null;
  }

  Future<dynamic> fetchStickyApi(url) async {
    try {
      var dataToken = await SecureStorage().getKeyStorage("token");

      var response = await http.get(
        Uri.parse('${urlSocialNetwork}/api/v1/$url'),
        headers: {"Authorization": 'Bearer $dataToken'},
      );

      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }

    return null;
  }

  getInventoryApi() {
    return fetchStickyApi("stickers/inventory");
  }

  getTagsKeywordApi() {
    return fetchStickyApi("tags/keyword");
  }

  getTrendingApi() {
    return fetchStickyApi("stickers/trendings");
  }

  getEmoticonApi() {
    return fetchStickyApi("stickers/tag2stickers/emotion");
  }

  getCategoryApi() {
    return fetchStickyApi("stickers/categories");
  }

  getPackFreeApi() {
    return fetchStickyApi("stickers/packs");
  }

  getPackDetailApi(id) {
    return fetchStickyApi("stickers/packs/${id}");
  }
}
