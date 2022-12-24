import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/video_player.dart';
import 'package:video_player/video_player.dart';

class PostLifeEvent extends StatelessWidget {
  final dynamic post;
  const PostLifeEvent({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lifeEvent = post['life_event'];
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        VideoPlayerRender(path: lifeEvent['default_media_url']),
        const SizedBox(
          height: 8,
        ),
        Text(
          lifeEvent['name'],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(lifeEvent['start_date'])
      ],
    );
  }
}
