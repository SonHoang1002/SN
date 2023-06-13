import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/screens/UserPage/page_friend_user.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';
import 'package:social_network_app_mobile/widgets/text_action.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';

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
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Column(
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
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 7,
                              crossAxisCount: 3,
                              childAspectRatio: 0.75),
                      itemCount: widget.friends.length > 6
                          ? widget.friends.sublist(0, 6).length
                          : widget.friends.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserPage(),
                              settings: RouteSettings(
                                arguments: {
                                  'id': widget.friends[index]['id'],
                                },
                              ),
                            ),
                          );
                        },
                        child: CardComponents(
                          type: 'avatarFriend',
                          imageCard: SizedBox(
                            height: 110.0,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              child: ImageCacheRender(
                                path: widget.friends[index]['avatar_media']
                                        ?['preview_url'] ??
                                    linkAvatarDefault,
                              ),
                            ),
                          ),
                          textCard: Container(
                            padding: const EdgeInsets.only(
                              top: 12.0,
                              left: 10,
                              right: 10,
                            ),
                            child: Text(
                              '${widget.friends[index]['display_name']}',
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
  }
}
