import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/emoji_modal_bottom.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/text_action.dart';
import 'package:social_network_app_mobile/widget/text_form_field_custom.dart';

class CommentTextfield extends StatefulWidget {
  final Function? handleComment;
  const CommentTextfield({Key? key, this.handleComment}) : super(key: key);

  @override
  State<CommentTextfield> createState() => _CommentTextfieldState();
}

class _CommentTextfieldState extends State<CommentTextfield> {
  bool isShowEmoji = false;
  double heightModal = 250;
  String content = '';
  String linkEmojiSticky = '';
  TextEditingController textController = TextEditingController();
  FocusNode commentNode = FocusNode();

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
        linkEmojiSticky = link;
      });
      commentNode.requestFocus();
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
            linkEmojiSticky.isNotEmpty
                ? Container(
                    margin: const EdgeInsets.only(top: 4, bottom: 4, left: 30),
                    child: Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: ImageCacheRender(
                                height: 70.0, path: linkEmojiSticky)),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  linkEmojiSticky = '';
                                });
                              },
                              child: Container(
                                  width: 14,
                                  height: 14,
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
              const Icon(
                FontAwesomeIcons.camera,
                color: greyColor,
              ),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                  child: TextFormFieldCustom(
                minLines: 1,
                maxLines: 5,
                autofocus: false,
                hintText: "Viết bình luận...",
                textController: textController,
                focusNode: commentNode,
                handleGetValue: (value) => {
                  setState(() {
                    content = value;
                  })
                },
                suffixIcon: InkWell(
                  onTap: () {
                    handleClickIcon();
                  },
                  child: content.isEmpty && linkEmojiSticky.isEmpty
                      ? Icon(
                          FontAwesomeIcons.solidFaceSmile,
                          color: isShowEmoji ? primaryColor : greyColor,
                        )
                      : SizedBox(
                          width: 60,
                          child: Center(
                            child: TextAction(
                              action: () {
                                widget.handleComment!({
                                  "status": content,
                                  "extra_body": linkEmojiSticky.isEmpty
                                      ? null
                                      : {
                                          "description":
                                              linkEmojiSticky.contains('giphy')
                                                  ? 'gif'
                                                  : "sticky",
                                          "link": linkEmojiSticky,
                                          "title": ""
                                        }
                                });
                                textController.clear();
                                setState(() {
                                  content = '';
                                  linkEmojiSticky = '';
                                });
                                hiddenKeyboard(context);
                              },
                              title: "Đăng",
                              fontSize: 15,
                            ),
                          ),
                        ),
                ),
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
