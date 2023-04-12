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
  const PostMedia({Key? key, this.post, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List medias = post['media_attachments'] ?? [];

    handlePress(media) {
      if (checkIsImage(media)) {
        if (medias.length == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostOneMediaDetail(
                        postMedia: post,
                        backFunction: () {
                          popToPreviousScreen(context);
                        },
                      )));
        } else if (medias.length > 1) {
          int initialIndex =
              medias.indexWhere((element) => element['id'] == media['id']);
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => CreateModalBaseMenu(
                      title: 'Bài viết',
                      body: PostMutipleMediaDetail(
                        post: post,
                        initialIndex: initialIndex,
                      ),
                      buttonAppbar: const SizedBox())));
        } else {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => PostDetail(
                        post: post,
                      )));
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
