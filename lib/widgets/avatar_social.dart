import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';

class AvatarSocial extends StatelessWidget {
  final double width;
  final double height;
  final String path;
  final bool? isGroup;
  final dynamic object;

  const AvatarSocial(
      {Key? key,
      required this.width,
      required this.height,
      required this.path,
      this.isGroup,
      this.object})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic frame = object?['avatar_media']?['frame'];
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(
              isGroup != null && isGroup == true ? 10 : width / 2),
          child: ImageCacheRender(path: path, width: width, height: height),
        ),
        frame != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(width / 2),
                child: ImageCacheRender(
                  path: frame['url'],
                  width: width,
                  height: width,
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
