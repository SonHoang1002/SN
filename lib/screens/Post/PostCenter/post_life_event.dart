import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/video_player_controller.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/video_player_none_controller.dart';
import 'package:social_network_app_mobile/widgets/video_player.dart';

class PostLifeEvent extends StatelessWidget {
  final dynamic post;
  const PostLifeEvent({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lifeEvent = post['life_event'];
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          // lifeEvent['default_media_url'] != null
          //     ?
          VideoPlayerNoneController(
            path: lifeEvent['place_id'],
            type: "network",
          )
          // : const SizedBox()
          ,
          const SizedBox(
            height: 8,
          ),
          Text(
            lifeEvent['name'] ?? "",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          lifeEvent['place'] != null
              ? Container(
                  width: MediaQuery.sizeOf(context).width - 30,
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
