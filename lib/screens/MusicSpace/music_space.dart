import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screens/MusicSpace/music_space_render.dart';

class MusicSpace extends StatefulWidget {
  const MusicSpace({super.key});

  @override
  MusicSpaceState createState() => MusicSpaceState();
}

class MusicSpaceState extends State<MusicSpace>
    with AutomaticKeepAliveClientMixin<MusicSpace> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener<ScrollNotification>(
      child: Scaffold(body: MusicSpaceRender()),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
