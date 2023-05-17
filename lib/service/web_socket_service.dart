import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  Timer? timer;
  WebSocketChannel webSocketChannel = WebSocketChannel.connect(Uri.parse(
      'wss://notification-ws.emso.vn/socket.io/?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MzNiZWEyZDRhNmNjZjQ3NTJjYTA2ODQiLCJvcmdhbml6YXRpb25JZCI6IjYzMzcxZWZhZTFjYTVkMzkxZTIxNGZiMiIsImVudmlyb25tZW50SWQiOiI2MzM3MWVmYWUxY2E1ZDM5MWUyMTRmYjgiLCJzdWJzY3JpYmVySWQiOiIxMDg3ODY3MTgzNjE2MDcxOTgiLCJvcmdhbml6YXRpb25BZG1pbklkIjoiNjMzNzFlZjZlMWNhNWQzOTFlMjE0ZmE5IiwiaWF0IjoxNjg0MTQzMDI0LCJleHAiOjE2ODU0MzkwMjQsImF1ZCI6IndpZGdldF91c2VyIiwiaXNzIjoibm92dV9hcGkifQ.9tTtjGIaXsReK4mTIee6bwWuDOR6inGBYfLqcIf6JRA&EIO=3&transport=websocket'));

  WebSocketChannel connectToWebSocket() {
    setupPeriodicSending();
    return webSocketChannel;
  }

  void setupPeriodicSending() {
    timer = Timer.periodic(const Duration(seconds: 25), (_) {
      webSocketChannel.sink.add('2');
    });
  }
}
