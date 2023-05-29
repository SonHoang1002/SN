// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:market_place/constant/config.dart';
import 'package:http/http.dart' as http;
import 'package:market_place/screens/Auth/storage.dart';

class ApiUser {
  Future<dynamic> getDataUserApi(token) async {
    try {
      var response = await http.get(Uri.parse('${urlSocialNetwork}/api/v1/me'),
          headers: {"Authorization": "Bearer ${token}"});

      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> getDataAccountApi(id) async {
    var token = await SecureStorage().getKeyStorage("token");
    try {
      var response = await http.get(
          Uri.parse('${urlSocialNetwork}/api/v1/accounts/$id'),
          headers: {"Authorization": "Bearer ${token}"});

      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> getListPagesApi(token) async {
    try {
      var response = await http.get(
          Uri.parse('${urlSocialNetwork}/api/v1/pages'),
          headers: {"Authorization": "Bearer ${token}"});

      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> getMeChatApi() async {
    try {
      var dataUserId = await SecureStorage().getKeyStorage("userId");
      var dataToken = await SecureStorage().getKeyStorage("token");
      var response = await http.get(
        Uri.parse('${urlRocketChat}/api/v1/me'),
        headers: {
          'X-Auth-Token': "${dataToken}",
          'X-User-Id': "${dataUserId}",
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> getAccountSettingApi() async {
    try {
      var token = await SecureStorage().getKeyStorage("token");
      var response = await http.get(
          Uri.parse('${urlSocialNetwork}/api/v1/account_settings'),
          headers: {"Authorization": "Bearer ${token}"});

      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> updateAccountSettingApi(key, value) async {
    try {
      var body = jsonEncode({key: value});
      print(body);
      var token = await SecureStorage().getKeyStorage("token");
      var response = await http.post(
          Uri.parse('${urlSocialNetwork}/api/v1/account_settings'),
          headers: {
            "Authorization": "Bearer ${token}",
            'Content-Type': 'application/json'
          },
          body: body);

      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
