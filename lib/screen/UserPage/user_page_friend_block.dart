import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/UserPage/user_information_provider.dart';
import 'package:social_network_app_mobile/screen/UserPage/page_friend_user.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_page.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/text_action.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class UserPageFriendBlock extends ConsumerStatefulWidget {
  final dynamic user;
  final List friends;
  const UserPageFriendBlock({
    Key? key,
    this.user,
    required this.friends,
  }) : super(key: key);

  @override
  ConsumerState<UserPageFriendBlock> createState() =>
      _UserPageFriendBlockState();
}

class _UserPageFriendBlockState extends ConsumerState<UserPageFriendBlock> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    final size = MediaQuery.of(context).size;

    return widget.friends.isEmpty
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: const Text(
              'Chưa có bạn bè',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          )
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
                            if (widget.user != null)
                              TextDescription(
                                  description:
                                      "${widget.user['friends_count']} bạn bè")
                          ],
                        ),
                        TextAction(
                          title: "Xem tất cả bạn bè",
                          fontSize: 15,
                          action: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        PageFriendUser(user: widget.user)));
                          },
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
                        itemCount: widget.friends.sublist(0, 6).length,
                        itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserPage(),
                                      settings: RouteSettings(
                                        arguments: {
                                          'id': widget.friends[index]['id']
                                        },
                                      ),
                                    ));
                              },
                              child: Container(
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
                                          path: widget.friends[index]
                                                      ['avatar_media']
                                                  ?['preview_url'] ??
                                              linkAvatarDefault),
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    SizedBox(
                                      width: size.width / 3 - 20,
                                      child: Text(
                                        '${widget.friends[index]['display_name']}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ))
                  ],
                ),
              ],
            ),
          );
  }
}
