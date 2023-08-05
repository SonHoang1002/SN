import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../apis/config.dart';
import '../apis/me_api.dart';

class WebSocketService {
  Timer? timer;
  WebSocketChannel? webSocketChannel;
  late String token;

  Future fetchToken() async {
    try {
      var res = await MeApi().fetchDataMeApi();
      if (res != null) {
        final response = await Dio().post(
          '$getTokenNovuUrl/v1/widgets/session/initialize',
          data: {
            "applicationIdentifier": baseRootNovu,
            "subscriberId": res?['id'].toString(),
            "hmacHash": null,
          },
        );
        return response.data;
      } else {
        return null;
      }
    } catch (error) {
      Logger logger = Logger();
      logger.e('Error fetching token: $error');
    }
  }

  Future<WebSocketChannel?> connectToWebSocket() async {
    var res = await fetchToken();
    if (res != null && (res?['data']?['token']) != null) {
      webSocketChannel = WebSocketChannel.connect(
        Uri.parse(
          '$socketNovuUrl/?token=${res['data']['token']}&EIO=3&transport=websocket',
        ),
      );
      setupPeriodicSending();
      return webSocketChannel!;
    }
    return null;
  }

  void setupPeriodicSending() {
    timer = Timer.periodic(const Duration(seconds: 21), (_) {
      // ignore: unrelated_type_equality_checks
      if (webSocketChannel?.sink.done == false) {
        webSocketChannel?.sink.add('2');
      }
    });
  }
}
