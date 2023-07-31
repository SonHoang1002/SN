import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/screens/Moment/moment.dart';
import 'package:social_network_app_mobile/screens/Watch/watch_suggest.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/video_player_controller.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/video_player_none_controller.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widgets/gridview_builder_media.dart';

import '../theme/colors.dart';

class GridLayoutImage extends ConsumerStatefulWidget {
  final List medias;
  final Function handlePress;
  final dynamic post;
  final Function? updateDataFunction;
  final bool? isFocus;
  final String? preType;

  /// id of video
  final dynamic currentFocusVideoId;
  final Function()? onEnd;
  const GridLayoutImage(
      {Key? key,
      required this.medias,
      required this.handlePress,
      this.post,
      this.updateDataFunction,
      this.isFocus,
      this.currentFocusVideoId,
      this.onEnd,
      this.preType})
      : super(key: key);

  @override
  ConsumerState<GridLayoutImage> createState() => _GridLayoutImageState();
}

class _GridLayoutImageState extends ConsumerState<GridLayoutImage> {
  List listStatusMedia = [];

  checkIsImage(media) {
    return media['type'] == 'image' ? true : false;
  }

  getAspectMedia(media) {
    if (media['aspect'] != null) {
      return media['aspect'];
    } else {
      return checkIsImage(media)
          ? media['meta']['original']['aspect']
          : 1 / (media['meta']['original']?['aspect'] ?? 0.6);
    }
  }

