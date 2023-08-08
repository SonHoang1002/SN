import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screens/CreatePost/CreateNewFeed/create_new_feed.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';

class CreatePostButton extends ConsumerWidget {
  final dynamic postDiscussion;
  final dynamic preType;
  final Function? reloadFunction;
  final dynamic pageData;

  /// data from current user
  final dynamic friendData;

  /// This type is transfered from user page, to check that you can have permission to create post in friend wall
  /// You must transfer both [friendData] and [userType] if you want check permission to create post in friend wall
  final dynamic userType;

  const CreatePostButton(
      {super.key,
      this.postDiscussion,
      this.preType,
      this.reloadFunction,
      this.pageData,
      this.friendData,
      this.userType});

  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    dynamic userType;
    if (friendData != null) {
      if (userType != null) {
        userType = userType;
      } else {
        userType = 'me';
        if (friendData?['relationships'] != null &&
            friendData?['relationships']?['friendship_status'] ==
                'ARE_FRIENDS') {
          userType = 'friend';
        } else if (friendData['relationships'] != null &&
            friendData?['relationships']?['friendship_status'] ==
                'OUTGOING_REQUEST') {
          userType = 'requested';
        } else {
          userType = 'stranger';
        }
      }
    }
    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: ((context) => CreateNewFeed(
                      type: preType,
                      pageData: pageData,
                      reloadFunction: reloadFunction,
                      postDiscussion: postDiscussion,
                      friendData: friendData
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
                      path: pageData != null
                          ? (pageData?['avatar_media']?["preview_url"]) ??
                              linkAvatarDefault
                          : (ref.watch(meControllerProvider)[0]['avatar_media']
                                  ?['preview_url'] ??
                              linkAvatarDefault)),
                  const SizedBox(
                    width: 10,
                  ),
                  buildTextContent(
                      friendData != null && (userType == "friend")
                          ? "Hãy viết gì đó cho ${friendData['display_name']}"
                          : "Bạn đang nghĩ gì?",
                      false,
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis),
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
