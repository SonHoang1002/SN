import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/screens/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screens/Post/PageReference/page_mention.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';
import 'package:social_network_app_mobile/widgets/page_visibility.dart';

class CreateFeedStatusHeader extends ConsumerStatefulWidget {
  final dynamic statusActivity;
  final String? description;
  final List? friendSelected;
  final dynamic visibility;
  final Function? handleUpdateData;
  final dynamic entity;
  final dynamic sharePostFriend;

  const CreateFeedStatusHeader(
      {Key? key,
      this.statusActivity,
      this.description,
      this.friendSelected,
      this.visibility,
      this.handleUpdateData,
      this.entity,
      this.sharePostFriend})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateFeedStatusHeaderState createState() => _CreateFeedStatusHeaderState();
}

class _CreateFeedStatusHeaderState
    extends ConsumerState<CreateFeedStatusHeader> {
  renderLinkAvatar(meData) {
    if (widget.entity != null && widget.entity['entityType'] == 'page') {
      return widget.entity['avatar_media'] != null
          ? widget.entity['avatar_media']['preview_url']
          : linkAvatarDefault;
    } else {
      return meData?['avatar_media']?['preview_url'] ?? linkAvatarDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    var meData = ref.watch(meControllerProvider)[0];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AvatarSocial(
          width: 38,
          height: 38,
          path: renderLinkAvatar(meData),
          object: widget.entity,
        ),
        const SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width - 80,
              child: RichText(
                text: TextSpan(
                    text: widget.entity != null &&
                            widget.entity['entityType'] == 'page'
                        ? widget.entity['title']
                        : meData?['display_name'] ?? meData?['name'] ?? '--',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        // overflow: TextOverflow.ellipsis,
                        color: Theme.of(context).textTheme.bodyLarge!.color),
                    children: [
                      const TextSpan(text: ' '),
                      widget.statusActivity != null
                          ? WidgetSpan(
                              child: ImageCacheRender(
                                path: widget.statusActivity['url'],
                                width: 18.0,
                                height: 18.0,
                              ),
                            )
                          : const TextSpan(text: ''),
                      TextSpan(
                          text: widget.description,
                          style:
                              const TextStyle(fontWeight: FontWeight.normal)),
                      widget.friendSelected!.isNotEmpty
                          ? TextSpan(
                              text: widget.friendSelected![0]
                                      ?['display_name'] ??
                                  "--")
                          : const TextSpan(),
                      // widget.sharePostFriend != null &&
                      //         widget.sharePostFriend['id'] != meData['id']
                      //     ? TextSpan(children: [
                      //         const WidgetSpan(child: Text(" đến ")),
                      //         WidgetSpan(
                      //             child: Text(
                      //           widget.sharePostFriend['display_name'] ?? "",
                      //           style: const TextStyle(
                      //             fontSize: 14,
                      //             fontWeight: FontWeight.w700,
                      //           ),
                      //         ))
                      //       ])
                      //     : const WidgetSpan(child: SizedBox()),
                      widget.friendSelected!.isNotEmpty &&
                              widget.friendSelected!.length >= 2
                          ? const TextSpan(
                              text: ' và ',
                              style: TextStyle(fontWeight: FontWeight.normal))
                          : const TextSpan(),
                      widget.friendSelected!.isNotEmpty &&
                              widget.friendSelected!.length == 2
                          ? TextSpan(
                              text: widget.friendSelected![1]['display_name'],
                            )
                          : const TextSpan(),
                      widget.friendSelected!.isNotEmpty &&
                              widget.friendSelected!.length > 2
                          ? TextSpan(
                              text:
                                  '${widget.friendSelected!.length - 1} người khác',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => PageMention(
                                              mentions: widget.friendSelected ??
                                                  [])));
                                })
                          : const TextSpan(),
                    ]),
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Row(
              children: [
                (widget.entity != null &&
                            widget.entity['entityType'] == 'group') ||
                        (widget.sharePostFriend != null &&
                            widget.sharePostFriend['id'] != meData['id'])
                    ? Container(
                        padding: const EdgeInsets.all(4.0),
                        margin: const EdgeInsets.only(right: 8.0),
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.2, color: greyColor),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              FontAwesomeIcons.userGroup,
                              size: 14,
                              color: greyColor,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 3),
                              child: Text(
                                (widget.entity?['title']) ??
                                    (widget.sharePostFriend?['display_name']) ??
                                    "",
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 12,
                                    color: greyColor),
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => CreateModalBaseMenu(
                                title: "Quyền riêng tư",
                                body: PageVisibility(
                                    visibility: widget.visibility,
                                    handleUpdate: (data) {
                                      widget.handleUpdateData!(
                                          'update_visibility', data);
                                    }),
                                buttonAppbar: const SizedBox())));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.2, color: greyColor),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          widget.visibility['icon'],
                          size: 14,
                          color: greyColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.visibility['label'],
                          style:
                              const TextStyle(fontSize: 12, color: greyColor),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
