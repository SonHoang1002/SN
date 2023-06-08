import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screens/CreatePost/CreateNewFeed/create_new_feed.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';

class CreatePostButton extends ConsumerWidget {
  final dynamic postDiscussion;
  final dynamic preType;
  final Function? reloadFunction;
  const CreatePostButton(
      {Key? key, this.postDiscussion, this.preType, this.reloadFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: ((context) => CreateNewFeed(
                      type: preType,
                      postDiscussion: postDiscussion,
                      reloadFunction: reloadFunction,
                    ))));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 6, bottom: 6),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  AvatarSocial(
                      width: 40,
                      height: 40,
                      object: ref.watch(meControllerProvider)[0],
                      path: ref.watch(meControllerProvider)[0]['avatar_media']
                          ['preview_url']),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Bạn đang nghĩ gì?",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              Image.asset(
                "assets/images_and_video.png",
                width: 24,
              )
            ]),
      ),
    );
  }
}
