import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/friends_api.dart';
import 'package:social_network_app_mobile/apis/media_api.dart';
import 'package:social_network_app_mobile/apis/search_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/PickImageVideo/src/gallery/src/gallery_view.dart';
import 'package:social_network_app_mobile/widgets/box_mention.dart';
import 'package:social_network_app_mobile/widgets/emoji_modal_bottom.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';
import 'package:social_network_app_mobile/widgets/mentions/controller/social_text_editing_controller.dart';
import 'package:social_network_app_mobile/widgets/mentions/model/detected_type_enum.dart';
import 'package:social_network_app_mobile/widgets/mentions/model/social_content_detection_model.dart';
import 'package:social_network_app_mobile/widgets/text_form_field_custom.dart';

class CommentTextfield extends StatefulHookConsumerWidget {
  final Function? handleComment;
  final FocusNode? commentNode;
  final dynamic commentSelected;
  final Function? getCommentSelected;
  final String? type;
  final bool? autoFocus;
  final bool? isOnBoxComment;

  const CommentTextfield(
      {Key? key,
      this.type,
      this.autoFocus,
      this.handleComment,
      this.commentNode,
      this.commentSelected,
      this.getCommentSelected,
      this.isOnBoxComment = false})
      : super(key: key);

  @override
  ConsumerState<CommentTextfield> createState() => _CommentTextfieldState();
}

class _CommentTextfieldState extends ConsumerState<CommentTextfield> {
  bool isShowEmoji = false;
  bool isComment = false;
  double heightModal = 250;

  String content = '';
  String contentWithId = '';
  String flagContent = '';
  String preMessage = '';

  String linkEmojiSticky = '';
  dynamic query;
  late SocialTextEditingController textController;
  List listMentions = [];
  List listMentionsSelected = [];
  List files = [];

  late StreamSubscription<SocialContentDetection> _streamSubscription;

  @override
  void initState() {
    super.initState();

    textController = SocialTextEditingController()
      ..text = content
      ..setTextStyle(
          DetectedType.mention,
          TextStyle(
              color: secondaryColor, backgroundColor: secondaryColorSelected));

    _streamSubscription = textController.subscribeToDetection(onDetectContent);
  }

  void onDetectContent(SocialContentDetection detection) async {
    if (!detection.text.contains('@')) {
      if (listMentions.isNotEmpty) {
        setState(() {
          listMentions = [];
        });
      }
      return;
    }
    setState(() {
      query = detection;
    });

    if (detection.text.substring(1).isEmpty) {
      List newList = await FriendsApi().getListFriendApi(
              ref.watch(meControllerProvider)[0]['id'], {"limit": 20}) ??
          [];
      setState(() {
        listMentions = newList.length > 5 ? newList.sublist(0, 5) : newList;
      });
    } else {
      var objectMentions = await SearchApi()
          .getListSearchApi({"q": detection.text.substring(1), "limit": 5});
      if (objectMentions != null) {
        setState(() {
          listMentions = objectMentions['accounts'] +
              objectMentions['groups'] +
              objectMentions['pages'];
        });
      }
    }
  }

  handleClickIcon() {
    setState(() {
      isShowEmoji = !isShowEmoji;
    });
  }

  functionGetEmoji(link) {
    setState(() {
      isShowEmoji = false;
      files = [];
      linkEmojiSticky = link;
    });
    widget.commentNode!.requestFocus();
    widget.isOnBoxComment == true ? popToPreviousScreen(context) : null;
  }

  handleGetComment(value) async {
    setState(() {
      content = value;
      contentWithId = value;
    });

    for (var mention in listMentionsSelected) {
      preMessage = textController.text.replaceAll(
          mention['display_name'] ?? mention['title'], '[${mention['id']}]');
    }

    setState(() {
      flagContent = preMessage;
    });
  }