  Widget renderLayoutMedia(context, medias) {
    final size = MediaQuery.sizeOf(context);
    switch (medias.length) {
      case 1:
        if (checkIsImage(medias[0])) {
          return ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: (medias[0]['aspect'] ??
                          medias[0]['meta']['original']['aspect']) <
                      0.4
                  ? 0.6
                  : 1,
              child: GestureDetector(
                onTap: () {
                  widget.handlePress(medias[0]);
                },
                child: Column(
                  children: [
                    buildDivider(color: greyColor),
                    medias[0]['subType'] == 'local'
                        ? medias[0]['newUint8ListFile'] != null
                            ? Image.memory(
                                medias[0]['newUint8ListFile'],
                                fit: BoxFit.fitWidth,
                                width: size.width,
                              )
                            : Image.file(
                                medias[0]['file'],
                                fit: BoxFit.cover,
                                width: size.width,
                              )
                        : Hero(
                            tag: medias[0]['id'],
                            child: ExtendedImage.network(
                                medias[0]['url'] ?? medias[0]['preview_url'],
                                fit: BoxFit.fitWidth,
                                width: size.width,
                                loadStateChanged: (ExtendedImageState state) {
                              if (state.extendedImageLoadState !=
                                  LoadState.completed) {
                                return Container(
                                  height: double.parse((medias[0]?['meta']
                                              ?['small']?['height'] *
                                          (size.width /
                                              medias[0]?['meta']?['small']
                                                  ?['width']))
                                      .toString()),
                                  width: size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: white),
                                );
                              }
                              return null;
                            }),
                          ),
                    buildDivider(color: greyColor),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container(
              constraints: const BoxConstraints(
                  // maxHeight: size.height * 0.75,
                  ),
              height: (medias[0]?['aspect'] ??
                          (medias[0]?['meta']?['small']?['aspect'])) <
                      1
                  ? size.width / (medias[0]?['meta']?['small']?['aspect'])
                  : null, 
              width: size.width,
              child: medias[0]['file'] != null
                  ? VideoPlayerNoneController(
                      path: medias[0]['file'].path,
                      type: "local",
                      isPause: (widget.isFocus != true ||
                          widget.currentFocusVideoId != medias[0]['id']),
                      onEnd: widget.onEnd != null ? widget.onEnd!() : null,
                      // removeObserver: false
                    )
                  : Hero(
                      tag: (medias[0]?['remote_url']) ?? (medias[0]?['url']),
                      child: VideoPlayerHasController(
                        media: medias[0],
                        isFocus: (widget.isFocus == true),
                        // (isFocus == true &&
                        //     currentFocusVideoId == medias[0]['id']),
                        handleTapAction: () {
                          medias[0]['file']?.path != null
                              ? null
                              : widget.post != null &&
                                      widget.post["post_type"] != null &&
                                      widget.post["post_type"] == 'moment'
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Moment(
                                                dataAdditional: widget.post,
                                                isBack: true,
                                              )))
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WatchSuggest(
                                              post: widget.post,
                                              preType: widget.preType,
                                              media: medias[0])));
                        },
                      ),
                    ));
        }
      case 2:
        return GridViewBuilderMedia(
          handlePress: widget.handlePress,
          crossAxisCount: getAspectMedia(medias[0]) > 1 ? 1 : 2,
          aspectRatio: double.parse(getAspectMedia(medias[0]).toString()),
          medias: medias,
          onEnd: widget.onEnd,
          isFocus: widget.isFocus,
          currentFocusVideoId: widget.currentFocusVideoId,
        );
      case 3:
        if (getAspectMedia(medias[0]) > 1) {
          return Column(
            children: [
              GridViewBuilderMedia(
                handlePress: widget.handlePress,
                crossAxisCount: 1,
                aspectRatio: double.parse(getAspectMedia(medias[0]).toString()),
                medias: medias.sublist(0, 1),
                onEnd: widget.onEnd,
                isFocus: widget.isFocus,
                currentFocusVideoId: widget.currentFocusVideoId,
              ),
              const SizedBox(
                height: 3,
              ),
              GridViewBuilderMedia(
                handlePress: widget.handlePress,
                crossAxisCount: 2,
                aspectRatio: 1,
                medias: medias.sublist(1, 3),
                onEnd: widget.onEnd,
                isFocus: widget.isFocus,
                currentFocusVideoId: widget.currentFocusVideoId,
              ),
            ],
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.65 - 4,
                child: GridViewBuilderMedia(
                  handlePress: widget.handlePress,
                  crossAxisCount: 1,
                  aspectRatio: 0.682,
                  medias: medias.sublist(0, 1),
                  onEnd: widget.onEnd,
                  isFocus: widget.isFocus,
                  currentFocusVideoId: widget.currentFocusVideoId,
                ),
              ),
              const SizedBox(
                width: 3,
              ),
              SizedBox(
                width: size.width * 0.35,
                child: GridViewBuilderMedia(
                  handlePress: widget.handlePress,
                  crossAxisCount: 1,
                  aspectRatio: 0.75,
                  medias: medias.sublist(1, 3),
                  onEnd: widget.onEnd,
                  isFocus: widget.isFocus,
                  currentFocusVideoId: widget.currentFocusVideoId,
                ),
              )
            ],
          );
        }

      case 4:
        if (getAspectMedia(medias[0]) == 1) {
          return GridViewBuilderMedia(
            handlePress: widget.handlePress,
            crossAxisCount: 2,
            aspectRatio: 1,
            medias: medias,
            mediasNoneCheck: medias,
            onEnd: widget.onEnd,
            isFocus: widget.isFocus,
            currentFocusVideoId: widget.currentFocusVideoId,
          );
        } else if (getAspectMedia(medias[0]) < 0.67) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.65 - 4,
                child: GridViewBuilderMedia(
                  handlePress: widget.handlePress,
                  crossAxisCount: 1,
                  aspectRatio: 0.639,
                  medias: medias.sublist(0, 1),
                  mediasNoneCheck: medias,
                  onEnd: widget.onEnd,
                  isFocus: widget.isFocus,
                  currentFocusVideoId: widget.currentFocusVideoId,
                ),
              ),
              const SizedBox(
                width: 3,
              ),
              SizedBox(
                width: size.width * 0.35,
                child: GridViewBuilderMedia(
                  handlePress: widget.handlePress,
                  crossAxisCount: 1,
                  aspectRatio: 1.06,
                  medias: medias.sublist(1),
                  mediasNoneCheck: medias,
                  onEnd: widget.onEnd,
                  isFocus: widget.isFocus,
                  currentFocusVideoId: widget.currentFocusVideoId,
                ),
              )
            ],
          );
        } else if (getAspectMedia(medias[0]) > 1) {
          return Column(
            children: [
              GridViewBuilderMedia(
                handlePress: widget.handlePress,
                crossAxisCount: 1,
                aspectRatio: double.parse(getAspectMedia(medias[0]).toString()),
                medias: medias.sublist(0, 1),
                mediasNoneCheck: medias,
                onEnd: widget.onEnd,
                isFocus: widget.isFocus,
                currentFocusVideoId: widget.currentFocusVideoId,
              ),
              const SizedBox(
                height: 3,
              ),
              GridViewBuilderMedia(
                handlePress: widget.handlePress,
                crossAxisCount: 3,
                aspectRatio: 1,
                medias: medias.sublist(1),
                mediasNoneCheck: medias,
                onEnd: widget.onEnd,
                isFocus: widget.isFocus,
                currentFocusVideoId: widget.currentFocusVideoId,
              ),
            ],
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 2, right: 2),
            child: GridView.count(
              primary: false,
              shrinkWrap: true,
              crossAxisCount: 4,
              crossAxisSpacing: 3,
              childAspectRatio: 0.337,
              children: List.generate(
                  medias.length,
                  (index) => Column(
                        children: [
                          SizedBox(
                            height: (index == 1 || index == 3) ? 25 : 0,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: GridViewBuilderMedia(
                              handlePress: widget.handlePress,
                              crossAxisCount: 1,
                              aspectRatio: 0.37,
                              medias: [medias[index]],
                              onEnd: widget.onEnd,
                              mediasNoneCheck: medias,
                              isFocus: widget.isFocus,
                              currentFocusVideoId: widget.currentFocusVideoId,
                            ),
                          ),
                        ],
                      )),
            ),
          );
        }

      default:
        if (getAspectMedia(medias[0]) < 1) {
          return Column(
            children: [
              GridViewBuilderMedia(
                handlePress: widget.handlePress,
                crossAxisCount: 2,
                aspectRatio: 1,
                medias: medias.sublist(0, 2),
                onEnd: widget.onEnd,
                isFocus: widget.isFocus,
                currentFocusVideoId: widget.currentFocusVideoId,
              ),
              const SizedBox(
                height: 3,
              ),
              GridViewBuilderMedia(
                handlePress: widget.handlePress,
                crossAxisCount: 3,
                aspectRatio: 1,
                imageRemain: medias.length - 5,
                medias: medias.sublist(2, 5),
                onEnd: widget.onEnd,
                isFocus: widget.isFocus,
                currentFocusVideoId: widget.currentFocusVideoId,
              ),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.5 - 1.5,
                child: GridViewBuilderMedia(
                  handlePress: widget.handlePress,
                  crossAxisCount: 1,
                  aspectRatio: 0.995,
                  medias: medias.sublist(0, 2),
                  onEnd: widget.onEnd,
                  isFocus: widget.isFocus,
                  currentFocusVideoId: widget.currentFocusVideoId,
                ),
              ),
              SizedBox(
                width: size.width * 0.5 - 1.5,
                child: GridViewBuilderMedia(
                  handlePress: widget.handlePress,
                  crossAxisCount: 1,
                  aspectRatio: 1.503,
                  imageRemain: medias.length - 5,
                  medias: medias.sublist(2, 5),
                  onEnd: widget.onEnd,
                  isFocus: widget.isFocus,
                  currentFocusVideoId: widget.currentFocusVideoId,
                ),
              )
            ],
          );
        }
    }
  }

  @override
  void initState() {
    super.initState();
    final newListStatusMedia = widget.medias.map((e) {
      if (e['type'] == 'video') {
        return false;
      } else {
        return null;
      }
    }).toList();
    final index = checkFirstEqualValue(newListStatusMedia, false);
    if (index != -1) {
      newListStatusMedia[index] = true;
    }
    listStatusMedia = newListStatusMedia;
  }

  int checkFirstEqualValue(List<bool?> arr, bool value) {
    for (int i = 0; i < arr.length; i++) {
      if (arr[i] == value) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return renderLayoutMedia(context, widget.medias);
  }
}
