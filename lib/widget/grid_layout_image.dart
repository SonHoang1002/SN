import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screen/Moment/moment.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/screen/Watch/watch_suggest.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/video_player_controller.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/gridview_builder_media.dart';

import '../theme/colors.dart';

class GridLayoutImage extends StatefulWidget {
  final List medias;
  final Function handlePress;
  final dynamic post;
  const GridLayoutImage(
      {Key? key, required this.medias, required this.handlePress, this.post})
      : super(key: key);

  @override
  State<GridLayoutImage> createState() => _GridLayoutImageState();
}

class _GridLayoutImageState extends State<GridLayoutImage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkIsImage(media) {
      return media['type'] == 'image' ? true : false;
    }

    getAspectMedia(media) {
      if (media['aspect'] != null) {
        return media['aspect'];
      } else {
        return checkIsImage(media)
            ? media['meta']['original']['aspect']
            : 1 / media['meta']['original']['aspect'];
      }
    }

    /// return List[width,height]
    List<double?> checkHeightAndWidthOneImage(medias) {
      final size = MediaQuery.of(context).size;
      List<double?> values = [null, null];
      double width =
          double.parse(medias[0]['meta']['small']['width'].toString());
      double height =
          double.parse(medias[0]['meta']['small']['height'].toString());
      values[0] = size.width;
      if (width < height) {
        //anh doc
        if (height > 400) {
          values[1] = height;
        } else {
          values[1] = 400;
        }
      } else {
        // anh ngang
      }

      return values;
    }

    renderLayoutMedia(medias) {
      final size = MediaQuery.of(context).size;
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
                          ? Image.file(
                              medias[0]['file'],
                              fit: BoxFit.cover,
                            )
                          : Hero(
                              tag: medias[0]['id'],
                              child: ExtendedImage.network(
                                medias[0]['url'],
                                fit: BoxFit.fitWidth,
                                width: checkHeightAndWidthOneImage(medias)[0],
                                height: checkHeightAndWidthOneImage(medias)[1],
                              ),
                            ),
                      buildDivider(color: greyColor),
                    ],
                  ),
                ),
              ),
            );
          } else {
            String path = medias[0]['file']?.path ??
                medias[0]['remote_url'] ??
                medias[0]['url'];
            return SizedBox(
                height: (medias[0]['aspect'] ??
                            medias[0]['meta']['original']['aspect'] ??
                            1) <
                        1
                    ? size.width
                    : null,
                child: Stack(
                  children: [
                    VideoPlayerHasController(
                        media: medias[0], hasDispose: true),
                    Positioned.fill(child: GestureDetector(
                      onTap: () {
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
                                            )))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WatchSuggest(
                                            post: widget.post,
                                            media: medias[0])));
                      },
                    ))
                  ],
                )
                // VideoPlayerNoneController(
                //     path: path,
                //     media: medias[0],
                //     post: widget.post,
                //     type: medias[0]['file']?.path != null
                //         ? 'local'
                //         : 'network')
                );
          }
        case 2:
          return GridViewBuilderMedia(
              handlePress: widget.handlePress,
              crossAxisCount: getAspectMedia(medias[0]) > 1 ? 1 : 2,
              aspectRatio: double.parse(getAspectMedia(medias[0]).toString()),
              medias: medias);
        case 3:
          if (getAspectMedia(medias[0]) > 1) {
            return Column(
              children: [
                GridViewBuilderMedia(
                    handlePress: widget.handlePress,
                    crossAxisCount: 1,
                    aspectRatio:
                        double.parse(getAspectMedia(medias[0]).toString()),
                    medias: medias.sublist(0, 1)),
                const SizedBox(
                  height: 3,
                ),
                GridViewBuilderMedia(
                    handlePress: widget.handlePress,
                    crossAxisCount: 2,
                    aspectRatio: 1,
                    medias: medias.sublist(1, 3)),
              ],
            );
          } else {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width * 0.65 - 3,
                  child: GridViewBuilderMedia(
                      handlePress: widget.handlePress,
                      crossAxisCount: 1,
                      aspectRatio: 0.682,
                      medias: medias.sublist(0, 1)),
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
                      medias: medias.sublist(1, 3)),
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
                medias: medias);
          } else if (getAspectMedia(medias[0]) < 0.67) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width * 0.65 - 3,
                  child: GridViewBuilderMedia(
                      handlePress: widget.handlePress,
                      crossAxisCount: 1,
                      aspectRatio: 0.639,
                      medias: medias.sublist(0, 1)),
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
                      medias: medias.sublist(1)),
                )
              ],
            );
          } else if (getAspectMedia(medias[0]) > 1) {
            return Column(
              children: [
                GridViewBuilderMedia(
                    handlePress: widget.handlePress,
                    crossAxisCount: 1,
                    aspectRatio:
                        double.parse(getAspectMedia(medias[0]).toString()),
                    medias: medias.sublist(0, 1)),
                const SizedBox(
                  height: 3,
                ),
                GridViewBuilderMedia(
                    handlePress: widget.handlePress,
                    crossAxisCount: 3,
                    aspectRatio: 1,
                    medias: medias.sublist(1)),
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
                                  medias: [medias[index]]),
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
                    medias: medias.sublist(0, 2)),
                const SizedBox(
                  height: 3,
                ),
                GridViewBuilderMedia(
                    handlePress: widget.handlePress,
                    crossAxisCount: 3,
                    aspectRatio: 1,
                    imageRemain: medias.length - 5,
                    medias: medias.sublist(2, 5)),
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
                      medias: medias.sublist(0, 2)),
                ),
                SizedBox(
                  width: size.width * 0.5 - 1.5,
                  child: GridViewBuilderMedia(
                      handlePress: widget.handlePress,
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

    return renderLayoutMedia(widget.medias);
  }
}