  handleClickMention(data) {
    //Should show notification
    if (listMentionsSelected.length > 30) return;
    String message =
        '${textController.text.substring(0, query.range.start)}${(data['display_name'] ?? data['title'])}${textController.text.substring(query.range.end)}';
    textController.text = message;
    String messageWithId =
        '${textController.text.substring(0, query.range.start)}${data['id']}${textController.text.substring(query.range.end)}';

    if (textController.text.isNotEmpty) {
      final selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length));
      textController.selection = selection;
    }
    setState(() {
      listMentions = [];
      content = message;
      contentWithId = messageWithId;
    });
    setState(() {
      listMentionsSelected = [...listMentionsSelected, data];
    });
  }

  handleGetFiles(file) async {
    if (file.isEmpty) return;

    if (file[0].pickedThumbData == null) {
      Uint8List bytes = await file[0].thumbnailData;
      file[0] = file[0].copyWith(pickedThumbData: bytes);
    }
    setState(() {
      files = file;
      isShowEmoji = false;
      linkEmojiSticky = '';
    });
  }

  checkHasMention(data) {
    if (data == null) return false;
    if (data['typeStatus'] == 'editComment') return false;

    return true;
  }

  handleActionComment() async {
    dynamic dataUploadFile;
    if (files.isNotEmpty && files[0]['id'] == null) {
      File? fileData = await files[0].file;
      String fileName = fileData!.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(fileData.path, filename: fileName),
      });

      dataUploadFile = await MediaApi().uploadMediaEmso(formData);
    }
    widget.handleComment!({
      "id": widget.commentSelected != null &&
              ['editComment', 'editChild']
                  .contains(widget.commentSelected['typeStatus'])
          ? widget.commentSelected['id']
          : '111111111111',
      "status": checkHasMention(widget.commentSelected)
          ? '[${widget.commentSelected['account']['id']}] $content'
          : content,
      // "contentWithId": contentWithId,
      "media_ids": dataUploadFile != null ? [dataUploadFile['id']] : [],
      "extra_body": linkEmojiSticky.isEmpty
          ? null
          : {
              "description":
                  linkEmojiSticky.contains('giphy') ? 'gif' : "sticky",
              "link": linkEmojiSticky,
              "title": ""
            },
      "tags": (checkHasMention(widget.commentSelected)
              ? [...listMentionsSelected, widget.commentSelected['account']]
              : listMentionsSelected)
          // .where((element) => flagContent.contains(element['id']))
          .map((e) => {
                "entity_id": e['id'],
                "entity_type": e['username'] != null
                    ? 'Account'
                    : e['page_relationship'] != null
                        ? 'Page'
                        : 'Group',
                "name": e['display_name'] ?? e['title']
              })
          .toList(),
      "in_reply_to_id": widget.commentSelected != null
          ? widget.commentSelected['in_reply_to_parent_id'] != null
              ? widget.commentSelected['in_reply_to_id']
              : widget.commentSelected['id']
          : null,
      "type": widget.commentSelected != null &&
              widget.commentSelected['typeStatus'] != 'editComment'
          ? "child"
          : 'parent',
      "typeStatus": widget.commentSelected?['typeStatus'],
    }, textController.text.trim());
    textController.clear();
    setState(() {
      files = [];
      content = '';
      isComment = false;
      linkEmojiSticky = '';
      listMentionsSelected = [];
    });
    widget.getCommentSelected != null ? widget.getCommentSelected!(null) : null;
    // ignore: use_build_context_synchronously
    hiddenKeyboard(context);
  }

  checkVisibleSubmit() {
    if (textController.text.trim().isNotEmpty) return true;
    if (linkEmojiSticky.isNotEmpty) return true;
    if (files.isNotEmpty) return true;
    return false;
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        if (widget.commentSelected != null &&
            ['editComment', 'editChild']
                .contains(widget.commentSelected['typeStatus'])) {
          String contentUpdate = widget.commentSelected['content'];

          textController.text =
              widget.commentSelected['typeStatus'] == 'editChild' &&
                      contentUpdate.length >= 21
                  ? contentUpdate.substring(21)
                  : contentUpdate;
          textController.selection = TextSelection.collapsed(
              offset: widget.commentSelected['typeStatus'] == 'editChild' &&
                      contentUpdate.length >= 21
                  ? contentUpdate.substring(21).length
                  : contentUpdate.length);
          setState(() {
            content = contentUpdate;
          });
          dynamic card = widget.commentSelected['card'];
          dynamic medias = widget.commentSelected['media_attachments'] ?? [];

          if (card != null && card['link'] != null) {
            setState(() {
              linkEmojiSticky = card['link'];
            });
          }

          if (medias.isNotEmpty) {
            setState(() {
              files = medias;
            });
          }
        } else {
          textController.text = '';
          setState(() {
            linkEmojiSticky = '';
            files = [];
          });
        }
        return null;
      },
      [widget.commentSelected?['id']],
    );

    return Container(
        decoration: !widget.isOnBoxComment!
            ? BoxDecoration(
                color: widget.type == postWatch
                    ? Colors.grey.shade900
                    : widget.type == postWatchDetail
                        ? Colors.transparent
                        : Theme.of(context).scaffoldBackgroundColor,
                // border: Border(
                //     top: BorderSide(
                //         width: 0.3,
                //         color: widget.type == postWatchDetail
                //             ? Colors.transparent
                //             : greyColor)
                // )
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !widget.isOnBoxComment! && widget.type != postWatchDetail
                ? buildDivider(color: greyColor, bottom: 10)
                : const SizedBox(),
            listMentions.isNotEmpty && content.isNotEmpty
                ? BoxMention(
                    listData: listMentions,
                    getMention: (mention) {
                      handleClickMention(mention);
                    },
                  )
                : const SizedBox(),
            widget.commentSelected != null &&
                    widget.commentSelected['typeStatus'] != 'editComment'
                ? Container(
                    margin: const EdgeInsets.only(top: 4, bottom: 4, left: 30),
                    child: RichText(
                        text: TextSpan(
                            text: 'Đang trả lời ',
                            style: TextStyle(
                              color: widget.type == postWatchDetail
                                  ? white
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                              fontSize: 13,
                            ),
                            children: [
                          TextSpan(
                              text:
                                  '${widget.commentSelected['account']['display_name']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: widget.type == postWatchDetail
                                      ? secondaryColor
                                      : null)),
                          TextSpan(
                              text: '  Hủy',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  widget.getCommentSelected!(null);
                                },
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: primaryColor))
                        ])),
                  )
                : const SizedBox(),
            (linkEmojiSticky.isNotEmpty || files.isNotEmpty)
                ? Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 25),
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 4, bottom: 4, left: 30),
                          decoration: BoxDecoration(
                              border: Border.all(color: greyColor, width: 0.2),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: files.isNotEmpty
                                  ? files[0]['id'] != null
                                      ? ImageCacheRender(
                                          path: files[0]['preview_url'],
                                          height: 85.0,
                                          width: 85.0,
                                        )
                                      : Image.memory(
                                          files[0].pickedThumbData,
                                          fit: BoxFit.cover,
                                          height: 85.0,
                                          width: 85.0,
                                          errorBuilder: (context, error,
                                                  stackTrace) =>
                                              const Text(
                                                  'Hình ảnh không được hiển thị'),
                                        )
                                  : ImageCacheRender(
                                      height: 85.0,
                                      width: 85.0,
                                      path: linkEmojiSticky)),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 0,
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                files = [];
                                linkEmojiSticky = '';
                              });
                            },
                            child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.5),
                                    shape: BoxShape.circle),
                                child: const Icon(
                                  FontAwesomeIcons.xmark,
                                  size: 10,
                                  color: white,
                                ))),
                      )
                    ],
                  )
                : const SizedBox(),
            Container(
              margin: !widget.isOnBoxComment!
                  ? const EdgeInsets.symmetric(horizontal: 10)
                  : null,
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                if (widget.type != postWatchDetail && !widget.isOnBoxComment!)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => GalleryView(
                                  filesSelected: files,
                                  handleGetFiles: handleGetFiles)));
                    },
                    child: const Icon(
                      FontAwesomeIcons.camera,
                      color: secondaryColor,
                      size: 20,
                    ),
                  ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                    child: TextFormFieldCustom(
                  type: widget.type,
                  isDense: true,
                  minLines: 1,
                  maxLines: 5,
                  autofocus: widget.autoFocus ?? true,
                  hintText: "Viết bình luận...",
                  textController: textController,
                  focusNode: widget.commentNode,
                  handleGetValue: (value) => handleGetComment(value),
                  suffixIcon: InkWell(
                      onTap: () {
                        handleClickIcon();
                        widget.isOnBoxComment == true
                            ? handleShowEmojiBottomSheet(functionGetEmoji)
                            : null;
                      },
                      child: Icon(
                        FontAwesomeIcons.solidFaceSmile,
                        size: 20,
                        color: isShowEmoji ? secondaryColor : greyColor,
                      )),
                )),
                const SizedBox(
                  width: 8.0,
                ),
                checkVisibleSubmit()
                    ? GestureDetector(
                        onTap: !isComment
                            ? () {
                                setState(() {
                                  isComment = true;
                                });
                                handleActionComment();
                              }
                            : null,
                        child: Transform.rotate(
                          angle: pi / 4,
                          child: const Icon(
                            CupertinoIcons.paperplane_fill,
                            color: secondaryColor,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.commentSelected != null
                    ? Row(
                        children: [
                          const SizedBox(
                            width: 8.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.getCommentSelected!(null);
                            },
                            child: const Icon(
                              FontAwesomeIcons.xmark,
                              color: secondaryColor,
                              size: 20,
                            ),
                          )
                        ],
                      )
                    : const SizedBox()
              ]),
            ),
            isShowEmoji && widget.isOnBoxComment == false
                ? DraggableBottomSheet(
                    minExtent: 250,
                    useSafeArea: false,
                    curve: Curves.easeIn,
                    previewWidget: contentEmoji(functionGetEmoji),
                    expandedWidget: contentEmoji(functionGetEmoji),
                    backgroundWidget: const SizedBox(),
                    maxExtent: MediaQuery.of(context).size.height * 0.8,
                    onDragging: (pos) {
                      setState(() {
                        heightModal = pos;
                      });
                    },
                  )
                : const SizedBox(),
          ],
        ));
  }

  handleShowEmojiBottomSheet(Function functionGetEmoji) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return EmojiModalBottom(
            type: widget.type,
            height: heightModal,
            functionGetEmoji: functionGetEmoji);
      },
    );
  }

  Widget contentEmoji(functionGetEmoji) {
    return EmojiModalBottom(
        type: widget.type,
        height: heightModal,
        functionGetEmoji: functionGetEmoji);
  }
}
