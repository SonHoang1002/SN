import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/feed_video.dart';
import 'package:transparent_image/transparent_image.dart';

class GirdviewBuilderMedia extends StatelessWidget {
  final List medias;
  final double aspectRatio;
  final int crossAxisCount;
  final dynamic flickMultiManager;
  final int? imageRemain;
  final Function? handlePress;

  const GirdviewBuilderMedia(
      {Key? key,
      required this.aspectRatio,
      required this.medias,
      required this.crossAxisCount,
      this.flickMultiManager,
      this.imageRemain,
      this.handlePress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkIsImage(media) {
      return media['type'] == 'image' ? true : false;
    }

    return GridView.builder(
        shrinkWrap: true,
        primary: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            crossAxisCount: crossAxisCount,
            childAspectRatio: aspectRatio),
        itemCount: medias.length,
        itemBuilder: (context, indexBg) => GestureDetector(
            onTap: () {
              if (handlePress != null) {
                handlePress!(medias[indexBg]);
              }
            },
            child: checkIsImage(medias[indexBg])
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: medias[indexBg]['url'],
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            const SizedBox(),
                      ),
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
                : FeedVideo(
                    path:
                        medias[indexBg]['remote_url'] ?? medias[indexBg]['url'],
                    flickMultiManager: flickMultiManager,
                    image: medias[indexBg]['preview_remote_url'] ??
                        medias[indexBg]['preview_url'])));
  }
}
