import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/data/me_data.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/text_action.dart';

class UserPageEditProfile extends StatelessWidget {
  const UserPageEditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            BlockProfile(
                title: "Ảnh đại diện",
                widgetChild: Container(
                  width: 151,
                  height: 151,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 0.1, color: greyColor)),
                  child: AvatarSocial(
                      width: 150,
                      height: 150,
                      path: meData['avatar_media']?['preview_url'] ??
                          linkAvatarDefault),
                )),
            const CrossBar(
              height: 1,
              margin: 15,
            ),
            BlockProfile(
              title: "Ảnh bìa",
              widgetChild: Container(
                  width: size.width - 30 + 1,
                  height: (size.width - 30) * 1.8 / 3 + 1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(width: 0.1, color: greyColor)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: ImageCacheRender(
                        width: size.width - 30,
                        height: (size.width - 30) * 1.8 / 3,
                        path: meData['banner']?['preview_url'] ??
                            linkBannerDefault),
                  )),
            ),
            const CrossBar(
              height: 1,
              margin: 15,
            ),
            BlockProfile(
              title: "Tiểu sử",
              widgetChild: Text(
                '${userAbout['general_information']['description']}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: greyColor),
              ),
            ),
            const CrossBar(
              height: 1,
              margin: 15,
            ),
            BlockProfile(
              title: "Chi tiết",
              widgetChild: Text(
                '${userAbout['general_information']['description']}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: greyColor),
              ),
            ),
            const CrossBar(
              height: 1,
              margin: 15,
            ),
            BlockProfile(
              title: "Sở thích",
              widgetChild: Text(
                '${userAbout['general_information']['description']}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: greyColor),
              ),
            ),
            const CrossBar(
              height: 1,
              margin: 15,
            ),
            BlockProfile(
              title: "Đáng chú ý",
              widgetChild: Text(
                '${userAbout['general_information']['description']}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: greyColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlockProfile extends StatelessWidget {
  final String title;
  final Widget widgetChild;

  const BlockProfile({
    super.key,
    required this.title,
    required this.widgetChild,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            TextAction(
              action: () {},
              fontSize: 17,
              title: 'Chỉnh sửa',
            )
          ],
        ),
        const SizedBox(
          height: 12.0,
        ),
        widgetChild,
        const SizedBox()
      ],
    );
  }
}
