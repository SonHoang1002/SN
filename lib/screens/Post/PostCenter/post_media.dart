import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screens/Post/post_detail.dart';
import 'package:social_network_app_mobile/screens/Post/post_mutiple_media_detail.dart';
import 'package:social_network_app_mobile/screens/Post/post_one_media_detail.dart';
import 'package:social_network_app_mobile/screens/Watch/WatchDetail/watch_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/grid_layout_image.dart';

class PostMedia extends StatefulWidget {
  final dynamic post;
  final String? type;
  final dynamic preType;
  final Function? backFunction;
  final Function? reloadFunction;
  final Function? showCmtBoxFunction;
  final Function(dynamic)? updateDataFunction;
  final bool? isFocus;

  const PostMedia(
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
      for (int i = 0; i < mediaList.length; i++) {
        if (mediaList[i]['type'] == 'video') {
          currentVideoId.value = mediaList[i]['id'];
          return;
        }
      }
    }
  }

  handlePress(media) {
    dynamic medias = widget.post['media_attachments'] ?? [];
    if (widget.type != "edit_post") {
      // if (checkIsImage(media)) {
      if (medias.length == 1) {
        widget.showCmtBoxFunction != null ? widget.showCmtBoxFunction!() : null;
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
        widget.showCmtBoxFunction != null ? widget.showCmtBoxFunction!() : null;
        int initialIndex =
            medias.indexWhere((element) => element['id'] == media['id']);
        if (medias[initialIndex]['type'] == "video") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WatchDetail(
                        post: widget.post,
                        media: medias[initialIndex],
                        type: widget.type,
                        preType: widget.preType,
                      )));
        } else {
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
        }
      } else {
        widget.showCmtBoxFunction != null ? widget.showCmtBoxFunction!() : null;
        pushCustomCupertinoPageRoute(
            context,
            PostDetail(
                post: widget.post,
                preType: widget.type,
                updateDataFunction: widget.updateDataFunction));
      }
    } else {
      return;
    }
    // }
  }

  @override
  void dispose() {
    currentVideoId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List medias = widget.post['media_attachments'] ?? [];

    return medias.isNotEmpty
        ? Container(
            margin: const EdgeInsets.only(top: 8.0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: widget.post['media_attachments'].length == 1
                        ? Colors.grey.withOpacity(0.2)
                        : transparent,
                    width: 0.2)),
            child: GridLayoutImage(
              post: widget.post,
              medias: medias,
              handlePress: handlePress,
              isFocus: widget.isFocus,
              currentFocusVideoId: currentVideoId.value,
              updateDataFunction: widget.updateDataFunction,
              preType: widget.preType,
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
                  currentVideoId.value = video['id'];
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
