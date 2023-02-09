import 'package:flutter/cupertino.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/Post/post_mutiple_media_detail.dart';
import 'package:social_network_app_mobile/widget/grid_layout_image.dart';

class PostMedia extends StatelessWidget {
  final dynamic post;
  const PostMedia({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List medias = post['media_attachments'] ?? [];

    handlePress(media) {
      if (checkIsImage(media)) {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => CreateModalBaseMenu(
                    title: 'Bài viết',
                    body: PostMutipleMediaDetail(post: post),
                    buttonAppbar: const SizedBox())));
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
