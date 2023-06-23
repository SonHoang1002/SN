import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/friend/friend_provider.dart';
import 'package:social_network_app_mobile/screens/Friend/friend_search.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

import '../../widgets/appbar_title.dart';

class FriendRequest extends ConsumerStatefulWidget {
  const FriendRequest({super.key});

  @override
  ConsumerState<FriendRequest> createState() => _FriendRequestState();
}

class _FriendRequestState extends ConsumerState<FriendRequest> {
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
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    List friendRequest = ref.watch(friendControllerProvider).friendRequest;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: true,
        leading: const BackIconAppbar(),
        title: const AppBarTitle(title: 'Lời mời kết bạn'),
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
              .getListFriendRequest({"limit": 20});
        },
        child: SingleChildScrollView(
          child: friendRequest.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                      child: Text('Lời mời kết bạn'),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: friendRequest.length,
                      itemBuilder: ((context, index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16.0, bottom: 16.0),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              friendRequest[index]['account']
                                                          ['avatar_media'] !=
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
                                        Text(friendRequest[index]['account']
                                            ['display_name']),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        friendRequest[index]['account']
                                                            ['relationships']
                                                        ['friendship_status'] !=
                                                    'ARE_FRIENDS' &&
                                                friendRequest[index]['account']
                                                            ['relationships']
                                                        ['friendship_status'] !=
                                                    'CAN_REQUEST'
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      '${friendRequest[index]['account']['friends_count'] ?? 0} bạn chung',
                                                      style: const TextStyle(
                                                          color: greyColor)),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          setState(() {
                                                            friendRequest[index]
                                                                            [
                                                                            'account']
                                                                        [
                                                                        'relationships']
                                                                    [
                                                                    'friendship_status'] =
                                                                'ARE_FRIENDS';
                                                          });
                                                          await ref
                                                              .read(
                                                                  friendControllerProvider
                                                                      .notifier)
                                                              .statusFriendRequest(
                                                                  'add',
                                                                  friendRequest[
                                                                          index]
                                                                      [
                                                                      'account']['id']);
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
                                                                  width: 0.2,
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
                                                                      FontWeight
                                                                          .w700,
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
                                                            friendRequest[index]
                                                                            [
                                                                            'account']
                                                                        [
                                                                        'relationships']
                                                                    [
                                                                    'friendship_status'] =
                                                                'CAN_REQUEST';
                                                          });
                                                          await ref
                                                              .read(
                                                                  friendControllerProvider
                                                                      .notifier)
                                                              .statusFriendRequest(
                                                                  'reject',
                                                                  friendRequest[
                                                                          index]
                                                                      [
                                                                      'account']['id']);
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
                                                                  width: 0.2,
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
                                                                      FontWeight
                                                                          .w700,
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
                                                            ['relationships']
                                                        ['friendship_status'] ==
                                                    'ARE_FRIENDS'
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                          'Lời mời đã được chấp nhận',
                                                          style: TextStyle(
                                                              color: greyColor,
                                                              fontSize: 12)),
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
                                                                  width: 0.2,
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
                                                                  size: 16,
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
                                                                      FontWeight
                                                                          .w700,
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
                              friendRequest[index]['account']['relationships']
                                          ['friendship_status'] ==
                                      'CAN_REQUEST'
                                  ? const Padding(
                                      padding: EdgeInsets.only(right: 16.0),
                                      child: Icon(FontAwesomeIcons.ellipsis),
                                    )
                                  : const SizedBox()
                            ],
                          )),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/wow-emo-2.gif",
                        height: 125.0,
                        width: 125.0,
                      ),
                    ),
                    const Text('Bạn hiện không có lời mời kết bạn nào mới'),
                  ],
                ),
        ),
      ),
    );
  }
}
