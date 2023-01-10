import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/emoji_modal_bottom.dart';
import 'package:social_network_app_mobile/widget/text_form_field_custom.dart';

class CommentTextfield extends StatefulWidget {
  const CommentTextfield({Key? key}) : super(key: key);

  @override
  State<CommentTextfield> createState() => _CommentTextfieldState();
}

class _CommentTextfieldState extends State<CommentTextfield> {
  bool isShowEmoji = false;
  double heightModal = 250;

  @override
  Widget build(BuildContext context) {
    handleClickIcon() {
      setState(() {
        isShowEmoji = !isShowEmoji;
      });
    }

    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border:
                const Border(top: BorderSide(width: 0.3, color: greyColor))),
        padding: const EdgeInsets.only(
            top: 8.0, left: 8.0, right: 8.0, bottom: 15.0),
        child: Column(
          children: [
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
                suffixIcon: InkWell(
                  onTap: () {
                    handleClickIcon();
                  },
                  child: Icon(
                    FontAwesomeIcons.solidFaceSmile,
                    color: isShowEmoji ? primaryColor : greyColor,
                  ),
                ),
              ))
            ]),
            isShowEmoji
                ? DraggableBottomSheet(
                    minExtent: 250,
                    useSafeArea: false,
                    curve: Curves.easeIn,
                    previewWidget: contentEmoji(),
                    expandedWidget: contentEmoji(),
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

  Widget contentEmoji() {
    return EmojiModalBottom(height: heightModal);
  }
}
