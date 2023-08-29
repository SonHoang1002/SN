import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';

class ExtendedImageNetworkCustom extends StatelessWidget {
  final String path;
  final double height;
  final double width;
  final BoxFit? fit;
  final String? linkPreview;
  const ExtendedImageNetworkCustom(
      {super.key,
      required this.path,
      required this.height,
      required this.width,
      this.linkPreview,
      this.fit});

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      key: key,
      path,
      fit: fit,
      height: height,
      width: width,
      filterQuality: FilterQuality.high,
      loadStateChanged: (state) {
        if (state.extendedImageLoadState != LoadState.completed) {
          return ExtendedImage.network(
            linkPreview ?? linkBannerDefault,
            height: height,
            width: width,
          );
        }
      },
    );
  }
}
