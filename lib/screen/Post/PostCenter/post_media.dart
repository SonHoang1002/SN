import 'package:flutter/cupertino.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/Post/post_mutiple_media_detail.dart';

import 'package:social_network_app_mobile/widget/FeedVideo/feed_video.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/flick_multiple_manager.dart';
import 'package:social_network_app_mobile/widget/girdview_builder_media.dart';
import 'package:transparent_image/transparent_image.dart';

class PostMedia extends StatefulWidget {
  final dynamic post;
  const PostMedia({Key? key, this.post}) : super(key: key);

  @override
  State<PostMedia> createState() => _PostMediaState();
}

class _PostMediaState extends State<PostMedia> {
  late FlickMultiManager flickMultiManager;

  @override
  void initState() {
    super.initState();
    flickMultiManager = FlickMultiManager();
  }

  @override
  Widget build(BuildContext context) {
    List medias = widget.post['media_attachments'] ?? [];

    return medias.isNotEmpty
        ? Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: renderLayoutMedia(medias),
          )
        : const SizedBox();
  }

  checkIsImage(media) {
    return media['type'] == 'image' ? true : false;
  }

  handlePress(media) {
    if (checkIsImage(media)) {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => CreateModalBaseMenu(
                  title: 'Bài viết',
                  body: PostMutipleMediaDetail(post: widget.post),
                  buttonAppbar: const SizedBox())));
    } else {
      return;
    }
  }

  getAspectMedia(media) {
    return checkIsImage(media)
        ? media['meta']['original']['aspect']
        : 1 / media['meta']['original']['aspect'];
  }

  renderLayoutMedia(medias) {
    final size = MediaQuery.of(context).size;
    switch (medias.length) {
      case 1:
        if (checkIsImage(medias[0])) {
          return ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor:
                  medias[0]['meta']['original']['aspect'] < 0.4 ? 0.6 : 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: medias[0]['url'],
                  imageErrorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              constraints: BoxConstraints(maxHeight: size.height * 0.6),
              child: FeedVideo(
                  path: medias[0]['remote_url'] ?? medias[0]['url'],
                  flickMultiManager: flickMultiManager,
                  image: medias[0]['preview_remote_url'] ??
                      medias[0]['preview_url'] ??
                      ''),
            ),
          );
        }
      case 2:
        return GirdviewBuilderMedia(
            handlePress: handlePress,
            flickMultiManager: flickMultiManager,
            crossAxisCount: getAspectMedia(medias[0]) > 1 ? 1 : 2,
            aspectRatio: double.parse(getAspectMedia(medias[0]).toString()),
            medias: medias);
      case 3:
        if (getAspectMedia(medias[0]) > 1) {
          return Expanded(
            child: Column(
              children: [
                GirdviewBuilderMedia(
                    handlePress: handlePress,
                    flickMultiManager: flickMultiManager,
                    crossAxisCount: 1,
                    aspectRatio:
                        double.parse(getAspectMedia(medias[0]).toString()),
                    medias: medias.sublist(0, 1)),
                const SizedBox(
                  height: 3,
                ),
                GirdviewBuilderMedia(
                    handlePress: handlePress,
                    flickMultiManager: flickMultiManager,
                    crossAxisCount: 2,
                    aspectRatio: 1,
                    medias: medias.sublist(1, 3)),
              ],
            ),
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.65 - 3,
                child: GirdviewBuilderMedia(
                    handlePress: handlePress,
                    flickMultiManager: flickMultiManager,
                    crossAxisCount: 1,
                    aspectRatio: 0.682,
                    medias: medias.sublist(0, 1)),
              ),
              const SizedBox(
                width: 3,
              ),
              SizedBox(
                width: size.width * 0.35,
                child: GirdviewBuilderMedia(
                    handlePress: handlePress,
                    flickMultiManager: flickMultiManager,
                    crossAxisCount: 1,
                    aspectRatio: 0.75,
                    medias: medias.sublist(1, 3)),
              )
            ],
          );
        }

      case 4:
        if (getAspectMedia(medias[0]) == 1) {
          return GirdviewBuilderMedia(
              handlePress: handlePress,
              flickMultiManager: flickMultiManager,
              crossAxisCount: 2,
              aspectRatio: 1,
              medias: medias);
        } else if (getAspectMedia(medias[0]) < 0.67) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.65 - 3,
                child: GirdviewBuilderMedia(
                    handlePress: handlePress,
                    flickMultiManager: flickMultiManager,
                    crossAxisCount: 1,
                    aspectRatio: 0.639,
                    medias: medias.sublist(0, 1)),
              ),
              const SizedBox(
                width: 3,
              ),
              SizedBox(
                width: size.width * 0.35,
                child: GirdviewBuilderMedia(
                    handlePress: handlePress,
                    flickMultiManager: flickMultiManager,
                    crossAxisCount: 1,
                    aspectRatio: 1.06,
                    medias: medias.sublist(1)),
              )
            ],
          );
        } else if (getAspectMedia(medias[0]) > 1) {
          return Expanded(
              child: Column(
            children: [
              GirdviewBuilderMedia(
                  handlePress: handlePress,
                  flickMultiManager: flickMultiManager,
                  crossAxisCount: 1,
                  aspectRatio:
                      double.parse(getAspectMedia(medias[0]).toString()),
                  medias: medias.sublist(0, 1)),
              const SizedBox(
                height: 3,
              ),
              GirdviewBuilderMedia(
                  handlePress: handlePress,
                  flickMultiManager: flickMultiManager,
                  crossAxisCount: 3,
                  aspectRatio: 1,
                  medias: medias.sublist(1)),
            ],
          ));
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 2, right: 2),
            child: GridView.count(
              primary: false,
              shrinkWrap: true,
              crossAxisCount: 4,
              crossAxisSpacing: 3,
              childAspectRatio: 0.315,
              children: List.generate(
                  medias.length,
                  (index) => Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: (index == 1 || index == 3) ? 25 : 0,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: GirdviewBuilderMedia(
                                  handlePress: handlePress,
                                  flickMultiManager: flickMultiManager,
                                  crossAxisCount: 1,
                                  aspectRatio: 0.35,
                                  medias: [medias[index]]),
                            ),
                          ],
                        ),
                      )),
            ),
          );
        }

      default:
        if (getAspectMedia(medias[0]) < 1) {
          return Expanded(
            child: Column(
              children: [
                GirdviewBuilderMedia(
                    handlePress: handlePress,
                    flickMultiManager: flickMultiManager,
                    crossAxisCount: 2,
                    aspectRatio: 1,
                    medias: medias.sublist(0, 2)),
                const SizedBox(
                  height: 3,
                ),
                GirdviewBuilderMedia(
                    handlePress: handlePress,
                    flickMultiManager: flickMultiManager,
                    crossAxisCount: 3,
                    aspectRatio: 1,
                    imageRemain: medias.length - 5,
                    medias: medias.sublist(2, 5)),
              ],
            ),
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.5 - 1.5,
                child: GirdviewBuilderMedia(
                    handlePress: handlePress,
                    flickMultiManager: flickMultiManager,
                    crossAxisCount: 1,
                    aspectRatio: 0.995,
                    medias: medias.sublist(0, 2)),
              ),
              SizedBox(
                width: size.width * 0.5 - 1.5,
                child: GirdviewBuilderMedia(
                    handlePress: handlePress,
                    flickMultiManager: flickMultiManager,
                    crossAxisCount: 1,
                    aspectRatio: 1.503,
                    imageRemain: medias.length - 5,
                    medias: medias.sublist(2, 5)),
              )
            ],
          );
        }
    }
  }
}
