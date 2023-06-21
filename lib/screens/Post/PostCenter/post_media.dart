import 'package:flutter/cupertino.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screens/Post/post_detail.dart';
import 'package:social_network_app_mobile/screens/Post/post_mutiple_media_detail.dart';
import 'package:social_network_app_mobile/screens/Post/post_one_media_detail.dart';
import 'package:social_network_app_mobile/widgets/grid_layout_image.dart';

class PostMedia extends StatefulWidget {
  final dynamic post;
  final String? type;
  final dynamic preType;
  final Function? backFunction;
  final Function? reloadFunction;
  final Function? showCmtBoxFunction;
  final Function? updateDataFunction;
  final bool? isFocus;

  PostMedia(
      {Key? key,
      this.post,
      this.type,
      this.preType,
      this.backFunction,
      this.reloadFunction,
      this.showCmtBoxFunction,
      this.updateDataFunction,
      this.isFocus})
      : super(key: key);

  @override
  State<PostMedia> createState() => _PostMediaState();
}

class _PostMediaState extends State<PostMedia> {
  ValueNotifier<dynamic> currentVideoId = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    final List mediaList = widget.post['media_attachments'] ?? [];
    if (mediaList.isNotEmpty) {
      // Map<String, dynamic>? firstVideo = mediaList.firstWhere(
      //   (element) => element['type'] == 'video',
      //   orElse: () => null,
      // );
      for (int i = 0; i < mediaList.length; i++) {
        if (mediaList[i]['type'] == 'video') {
          currentVideoId.value = mediaList[i]['id'];
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) { 
    List medias = widget.post['media_attachments'] ?? [];
    handlePress(media) {
      if (widget.type != "edit_post") {
        // if (checkIsImage(media)) {
        if (medias.length == 1) {
          widget.showCmtBoxFunction != null
              ? widget.showCmtBoxFunction!()
              : null;
          pushCustomVerticalPageRoute(
              context,
              PostOneMediaDetail(
                  postMedia: widget.post,
                  post: widget.post,
                  type: widget.type,
                  preType: widget.preType,
                  backFunction: () {
                    widget.backFunction != null ? widget.backFunction!() : null;
                  },
                  reloadFunction: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      widget.reloadFunction != null
                          ? widget.reloadFunction!()
                          : null;
                    });
                  },
                  updateDataFunction: widget.updateDataFunction),
              opaque: false);
        } else if (medias.length > 1) {
          widget.showCmtBoxFunction != null
              ? widget.showCmtBoxFunction!()
              : null;
          int initialIndex =
              medias.indexWhere((element) => element['id'] == media['id']);
          pushCustomCupertinoPageRoute(
              context,
              PostMutipleMediaDetail(
                  post: widget.post,
                  initialIndex: initialIndex,
                  preType: widget.preType,
                  updateDataFunction: widget.updateDataFunction
                  // reloadPostFunction: () {
                  //     WidgetsBinding.instance.addPostFrameCallback((_) {
                  //       reloadFunction != null ? reloadFunction!() : null;
                  //     });
                  //   }
                  ),
              opaque: false);
        } else {
          widget.showCmtBoxFunction != null
              ? widget.showCmtBoxFunction!()
              : null;
          pushCustomCupertinoPageRoute(
              context,
              PostDetail(
                  post: widget.post,
                  preType: widget.type,
                  updateDataFunction: widget.updateDataFunction));
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
      // }
    }

    return medias.isNotEmpty
        ? Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: GridLayoutImage(
              post: widget.post,
              medias: medias,
              handlePress: handlePress,
              isFocus: widget.isFocus,
              currentFocusVideoId: currentVideoId.value,
              updateDataFunction: widget.updateDataFunction,
              onEnd: () {
                List mediaList = widget.post['media_attachments'];
                dynamic startingValue = currentVideoId.value;
                int index = mediaList.indexWhere((element) =>
                    element['id'] == startingValue &&
                    mediaList.indexOf(element) < mediaList.length - 1 &&
                    mediaList[mediaList.indexOf(element) + 1]['type'] ==
                        'video');

                if (index >= 0 && index < mediaList.length - 1) {
                  dynamic video = mediaList[index + 1];
                  // setState(() {
                    currentVideoId.value = video['id'];
                  // });
                }
              },
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
