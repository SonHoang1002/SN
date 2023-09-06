import 'package:flutter/cupertino.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';

class WatchLive extends StatefulWidget {
  const WatchLive({super.key});

  @override
  State<WatchLive> createState() => _WatchLiveState();
}

class _WatchLiveState extends State<WatchLive> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: buildTextContent("Chưa có live stream nào !!", false,
          fontSize: 30, isCenterLeft: false),
    );
  }
}
