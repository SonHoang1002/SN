import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/data/friend.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/text_action.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class UserPageFriendBlock extends StatelessWidget {
  final dynamic user;
  const UserPageFriendBlock({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List friendRender =
        friendShips.length <= 6 ? friendShips : friendShips.sublist(0, 6);
    final theme = Provider.of<ThemeManager>(context);
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Bạn bè',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17),
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      TextDescription(
                          description: "${user['friends_count']} bạn bè")
                    ],
                  ),
                  TextAction(
                    title: "Xem tất cả bạn bè",
                    fontSize: 15,
                    action: () {},
                  )
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 7,
                      crossAxisCount: 3,
                      childAspectRatio: 0.8),
                  itemCount: friendRender.length,
                  itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: theme.themeMode == ThemeMode.dark
                                ? Theme.of(context).cardColor
                                : const Color(0xfff1f2f5)),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0)),
                              child: ImageCacheRender(
                                  height: size.width / 3 - 20,
                                  width: size.width / 3 - 15,
                                  path: friendShips[index]['avatar_media']
                                          ?['preview_url'] ??
                                      linkAvatarDefault),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            SizedBox(
                              width: size.width / 3 - 20,
                              child: Text(
                                '${friendRender[index]['display_name']}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            )
                          ],
                        ),
                      ))
            ],
          ),
        ],
      ),
    );
  }
}
