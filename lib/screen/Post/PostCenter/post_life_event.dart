import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/video_player.dart';

class PostLifeEvent extends StatelessWidget {
  final dynamic post;
  const PostLifeEvent({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lifeEvent = post['life_event'];
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          lifeEvent['default_media_url'] != null
              ? VideoPlayerRender(path: lifeEvent['default_media_url'])
              : const SizedBox(),
          const SizedBox(
            height: 8,
          ),
          Text(
            lifeEvent['name'] ?? "",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          lifeEvent['place'] != null
              ? Container(
                  width: MediaQuery.of(context).size.width - 30,
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    lifeEvent['place']['title'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                )
              : const SizedBox(),
          Text(lifeEvent?['start_date'] ?? '')
        ],
      ),
    );
  }
}
