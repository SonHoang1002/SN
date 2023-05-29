// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:market_place/constant/config.dart';
import 'package:http/http.dart' as http;
import 'package:market_place/screens/Auth/storage.dart';

class ApiFriends {
  Future<dynamic> getListFriendApi(params) async {
    try {
      var dataUserId = await SecureStorage().getKeyStorage("userId");
      var dataToken = await SecureStorage().getKeyStorage("token");
      String stringQuery = !['', null].contains(params['keyword'])
          ? '?keyword=${params['keyword']}'
          : '';

      Uri url = Uri.parse(
          '${urlSocialNetwork}/api/v1/accounts/$dataUserId/friendships${stringQuery}');

      var response = await http.get(
        url,
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

  Future<dynamic> searchConversation(params) async {
    try {
      var dataUserId = await SecureStorage().getKeyStorage("userId");
      var dataToken = await SecureStorage().getKeyStorage("token");

      var j = json.encode(params);
      var url = Uri.encodeFull(
          '${urlRocketChat}/api/v1/users.autocomplete?selector=$j');

      var response = await http.get(
        Uri.parse(url),
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

    return null;
  }

  Future<dynamic> searchGroupConversation(params) async {
    try {
      var dataUserId = await SecureStorage().getKeyStorage("userId");
      var dataToken = await SecureStorage().getKeyStorage("token");
      Uri url = Uri.parse('${urlRocketChat}/api/v1/channels.list');
      url.replace(queryParameters: params);

      var response = await http.get(
        url,
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

    return null;
  }

  Future<dynamic> searchGroupMember(params) async {
    try {
      var dataUserId = await SecureStorage().getKeyStorage("userId");
      var dataToken = await SecureStorage().getKeyStorage("token");
      Uri url = Uri.parse(
          '${urlRocketChat}/api/v1/groups.members?roomId=${params['roomId']}&filter=${params['filter']}');

      var response = await http.get(
        url,
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

    return null;
  }

  Future<dynamic> getRoomChat(time) async {
    try {
      var dataUserId = await SecureStorage().getKeyStorage("userId");
      var dataToken = await SecureStorage().getKeyStorage("token");
      Uri url = Uri.parse('${urlRocketChat}/api/v1/method.call/rooms%3Aget');
      var body = jsonEncode({
        "message": jsonEncode(
            {"msg": 'method', "id": '14', "method": 'rooms/get', "params": []})
      });

      var response = await http.post(url,
          headers: {
            'X-Auth-Token': "${dataToken}",
            'X-User-Id': "${dataUserId}",
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

    return null;
  }
}
