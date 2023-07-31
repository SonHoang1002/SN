import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/friend/friend_provider.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';

class SuggestItem extends ConsumerWidget {
  final dynamic suggestData;
  final dynamic type;
  final Function? reloadFunction;
  const SuggestItem(
      {required this.suggestData, this.type, this.reloadFunction, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: () {
        // pushCustomCupertinoPageRoute(context, const Moment());
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
                  buildSpacer(width: 10),
                  Flexible(
                      flex: 8,
                      child: ButtonPrimary(
                        label: type == suggestFriends
                            ? "Thêm bạn bè"
                            : type == suggestGroups
                                ? "Tham gia"
                                : "",
                        icon: const Icon(
                          FontAwesomeIcons.user,
                          size: 14,
                        ),
                        handlePress: () {},
                      )),
                  buildSpacer(width: 5),
                  Flexible(
                      flex: 3,
                      child: ButtonPrimary(
                        label: "Gỡ",
                        colorText: Theme.of(context).textTheme.bodyLarge!.color,
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
                        colorButton: Theme.of(context).canvasColor,
                      )),
                  buildSpacer(width: 10),
                ],
              )
            ],
          )),
    );
  }
}
