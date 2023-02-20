import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/data/me_data.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/Post/PageReference/page_mention.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/page_visibility.dart';

class CreateFeedStatusHeader extends StatefulWidget {
  final dynamic statusActivity;
  final String? description;
  final List? friendSelected;
  final dynamic visibility;
  final Function? handleUpdateData;
  final dynamic entity;

  const CreateFeedStatusHeader(
      {Key? key,
      this.statusActivity,
      this.description,
      this.friendSelected,
      this.visibility,
      this.handleUpdateData,
      this.entity})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateFeedStatusHeaderState createState() => _CreateFeedStatusHeaderState();
}

class _CreateFeedStatusHeaderState extends State<CreateFeedStatusHeader> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    renderLinkAvatar() {
      if (widget.entity != null && widget.entity['entityType'] == 'page') {
        return widget.entity['avatar_media'] != null
            ? widget.entity['avatar_media']['preview_url']
            : linkAvatarDefault;
      } else {
        return meData['avatar_media']['preview_url'] ?? linkAvatarDefault;
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AvatarSocial(width: 38, height: 38, path: renderLinkAvatar()),
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
                        : meData['display_name'],
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
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
                              text: widget.friendSelected![0]['display_name'])
                          : const TextSpan(),
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
                widget.entity != null && widget.entity['entityType'] == 'group'
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
                              width: 5,
                            ),
                            SizedBox(
                              width: 80,
                              child: Text(
                                widget.entity['title'],
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
                        MaterialPageRoute(
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
