import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get_time_ago/get_time_ago.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screens/Post/post_header_action.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';

class PostSuggest extends ConsumerStatefulWidget {
  final dynamic post;
  final dynamic type;
  final Function? renderFunction;
  final Function? updateDataFunction;
  const PostSuggest(
      {Key? key,
      this.post,
      this.type,
      this.renderFunction,
      this.updateDataFunction})
      : super(key: key);

  @override
  ConsumerState<PostSuggest> createState() => _PostSuggestState();
}

class _PostSuggestState extends ConsumerState<PostSuggest> {
  dynamic meData;
  bool isShow = false;

  @override
  void initState() {
    GetTimeAgo.setDefaultLocale('vi');
    meData = ref.read(meControllerProvider)[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget suggestContent = _buildSuggestContent();
    return isShow && widget.post['account']['id'] != meData['id']
        ? Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: suggestContent),
                    buildSpacer(width: 5),
                    _buildSuggestActions()
                  ],
                ),
              ),
              buildDivider(color: greyColor, bottom: 10),
            ],
          )
        : const SizedBox();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildSuggestContent() {
    dynamic content = '';
    const bold = TextStyle(fontWeight: FontWeight.bold);
    List<TextSpan> listContent = [];
    if ((((widget.post?['page'] == null && widget.post?['group'] == null) ||
                widget.post?['page']?["page_relationship"]?["following"] ==
                        false &&
                    widget.post?['page']?["page_relationship"]?["role"] !=
                        "admin") ||
            (widget.post?['group']?["group_relationship"]?["member"] == false &&
                widget.post?['group']?["group_relationship"]?["admin"] ==
                    false)) &&
        widget.type == feedPost) {
      content = 'Gợi ý cho bạn';
      listContent = [(const TextSpan(text: "Gợi ý cho bạn"))];
    } else if (widget.post?["album"] != null &&
        widget.post?["album"]["category"] != 'avatar' &&
        widget.post?["album"]["category"] != 'banner') {
      content = "Album ${widget.post?["album"]["title"]}";
      listContent = [
        const TextSpan(text: "Album  "),
        TextSpan(text: widget.post?["album"]["title"], style: bold)
      ];
    } else if (widget.post?["replies"] != null &&
        widget.post?["replies"].length != 0 &&
        widget.post?["replies"]
                .firstWhere((e) => e["suggested_by"] == 'friend') !=
            null) {
      if (widget.post?["replies"][0]?['page_owner'] != null) {
        content = widget.post?["replies"][0]?["page_owner"]?["title"] +
            " đã bình luận ";
        listContent = [
          TextSpan(
              text: widget.post?["replies"][0]?["page_owner"]?["title"],
              style: bold),
          const TextSpan(text: " đã bình luận ")
        ];
      } else {
        content = widget.post?["replies"][0]?["account"]["display_name"] +
            " đã bình luận ";
        listContent = [
          TextSpan(
              text: widget.post?["replies"][0]?["account"]["display_name"],
              style: bold),
          const TextSpan(text: " đã bình luận ")
        ];
      }
    } else if (widget.type == feedPost && widget.post != null) {
      if (meData['id'] != widget.post?["account"]["id"] &&
          widget.post?["reblog"]?["post_type"] == 'watch') {
        content =
            widget.post?['account']['display_name'] + " đã chia sẻ 1 Video ";
        listContent = [
          TextSpan(text: widget.post?['account']['display_name'], style: bold),
          const TextSpan(text: " đã chia sẻ 1 Video ")
        ];
      }

      if (meData['id'] != widget.post?["account"]["id"] &&
          widget.post?["post_type"] != 'watch' &&
          widget.post?["post_type"] != 'moment' &&
          widget.post?['media_attachments'].length > 0) {
        if (widget.post?['page'] != null) {
          content = widget.post?['page']?['title'];
          listContent = [
            (TextSpan(text: widget.post?['page']?['title'], style: bold))
          ];
        } else {
          content = widget.post?['account']['display_name'];
          listContent = [
            (TextSpan(
                text: widget.post?['account']['display_name'], style: bold))
          ];
        }
        dynamic _checkVideoImage =
            checkVideoImage(widget.post?['media_attachments']);
        if ((_checkVideoImage["video"] != null &&
                _checkVideoImage["video"] != 0) &&
            (_checkVideoImage["image"] != null &&
                _checkVideoImage["image"] != 0)) {
          content +=
              " đã thêm ${_checkVideoImage['image']} ảnh và ${_checkVideoImage['video']} video mới";
          listContent.addAll([
            const TextSpan(
              text: ' đã thêm ',
            ),
            TextSpan(text: '${_checkVideoImage['image']}', style: bold),
            const TextSpan(
              text: ' ảnh và ',
            ),
            TextSpan(text: '${_checkVideoImage['video']}', style: bold),
            const TextSpan(
              text: ' video mới',
            )
          ]);
        } else if (_checkVideoImage["image"] != null &&
            _checkVideoImage["image"] != 0) {
          content += " đã thêm ${_checkVideoImage['image']} ảnh mới";
          listContent.addAll([
            const TextSpan(
              text: ' đã thêm ',
            ),
            TextSpan(text: '${_checkVideoImage['image']}', style: bold),
            const TextSpan(
              text: ' ảnh mới',
            ),
          ]);
        } else if (_checkVideoImage["video"] != null &&
            _checkVideoImage["video"] != 0) {
          content += " đã thêm ${_checkVideoImage['video']} video mới";
          listContent.addAll([
            const TextSpan(
              text: ' đã thêm ',
            ),
            TextSpan(text: '${_checkVideoImage['video']}', style: bold),
            const TextSpan(
              text: ' video mới',
            ),
          ]);
        }
        if (widget.post?['group'] != null) {
          content += " trong nhóm ${widget.post?['group']?['title']}";
          listContent.addAll([
            const TextSpan(
              text: ' trong nhóm ',
            ),
            TextSpan(text: '${widget.post?['group']?['title']}.', style: bold),
          ]);
        }
      }

      if (meData['id'] != widget.post?['account']['id'] &&
          widget.post?['reblog'] != null &&
          widget.post?['reblog']?['post_type'] != 'watch') {
        content = widget.post?["account"]["display_name"] +
            " đã chia sẻ bài viết của ";
        listContent = [
          TextSpan(text: widget.post?["account"]["display_name"], style: bold),
          const TextSpan(
            text: ' đã chia sẻ bài viết của ',
          )
        ];
        if (widget.post?['reblog']['group'] != null) {
          content += " nhóm ";
          listContent.add(const TextSpan(
            text: ' nhóm ',
          ));
        }
        if (widget.post?['reblog']['account']['id'] ==
            widget.post?['account']['id']) {
          content += renderTitleShare();
          listContent.add(TextSpan(
            text: renderTitleShare(),
          ));
        } else {
          if (widget.post?['reblog']?['group'] != null) {
            content += widget.post?['reblog']?['group']['title'];
            listContent.add(TextSpan(
                text: widget.post?['reblog']?['group']['title'], style: bold));
          } else {
            if (widget.post?['reblog']?['page'] != null) {
              content += widget.post?['reblog']?['page']['title'];
              listContent.add(TextSpan(
                  text: widget.post?['reblog']?['page']['title'], style: bold));
            } else {
              content += widget.post?['reblog']['account']['display_name'];
              listContent.add(TextSpan(
                  text: widget.post?['reblog']['account']['display_name'],
                  style: bold));
            }
          }
        }
      }
      if (meData['id'] != widget.post?['account']['id'] &&
          widget.post?['post_type'] == 'target') {
        content = (widget.post?['page'] != null
            ? widget.post?['page']?['title']
            : (widget.post?['account']['display_name']) +
                (widget.post?['status_target']?['target_status'] == 'completed'
                    ? ' đã hoàn thành một mục tiêu'
                    : ' đã công bố mục tiêu mới') +
                (widget.post?['group'] != null
                    ? " trong nhóm ${widget.post?['group']?['title']}"
                    : ''));

        if (widget.post?['page'] != null) {
          listContent = [
            TextSpan(text: widget.post?['page']?['title'], style: bold)
          ];
        } else {
          listContent = [
            TextSpan(
                text: (widget.post?['account']['display_name']), style: bold)
          ];
        }
        if (widget.post?['status_target']?['target_status'] == 'completed') {
          listContent.add(const TextSpan(
            text: ' đã hoàn thành một mục tiêu',
          ));
        } else {
          listContent.add(const TextSpan(
            text: ' đã công bố mục tiêu mới',
          ));
        }
        if (widget.post?['group'] != null) {
          listContent.addAll([
            const TextSpan(
              text: ' trong nhóm',
            ),
            TextSpan(
              text: '${widget.post?['group']?['title']}',
            )
          ]);
        }
      }
    }

    Widget result = RichText(
        text: TextSpan(
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
            children: listContent.map((e) => e).toList()));
    if (listContent.isNotEmpty) {
      setState(() {
        isShow = true;
      });
    } else {
      widget.renderFunction != null ? widget.renderFunction!() : null;
    }
    return result;
  }

  String renderTitleShare() {
    if (widget.post['account']['gender'] == 'male') {
      return 'anh ấy';
    } else if (widget.post['account']['gender'] == 'female') {
      return 'cô ấy';
    } else {
      return 'mình';
    }
  }

  dynamic checkVideoImage(List<dynamic> data) {
    int imageLength = data.map((e) => e["type"] == "image").toList().length;
    int videoLength = data.map((e) => e["type"] == "video").toList().length;
    return {
      "image": imageLength,
      // "video": data.map((e) => e["type"] == "video").toList().length,
      "video": data.length - imageLength,
    };
  }

  Widget _buildSuggestActions() {
    return (![postReblog, postMultipleMedia].contains(widget.type))
        ? Row(
            children: [
              InkWell(
                onTap: () {
                  showBarModalBottomSheet(
                      context: context,
                      backgroundColor: Theme.of(context).canvasColor,
                      barrierColor: Colors.transparent,
                      builder: (context) => PostHeaderAction(
                          post: widget.post, type: widget.type));
                },
                child: const Icon(
                  FontAwesomeIcons.ellipsis,
                  size: 20,
                  color: greyColor,
                ),
              ),
              SizedBox(
                width: widget.type != postDetail ? 10 : 0,
              ),
              ![postDetail, postPageUser].contains(widget.type)
                  ? InkWell(
                      onTap: () async {
                        final data = {"hidden": true};
                        await PostApi().updatePost(widget.post?['id'], data);
                        ref
                            .read(postControllerProvider.notifier)
                            .actionHiddenDeletePost(widget.type, widget.post);
                      },
                      child: const Icon(
                        FontAwesomeIcons.xmark,
                        size: 20,
                        color: greyColor,
                      ),
                    )
                  : const SizedBox()
            ],
          )
        : const SizedBox();
  }
}
