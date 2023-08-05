import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class ExtendedImageNetWorkCustom extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;
  final BoxFit? fit;
  const ExtendedImageNetWorkCustom(
      {super.key,
      required this.path,
      required this.height,
      required this.width,
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
          return Container(
            height: height,
            width: width,
            color: greyColor,
          );
        }
        return null;
      },
    );
  }
}
