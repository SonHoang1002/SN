import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/Post/post_detail.dart';
import 'package:social_network_app_mobile/screen/Post/post_mutiple_media_detail.dart';
import 'package:social_network_app_mobile/screen/Post/post_one_media_detail.dart';
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
                      )));
        } else if (medias.length > 1) {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => CreateModalBaseMenu(
                      title: 'Bài viết',
                      body: PostMutipleMediaDetail(post: post),
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
              medias: medias,
              handlePress: handlePress,
            ),
          )
        : const SizedBox();
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
