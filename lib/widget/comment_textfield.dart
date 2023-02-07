import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/friends_api.dart';
import 'package:social_network_app_mobile/apis/media_api.dart';
import 'package:social_network_app_mobile/apis/search_api.dart';
import 'package:social_network_app_mobile/data/me_data.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/PickImageVideo/src/gallery/src/gallery_view.dart';
import 'package:social_network_app_mobile/widget/box_mention.dart';
import 'package:social_network_app_mobile/widget/emoji_modal_bottom.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/mentions/controller/social_text_editing_controller.dart';
import 'package:social_network_app_mobile/widget/mentions/model/detected_type_enum.dart';
import 'package:social_network_app_mobile/widget/mentions/model/social_content_detection_model.dart';
import 'package:social_network_app_mobile/widget/text_action.dart';
import 'package:social_network_app_mobile/widget/text_form_field_custom.dart';

class CommentTextfield extends StatefulWidget {
  final Function? handleComment;
  final FocusNode? commentNode;
  final dynamic commentSelected;
  final Function? getCommentSelected;

  const CommentTextfield(
      {Key? key,
      this.handleComment,
      this.commentNode,
      this.commentSelected,
      this.getCommentSelected})
      : super(key: key);

  @override
  State<CommentTextfield> createState() => _CommentTextfieldState();
}

class _CommentTextfieldState extends State<CommentTextfield> {
  bool isShowEmoji = false;
  bool isComment = false;
  double heightModal = 250;

  String content = '';
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
      List newList =
          await FriendsApi().getListFriendApi(meData['id'], {"limit": 20}) ??
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

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    }

    handleGetComment(value) async {
      setState(() {
        content = value;
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
      if (listMentionsSelected.length > 50) return;

      String message =
          '${textController.text.substring(0, query.range.start)}${(data['display_name'] ?? data['title'])}${textController.text.substring(query.range.end)}';

      textController.text = message;

      setState(() {
        listMentions = [];
        content = message;
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

    handleActionComment() async {
      dynamic dataUploadFile;
      if (files.isNotEmpty) {
        File? fileData = await files[0].file;
        String fileName = fileData!.path.split('/').last;
        FormData formData = FormData.fromMap({
          "file":
              await MultipartFile.fromFile(fileData.path, filename: fileName),
        });

        dataUploadFile = await MediaApi().uploadMediaEmso(formData);
      }

      widget.handleComment!({
        "status": content,
        "media_ids": dataUploadFile != null ? [dataUploadFile['id']] : null,
        "extra_body": linkEmojiSticky.isEmpty
            ? null
            : {
                "description":
                    linkEmojiSticky.contains('giphy') ? 'gif' : "sticky",
                "link": linkEmojiSticky,
                "title": ""
              },
        "tags": listMentionsSelected
            .where((element) => flagContent.contains(element['id']))
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
      });
      textController.clear();
      setState(() {
        files = [];
        content = '';
        isComment = false;
        linkEmojiSticky = '';
        listMentionsSelected = [];
      });
      // ignore: use_build_context_synchronously
      hiddenKeyboard(context);
    }

    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border:
                const Border(top: BorderSide(width: 0.3, color: greyColor))),
        padding: const EdgeInsets.only(
            top: 8.0, left: 8.0, right: 8.0, bottom: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            listMentions.isNotEmpty && content.isNotEmpty
                ? BoxMention(
                    listData: listMentions,
                    getMention: (mention) {
                      handleClickMention(mention);
                    },
                  )
                : const SizedBox(),
            widget.commentSelected != null
                ? Container(
                    margin: const EdgeInsets.only(top: 4, bottom: 4, left: 30),
                    child: RichText(
                        text: TextSpan(
                            text: 'Đang trả lời ',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                                fontSize: 13),
                            children: [
                          TextSpan(
                              text:
                                  '${widget.commentSelected['account']['display_name']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 13)),
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
                ? Container(
                    margin: const EdgeInsets.only(top: 4, bottom: 4, left: 30),
                    child: Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: files.isNotEmpty
                                ? Image.memory(
                                    files[0].pickedThumbData,
                                    fit: BoxFit.cover,
                                    height: 80,
                                    width: 70,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Text(
                                                'Hình ảnh không được hiển thị'),
                                  )
                                : ImageCacheRender(
                                    height: 70.0, path: linkEmojiSticky)),
                        Positioned(
                          top: 0,
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
                    ),
                  )
                : const SizedBox(),
            Row(children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => Expanded(
                              child: GalleryView(
                                  filesSelected: files,
                                  handleGetFiles: handleGetFiles))));
                },
                child: const Icon(
                  FontAwesomeIcons.camera,
                  color: greyColor,
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                  child: TextFormFieldCustom(
                minLines: 1,
                maxLines: 5,
                autofocus: true,
                hintText: "Viết bình luận...",
                textController: textController,
                focusNode: widget.commentNode,
                handleGetValue: (value) => handleGetComment(value),
                suffixIcon: InkWell(
                    onTap: () {
                      handleClickIcon();
                    },
                    child: content.trim().isNotEmpty ||
                            linkEmojiSticky.isNotEmpty ||
                            files.isNotEmpty
                        ? SizedBox(
                            width: 60,
                            child: Center(
                              child: TextAction(
                                action: !isComment
                                    ? () {
                                        setState(() {
                                          isComment = true;
                                        });
                                        handleActionComment();
                                      }
                                    : null,
                                title: "Đăng",
                                fontSize: 15,
                              ),
                            ),
                          )
                        : Icon(
                            FontAwesomeIcons.solidFaceSmile,
                            color: isShowEmoji ? primaryColor : greyColor,
                          )),
              ))
            ]),
            isShowEmoji
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

  Widget contentEmoji(functionGetEmoji) {
    return EmojiModalBottom(
        height: heightModal, functionGetEmoji: functionGetEmoji);
  }
}
