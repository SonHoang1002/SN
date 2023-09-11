import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/friend/friend_provider.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';

import '../../apis/friends_api.dart';
import '../../apis/group_api.dart';
import '../../screens/Group/GroupDetail/group_detail.dart';
import '../../screens/UserPage/user_page.dart';
import '../../theme/colors.dart';

class SuggestItem extends ConsumerWidget {
  final dynamic suggestData;
  final dynamic type;
  final Function? reloadFunction;
  const SuggestItem(
      {required this.suggestData, this.type, this.reloadFunction, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String idJoin = "";
    final size = MediaQuery.sizeOf(context);
    return StatefulBuilder(builder: (context, setState) {
      return InkWell(
        onTap: () {
          type == suggestFriends?Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const UserPageHome(),
                settings: RouteSettings(
                  arguments: {'id': suggestData['id'], "user": suggestData},
                ),
              )): Navigator.push(context, CupertinoPageRoute(
                            builder: (context) {
                              return GroupDetail(
                                id: suggestData['id'],
                              );
                            },
                          ));
        },
        child: Container(
            width: size.width * 0.8,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Flexible(
                    child: ExtendedImage.network(
                  suggestData["avatar_media"]?["url"] ??
                      suggestData["banner"]?["preview_url"] ??
                      linkBannerDefault,
                  height: size.width * 0.75,
                  fit: BoxFit.cover,
                  width: size.width * 0.75,
                )),
                buildSpacer(height: 10),
                buildTextContent(
                    suggestData["display_name"] ?? suggestData["title"] ?? "",
                    true,
                    fontSize: 15,
                    margin: const EdgeInsets.only(left: 10)),
                buildSpacer(height: 10),
                type == suggestFriends
                    ? buildTextContent(
                        suggestData["relationships"]?["mutual_friend_count"] !=
                                null
                            ? "${suggestData["relationships"]?["mutual_friend_count"] ?? 0} bạn chung"
                            : "",
                        false,
                        fontSize: 15,
                        margin: const EdgeInsets.only(left: 10))
                    : const SizedBox(),
                type == suggestGroups
                    ? buildTextContent(
                        "${suggestData['member_count'] ?? 0} thành viên - ${suggestData['average_status'] ?? 0} bài viết/ngày",
                        false,
                        fontSize: 15,
                        margin: const EdgeInsets.only(left: 10))
                    : const SizedBox(),
                buildTextContent(
                    type == suggestGroups &&
                            handleTimeShow(suggestData['last_status_at'])
                                is String
                        ? "Hoạt động gần nhất: ${handleTimeShow(suggestData['last_status_at'])!}"
                        : "",
                    false,
                    fontSize: 15,
                    margin: const EdgeInsets.only(left: 10)),
                buildSpacer(height: 10),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    buildSpacer(width: idJoin == suggestData['id'] ? 3.5 : 10),
                    Flexible(
                        flex: 10,
                        child: ButtonPrimary(
                            colorButton:
                                idJoin == suggestData['id'] ? greyColor : null,
                            label: type == suggestFriends
                                ? idJoin == suggestData['id']
                                    ? "Đã gửi lời mời kết bạn"
                                    : "Thêm bạn bè"
                                : type == suggestGroups
                                    ? idJoin == suggestData['id']
                                        ? "Đã tham gia nhóm"
                                        : "Tham gia nhóm"
                                    : "",
                            icon: idJoin != suggestData['id']
                                ? const Icon(
                                    FontAwesomeIcons.user,
                                    size: 12.5,
                                    color: Colors.white,
                                  )
                                : null,
                            handlePress: () async {
                              if (type == suggestFriends) {
                                setState(() {
                                  idJoin = suggestData['id'];
                                });
                                await FriendsApi()
                                    .sendFriendRequestApi(suggestData['id']);
                                await ref
                                    .read(friendControllerProvider.notifier)
                                    .removeFriendSuggest(suggestData['id']);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      'Đã gửi lời mời kết bạn tới ${suggestData["display_name"]}'),
                                  duration: const Duration(seconds: 2),
                                ));
                              } else {
                                await GroupApi()
                                    .fetchGroupRole(suggestData['id']);

                                setState(() {
                                  idJoin = suggestData['id'];
                                });
                              }
                            })),
                    buildSpacer(width: 5),
                    Flexible(
                        flex: 3,
                        child: ButtonPrimary(
                            label: "Gỡ",
                            colorText: Colors.black,
                            handlePress: () {
                              if (type == suggestFriends) {
                                ref
                                    .read(friendControllerProvider.notifier)
                                    .removeFriendSuggest(suggestData['id']);
                              } else if (type == suggestGroups) {
                                ref
                                    .read(groupListControllerProvider.notifier)
                                    .removeGroupMember(suggestData['id']);
                              }
                              reloadFunction != null ? reloadFunction!() : null;
                            },
                            colorButton: ThemeMode.dark == true
                                ? greyColor
                                : const Color(0xfff1f2f5))),
                    buildSpacer(width: 10),
                  ],
                )
              ],
            )),
      );
    });
  }
}
