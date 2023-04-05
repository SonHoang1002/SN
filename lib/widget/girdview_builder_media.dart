import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/video_player_none_controller.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

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
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
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
                      medias[0]['subType'] == 'local'
                          ? Image.file(
                              medias[indexBg]['file'],
                              fit: BoxFit.cover,
                            )
                          : ImageCacheRender(path: medias[indexBg]['url']),
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
                            type: medias[indexBg]['file']?.path != null
                                ? 'local'
                                : 'network'),
                      ])));
  }
}
