import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/friends_api.dart';
import 'package:social_network_app_mobile/providers/friend/friend_provider.dart';
import 'package:social_network_app_mobile/screen/Friend/friend_request.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class FriendRender extends ConsumerStatefulWidget {
  const FriendRender({super.key});
  @override
  ConsumerState<FriendRender> createState() => _FriendRenderState();
}

class _FriendRenderState extends ConsumerState<FriendRender> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(
          Duration.zero,
          () => {
                ref
                    .read(friendControllerProvider.notifier)
                    .getListFriendRequest({"limit": 20}),
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
    List friendRequest = ref.watch(friendControllerProvider).friendRequest;
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          ref
              .read(friendControllerProvider.notifier)
              .getListFriendRequest({"limit": 20});
          ref
              .read(friendControllerProvider.notifier)
              .getListFriendSuggest({"limit": 25});
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              friendRequest.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                              child: Text('Lời mời kết bạn'),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 0.0, 16.0, 16.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const FriendRequest()),
                                  );
                                },
                                child: const Text('Xem tất cả',
                                    style: TextStyle(color: Colors.blue)),
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: friendRequest.length,
                          itemBuilder: ((context, index) => InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const UserPage(),
                                      settings: RouteSettings(
                                        arguments: {
                                          'id': friendRequest[index]['id']
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0,
                                              right: 16.0,
                                              bottom: 16.0),
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    friendRequest[index]
                                                                    ['account'][
                                                                'avatar_media'] !=
                                                            null
                                                        ? friendRequest[index]
                                                                    ['account']
                                                                ['avatar_media']
                                                            ['preview_url']
                                                        : friendRequest[index]
                                                                ['account']
                                                            ['avatar_static']),
                                          ),
                                        ),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(friendRequest[index]
                                                  ['account']['display_name']),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              friendRequest[index]['account']['relationships']['friendship_status'] !=
                                                          'ARE_FRIENDS' &&
                                                      friendRequest[index]
                                                                      ['account']
                                                                  ['relationships'][
                                                              'friendship_status'] !=
                                                          'CAN_REQUEST'
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            '${friendRequest[index]['account']['friends_count']} bạn chung',
                                                            style: const TextStyle(
                                                                color:
                                                                    greyColor)),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                setState(() {
                                                                  friendRequest[index]['account']
                                                                              [
                                                                              'relationships']
                                                                          [
                                                                          'friendship_status'] =
                                                                      'ARE_FRIENDS';
                                                                });
                                                                await ref
                                                                    .read(friendControllerProvider
                                                                        .notifier)
                                                                    .statusFriendRequest(
                                                                        'add',
                                                                        friendRequest[index]['account']
                                                                            [
                                                                            'id']);
                                                              },
                                                              child: Container(
                                                                height: 35,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.3,
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        secondaryColor,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                6),
                                                                    border: Border.all(
                                                                        width:
                                                                            0.2,
                                                                        color:
                                                                            greyColor)),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: const [
                                                                    Text(
                                                                      'Xác nhận',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        color: Colors
                                                                            .white,
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
                                                              onTap: () async {
                                                                setState(() {
                                                                  friendRequest[index]['account']
                                                                              [
                                                                              'relationships']
                                                                          [
                                                                          'friendship_status'] =
                                                                      'CAN_REQUEST';
                                                                });
                                                                await ref
                                                                    .read(friendControllerProvider
                                                                        .notifier)
                                                                    .statusFriendRequest(
                                                                        'reject',
                                                                        friendRequest[index]['account']
                                                                            [
                                                                            'id']);
                                                              },
                                                              child: Container(
                                                                height: 35,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.3,
                                                                decoration: BoxDecoration(
                                                                    color: const Color
                                                                            .fromARGB(
                                                                        189,
                                                                        202,
                                                                        202,
                                                                        202),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                6),
                                                                    border: Border.all(
                                                                        width:
                                                                            0.2,
                                                                        color:
                                                                            greyColor)),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: const [
                                                                    Text(
                                                                      'Xoá',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        color: Colors
                                                                            .black,
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
                                                      ],
                                                    )
                                                  : friendRequest[index]['account']
                                                                  ['relationships'][
                                                              'friendship_status'] ==
                                                          'ARE_FRIENDS'
                                                      ? Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                                'Lời mời đã được chấp nhận',
                                                                style: TextStyle(
                                                                    color:
                                                                        greyColor,
                                                                    fontSize:
                                                                        12)),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            InkWell(
                                                              onTap: () {},
                                                              child: Container(
                                                                height: 35,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.65,
                                                                decoration: BoxDecoration(
                                                                    color: const Color
                                                                            .fromARGB(
                                                                        189,
                                                                        202,
                                                                        202,
                                                                        202),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                6),
                                                                    border: Border.all(
                                                                        width:
                                                                            0.2,
                                                                        color:
                                                                            greyColor)),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: const [
                                                                    Icon(
                                                                        FontAwesomeIcons
                                                                            .hands,
                                                                        size:
                                                                            16,
                                                                        color: Colors
                                                                            .yellow),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      'Vẫy tay chào',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : friendRequest[index]
                                                                          ['account']
                                                                      ['relationships']
                                                                  ['friendship_status'] ==
                                                              'CAN_REQUEST'
                                                          ? Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: const [
                                                                Text(
                                                                    'Đã gỡ lời mời kết bạn',
                                                                    style: TextStyle(
                                                                        color:
                                                                            greyColor,
                                                                        fontSize:
                                                                            12)),
                                                                SizedBox(
                                                                  height: 10,
                                                                )
                                                              ],
                                                            )
                                                          : const SizedBox()
                                            ]),
                                      ],
                                    ),
                                    friendRequest[index]['account']
                                                    ['relationships']
                                                ['friendship_status'] ==
                                            'CAN_REQUEST'
                                        ? const Padding(
                                            padding:
                                                EdgeInsets.only(right: 16.0),
                                            child:
                                                Icon(FontAwesomeIcons.ellipsis),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              )),
                        ),
                      ],
                    )
                  : const SizedBox(),
              friendSuggestions.isNotEmpty
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
                                          left: 16.0,
                                          right: 16.0,
                                          bottom: 16.0),
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                friendSuggestions[index]
                                                            ['avatar_media'] !=
                                                        null
                                                    ? friendSuggestions[index]
                                                            ['avatar_media']
                                                        ['preview_url']
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
                                              '${friendSuggestions[index]['friends_count']} bạn chung',
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
                                                          friendSuggestions[
                                                              index]['id']);
                                                  await ref
                                                      .read(
                                                          friendControllerProvider
                                                              .notifier)
                                                      .removeFriendSuggest(
                                                          friendSuggestions[
                                                              index]['id']);
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
                                                          BorderRadius.circular(
                                                              6),
                                                      border: Border.all(
                                                          width: 0.2,
                                                          color: greyColor)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Text(
                                                        'Thêm bạn bè',
                                                        textAlign:
                                                            TextAlign.center,
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
                                                      .read(
                                                          friendControllerProvider
                                                              .notifier)
                                                      .removeFriendSuggest(
                                                          friendSuggestions[
                                                              index]['id']);
                                                },
                                                child: Container(
                                                  height: 35,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              189,
                                                              202,
                                                              202,
                                                              202),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      border: Border.all(
                                                          width: 0.2,
                                                          color: greyColor)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Text(
                                                        'Gỡ',
                                                        textAlign:
                                                            TextAlign.center,
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
            ],
          ),
        ),
      ),
    );
  }
}
