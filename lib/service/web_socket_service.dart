import 'dart:async';

import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  Timer? timer;
  WebSocketChannel? webSocketChannel;
  late String token;

  Future fetchToken() async {
    try {
      final response = await Dio().post(
        'https://notification-api.emso.vn/v1/widgets/session/initialize',
        data: {
          "applicationIdentifier": "NQdDh27Faz0F",
          "subscriberId": "108571825456188313",
          "hmacHash": null,
        },
      );
      return response.data;
    } catch (error) {
      // Handle the error as per your requirement
      print('Error fetching token: $error');
    }
  }

  Future<WebSocketChannel> connectToWebSocket() async {
    var res = await fetchToken();
    if (res['data']['token'] != null) {
      webSocketChannel = WebSocketChannel.connect(
        Uri.parse(
          'wss://notification-ws.emso.vn/socket.io/?token=${res['data']['token']}&EIO=3&transport=websocket',
        ),
      );
      setupPeriodicSending();
    }

    return webSocketChannel!;
  }

  void setupPeriodicSending() {
    timer = Timer.periodic(const Duration(seconds: 25), (_) {
      webSocketChannel?.sink.add('2');
    });
  }
}
