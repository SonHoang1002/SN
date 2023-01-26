import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class BannerBase extends StatelessWidget {
  final dynamic object;
  final dynamic objectMore;
  const BannerBase({Key? key, required this.object, this.objectMore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String path = object['banner']?['preview_url'] ?? linkBannerDefault;
    String pathAvatar =
        object['avatar_media']?['preview_url'] ?? linkAvatarDefault;
    String title = object['display_name'];
    String subTitle = objectMore?['general_information']?['other_name'] ?? '';
    final size = MediaQuery.of(context).size;

    return Container(
      constraints: const BoxConstraints(minHeight: 290),
      child: Stack(
        children: [
          ImageCacheRender(
            path: path,
            height: 200.0,
            width: size.width,
          ),
          Positioned(
              top: 100,
              left: 10,
              child: Container(
                  width: 132.0,
                  height: 132.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2.0, color: white)),
                  child: Stack(
                    children: [
                      AvatarSocial(
                          width: 130.0, height: 130.0, path: pathAvatar),
                      Positioned(
                          right: 6,
                          bottom: 6,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                color: white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 1.0, color: Colors.black)),
                            child: const Icon(
                              FontAwesomeIcons.camera,
                              size: 18,
                              color: Colors.black,
                            ),
                          ))
                    ],
                  ))),
          Positioned(
              right: 6,
              top: 159,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    color: white,
                    shape: BoxShape.circle,
                    border: Border.all(width: 1.0, color: Colors.black)),
                child: const Icon(
                  FontAwesomeIcons.camera,
                  size: 18,
                  color: Colors.black,
                ),
              )),
          Positioned(
            left: 10.0,
            top: 240,
            child: Text(
              '$title ${subTitle != '' ? '($subTitle)' : ''}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
