import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/Post/post_detail.dart';
import 'package:social_network_app_mobile/screen/Post/post_mutiple_media_detail.dart';
import 'package:social_network_app_mobile/screen/Post/post_one_media_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/grid_layout_image.dart';

class PostMedia extends StatelessWidget {
  final dynamic post;
  final String? type;
  final dynamic preType;
  final Function? backFunction;
  const PostMedia(
      {Key? key, this.post, this.type, this.preType, this.backFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List medias = post['media_attachments'] ?? [];

    handlePress(media) {
      if (checkIsImage(media)) {
        if (medias.length == 1) {
          pushCustomVerticalPageRoute(
              context,
              PostOneMediaDetail(
                postMedia: post,
                post: post,
                type: type,
                preType: preType,
                backFunction: () {
                  backFunction != null ? backFunction!() : null;
                },
              ),
              opaque: false);
        } else if (medias.length > 1) {
          int initialIndex =
              medias.indexWhere((element) => element['id'] == media['id']);
          pushCustomCupertinoPageRoute(
              context,
              PostMutipleMediaDetail(
                post: post,
                initialIndex: initialIndex,
                preType: preType,
              ),
              opaque: false);
          //  pushCustomPageRoute(
          // context,
          // CreateModalBaseMenu(
          //     title: 'Bài viết',
          //     body: PostMutipleMediaDetail(
          //       post: post,
          //       initialIndex: initialIndex,
          //     ),
          //     buttonAppbar: const SizedBox()),
          // opaque: false);
        } else {
          pushCustomCupertinoPageRoute(
              context,
              PostDetail(
                post: post,
                preType: type,
              ));
          // Navigator.push(
          //     context,
          //     CupertinoPageRoute(
          //         builder: (context) => PostDetail(
          //               post: post,
          //               preType: type,
          //             )));
        }
      } else {
        return;
      }
    }

    return medias.isNotEmpty
        ? Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: GridLayoutImage(
              post: post,
              medias: medias,
              handlePress: handlePress,
            ),
          )
        : Container();
  }

  checkIsImage(media) {
    return media['type'] == 'image' ? true : false;
  }

  getAspectMedia(media) {
    return checkIsImage(media)
        ? media['meta']['original']['aspect']
        : 1 / media['meta']['original']['aspect'];
  }
}
