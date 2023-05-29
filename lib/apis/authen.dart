// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';
import 'package:market_place/constant/config.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:market_place/screens/Auth/storage.dart';

class ApiAuthen {
  Future<dynamic> loginChatSocialApi(data) async {
    try {
      var body = {
        "username": data["username"],
        "password": data['password'],
        "grant_type": 'password',
        "client_id": 'Ev2mh1kSfbrea3IodHtNd7aA4QlkMbDIOPr4Y5eEjNg',
        "client_secret": 'f2PrtRsNb7scscIn_3R_cz6k_fzPUv1uj7ZollSWBBY',
        "scope": 'write read follow'
      };

      var response = await http
          .post(Uri.parse('${urlSocialNetwork}/oauth/token'), body: body);

      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      } else {
        return {
          'access_token': null,
          'message': jsonDecode(response.body).error_description
        };
      }
    } catch (e) {
      return {
        "type": "error",
        "message":
            "Có lỗi xảy ra trong quá trình đăng nhập, vui lòng thử lại sau"
      };
    }
  }

 }
