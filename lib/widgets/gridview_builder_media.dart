import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/video_player_none_controller.dart';

// ignore: must_be_immutable
class GridViewBuilderMedia extends StatelessWidget {
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

  checkIsImage(media) {
    return media['type'] == 'image' ? true : false;
  }

  checkIsPlayVideo(int index) {
    return currentFocusVideoId != medias[index]['id'];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GridView.builder(
        shrinkWrap: true,
        primary: false,
        // padding: EdgeInsets.only(bottom: medias.length == 2 ? 6 : 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            crossAxisCount: crossAxisCount,
            childAspectRatio: aspectRatio),
        itemCount: medias.length,
        itemBuilder: (context, indexBg) {
          return GestureDetector(
              onTap: () {
                if (handlePress != null) {
                  handlePress!(medias[indexBg]);
                }
              },
              child: checkIsImage(medias[indexBg])
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        medias[indexBg]['subType'] == 'local'
                            ? medias[indexBg]['newUint8ListFile'] != null
                                ? Hero(
                                    tag: indexBg,
                                    child: Image.memory(
                                      medias[indexBg]['newUint8ListFile'],
                                      fit: BoxFit.fitWidth,
                                      width: size.width,
                                    ),
                                  )
                                : Hero(
                                    tag: indexBg,
                                    child: Image.file(
                                      medias[indexBg]['file'],
                                      fit: BoxFit.cover,
                                    ),
                                  )
                            : Hero(
                                tag: medias[indexBg]['id'] ?? indexBg,
                                child: ExtendedImage.network(
                                    medias[indexBg]['url'],
                                    fit: BoxFit.cover,
                                    width: size.width, loadStateChanged:
                                        (ExtendedImageState state) {
                                  if (state.extendedImageLoadState !=
                                      LoadState.completed) {
                                    return Container(
                                      height: double.parse((medias[indexBg]
                                                      ?['meta']?['small']
                                                  ?['height'] ??
                                              400)
                                          .toString()),
                                      width: size.width,
                                      color: white,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                    );
                                  }
                                })),
                        imageRemain != null &&
                                imageRemain! > 0 &&
                                indexBg + 1 == medias.length
                            ? Positioned.fill(
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.black54,
                                  child: Text(
                                    '+ $imageRemain',
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
                              aspectRatio: aspectRatio,
                              path: medias[indexBg]['file']?.path ??
                                  medias[indexBg]['remote_url'] ??
                                  medias[indexBg]['url'],
                              media: medias[indexBg],
                              isPause: (isFocus != true ||
                                  currentFocusVideoId != medias[indexBg]['id']),
                              // removeObserver:false,
                              type: medias[indexBg]['file']?.path != null
                                  ? 'local'
                                  : 'network',
                              index: indexBg,
                              onEnd: () {
                                onEnd != null ? onEnd!() : null;
                              })
                        ]));
        });
  }
}
