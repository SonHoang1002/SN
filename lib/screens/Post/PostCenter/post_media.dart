import 'package:flutter/cupertino.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screens/Post/post_detail.dart';
import 'package:social_network_app_mobile/screens/Post/post_mutiple_media_detail.dart';
import 'package:social_network_app_mobile/screens/Post/post_one_media_detail.dart';
import 'package:social_network_app_mobile/widgets/grid_layout_image.dart';

class PostMedia extends StatelessWidget {
  final dynamic post;
  final String? type;
  final dynamic preType;
  final Function? backFunction;
  final Function? reloadFunction;
  final Function? showCmtBoxFunction;
  final Function? updateDataFunction;

  const PostMedia(
      {Key? key,
      this.post,
      this.type,
      this.preType,
      this.backFunction,
      this.reloadFunction,
      this.showCmtBoxFunction,
      this.updateDataFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List medias = post['media_attachments'] ?? [];

    handlePress(media) {
      if (type != "edit_post") {
        if (checkIsImage(media)) {
          if (medias.length == 1) {
            showCmtBoxFunction != null ? showCmtBoxFunction!() : null;
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
                    reloadFunction: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        reloadFunction != null ? reloadFunction!() : null;
                      });
                    },
                    updateDataFunction: updateDataFunction),
                opaque: false);
          } else if (medias.length > 1) {
            showCmtBoxFunction != null ? showCmtBoxFunction!() : null;
            int initialIndex =
                medias.indexWhere((element) => element['id'] == media['id']);
            pushCustomCupertinoPageRoute(
                context,
                PostMutipleMediaDetail(
                  post: post,
                  initialIndex: initialIndex,
                  preType: preType,
                  updateDataFunction:updateDataFunction
                  // reloadPostFunction: () {
                  //     WidgetsBinding.instance.addPostFrameCallback((_) {
                  //       reloadFunction != null ? reloadFunction!() : null;
                  //     });
                  //   }
                ),
                opaque: false);
          } else {
            showCmtBoxFunction != null ? showCmtBoxFunction!() : null;
            pushCustomCupertinoPageRoute(
                context,
                PostDetail(
                  post: post,
                  preType: type,
                  updateDataFunction:updateDataFunction
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
    }

    return medias.isNotEmpty
        ? Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: GridLayoutImage(
              post: post,
              medias: medias,
              handlePress: handlePress,
              updateDataFunction:updateDataFunction
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
