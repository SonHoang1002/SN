import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/friends_api.dart';
import 'package:social_network_app_mobile/providers/friend/friend_provider.dart';
import 'package:social_network_app_mobile/screens/Friend/friend_search.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

class FriendSuggest extends ConsumerStatefulWidget {
  const FriendSuggest({super.key});

  @override
  ConsumerState<FriendSuggest> createState() => _FriendSuggestState();
}

class _FriendSuggestState extends ConsumerState<FriendSuggest> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(
          Duration.zero,
          () => {
                ref
                    .read(friendControllerProvider.notifier)
                    .getListFriendSuggest({"limit": 25})
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    List friendSuggestions =
        ref.watch(friendControllerProvider).friendSuggestions;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
        leading: const BackIconAppbar(),
        centerTitle: true,
        title: const AppBarTitle(title: 'Gợi ý'),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                FontAwesomeIcons.search,
                size: 17,
                color: colorWord(context),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref
              .read(friendControllerProvider.notifier)
              .getListFriendSuggest({"limit": 25});
        },
        child: SingleChildScrollView(
          child: friendSuggestions.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                      child: Text('Những người bạn có thể biết'),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: friendSuggestions.length,
                      itemBuilder: ((context, index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserPage(),
                                  settings: RouteSettings(
                                    arguments: {
                                      'id': friendSuggestions[index]['id']
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0, bottom: 16.0),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: CachedNetworkImageProvider(
                                        friendSuggestions[index]
                                                    ['avatar_media'] !=
                                                null
                                            ? friendSuggestions[index]
                                                ['avatar_media']['preview_url']
                                            : friendSuggestions[index]
                                                ['avatar_static']),
                                  ),
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(friendSuggestions[index]
                                          ['display_name']),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          '${friendSuggestions[index]['relationships']['mutual_friend_count'] ?? 0} bạn chung',
                                          style: const TextStyle(
                                              color: greyColor)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              await FriendsApi()
                                                  .sendFriendRequestApi(
                                                      friendSuggestions[index]
                                                          ['id']);
                                              await ref
                                                  .read(friendControllerProvider
                                                      .notifier)
                                                  .removeFriendSuggest(
                                                      friendSuggestions[index]
                                                          ['id']);
                                            },
                                            child: Container(
                                              height: 35,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              decoration: BoxDecoration(
                                                  color: secondaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      width: 0.2,
                                                      color: greyColor)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text(
                                                    'Thêm bạn bè',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              ref
                                                  .read(friendControllerProvider
                                                      .notifier)
                                                  .removeFriendSuggest(
                                                      friendSuggestions[index]
                                                          ['id']);
                                            },
                                            child: Container(
                                              height: 35,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      189, 202, 202, 202),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      width: 0.2,
                                                      color: greyColor)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text(
                                                    'Gỡ',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ])
                              ],
                            ),
                          )),
                    )
                  ],
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
