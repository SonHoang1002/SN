import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/config.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/video_player_none_controller.dart';

// ignore: must_be_immutable
class GridViewBuilderMedia extends StatefulWidget {
  final List medias;
  final double aspectRatio;
  final int crossAxisCount;
  final int? imageRemain;
  final Function? handlePress;
  final bool? isFocus;
  final dynamic currentFocusVideoId;
  final Function()? onEnd;
  final dynamic mediasNoneCheck;

  const GridViewBuilderMedia(
      {Key? key,
      required this.aspectRatio,
      required this.medias,
      required this.crossAxisCount,
      this.imageRemain,
      this.handlePress,
      this.isFocus,
      this.currentFocusVideoId,
      this.onEnd,
      this.mediasNoneCheck})
      : super(key: key);

  @override
  State<GridViewBuilderMedia> createState() => _GridViewBuilderMediaState();
}

class _GridViewBuilderMediaState extends State<GridViewBuilderMedia> {
  bool isPlaying = true;
  checkIsImage(media) {
    return media['type'] == 'image' ? true : false;
  }

  checkIsPlayVideo(int index) {
    return widget.currentFocusVideoId != widget.medias[index]['id'];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GridView.builder(
        shrinkWrap: true,
        primary: false,
        padding: EdgeInsets.only(bottom: widget.medias.length == 2 ? 6 : 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            crossAxisCount: widget.crossAxisCount,
            childAspectRatio: widget.aspectRatio),
        itemCount: widget.medias.length,
        itemBuilder: (context, indexBg) {
          return GestureDetector(
              onTap: () {
                setState(() {
                  isPlaying = false;
                });
                if (widget.handlePress != null) {
                  widget.handlePress!(widget.medias[indexBg]);
                }
              },
              child: checkIsImage(widget.medias[indexBg])
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        widget.medias[indexBg]['subType'] == 'local'
                            ? widget.medias[indexBg]['newUint8ListFile'] != null
                                ? Hero(
                                    tag: indexBg,
                                    child: Image.memory(
                                      widget.medias[indexBg]
                                          ['newUint8ListFile'],
                                      fit: BoxFit.fitWidth,
                                      width: size.width,
                                    ),
                                  )
                                : Hero(
                                    tag: indexBg,
                                    child: Image.file(
                                      widget.medias[indexBg]['file'],
                                      fit: BoxFit.cover,
                                    ),
                                  )
                            : Hero(
                                tag: widget.medias[indexBg]['id'] ?? indexBg,
                                child: ExtendedImage.network(
                                    (widget.medias[indexBg]?['url']) ??(widget.medias[indexBg]?['show_url'])??linkAvatarDefault ,
                                    fit: BoxFit.cover,
                                    width: size.width, loadStateChanged:
                                        (ExtendedImageState state) {
                                  if (state.extendedImageLoadState !=
                                      LoadState.completed) {
                                    return Container(
                                      height: double.parse(
                                          (widget.medias[indexBg]?['meta']
                                                      ?['small']?['height'] ??
                                                  400)
                                              .toString()),
                                      width: size.width,
                                      decoration: BoxDecoration(
                                          color: white,
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                    );
                                  }
                                })),
                        widget.imageRemain != null &&
                                widget.imageRemain! > 0 &&
                                indexBg + 1 == widget.medias.length
                            ? Positioned.fill(
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.black54,
                                  child: Text(
                                    '+ ${widget.imageRemain}',
                                    style: const TextStyle(
                                        fontSize: 32,
                                        color: white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              )
                            : const SizedBox()
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                          VideoPlayerNoneController(
                              aspectRatio: widget.aspectRatio,
                              path: widget.medias[indexBg]['file']?.path ??
                                  widget.medias[indexBg]['remote_url'] ??
                                  widget.medias[indexBg]['url'],
                              media: widget.medias[indexBg],
                              isPause: (widget.isFocus != true ||
                                  widget.currentFocusVideoId !=
                                      widget.medias[indexBg]['id'] ||
                                  !isPlaying),
                              // removeObserver:false,
                              type: widget.medias[indexBg]['file']?.path != null
                                  ? 'local'
                                  : 'network',
                              index: indexBg,
                              onEnd: () {
                                widget.onEnd != null ? widget.onEnd!() : null;
                              })
                        ]));
        });
  }
}
