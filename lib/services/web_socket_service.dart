import 'dart:async';

import 'package:dio/dio.dart';
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
      final response = await Dio().post(
        '$getTokenNovuUrl/v1/widgets/session/initialize',
        data: {
          "applicationIdentifier": baseRootNovu,
          "subscriberId": res['id'].toString(),
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
    if (res != null && res['data']['token'] != null) {
      webSocketChannel = WebSocketChannel.connect(
        Uri.parse(
          '$socketNovuUrl/?token=${res['data']['token']}&EIO=3&transport=websocket',
        ),
      );
      setupPeriodicSending();
    }

    return webSocketChannel!;
  }

  void setupPeriodicSending() {
    timer = Timer.periodic(const Duration(seconds: 21), (_) {
      webSocketChannel?.sink.add('2');
    });
  }
}
