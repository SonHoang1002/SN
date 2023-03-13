import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/UserPage/user_information_provider.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/text_action.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class UserPageFriendBlock extends ConsumerStatefulWidget {
  final dynamic user;
  const UserPageFriendBlock({Key? key, this.user}) : super(key: key);

  @override
  ConsumerState<UserPageFriendBlock> createState() =>
      _UserPageFriendBlockState();
}

class _UserPageFriendBlockState extends ConsumerState<UserPageFriendBlock> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref
          .read(userInformationProvider.notifier)
          .getUserFriend(widget.user['id'], {"limit": 6});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    final size = MediaQuery.of(context).size;
    List friends = ref.watch(userInformationProvider).friends;

    return friends.isEmpty
        ? const SizedBox()
        : Container(
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
                                description:
                                    "${widget.user['friends_count']} bạn bè")
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 7,
                                crossAxisCount: 3,
                                childAspectRatio: 0.8),
                        itemCount: friends.length,
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
                                        path: friends[index]['avatar_media']
                                                ?['preview_url'] ??
                                            linkAvatarDefault),
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  SizedBox(
                                    width: size.width / 3 - 20,
                                    child: Text(
                                      '${friends[index]['display_name']}',
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
