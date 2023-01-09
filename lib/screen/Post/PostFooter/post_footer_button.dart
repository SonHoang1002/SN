import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/screen/Post/post_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class PostFooterButton extends StatelessWidget {
  final dynamic post;
  const PostFooterButton({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List buttonAction = [
      {"key": "reaction", "icon": FontAwesomeIcons.thumbsUp, "label": "Thích"},
      {
        "key": "comment",
        "icon": FontAwesomeIcons.message,
        "label": "Bình luận"
      },
      {"key": "share", "icon": Icons.share, "label": "Chia sẻ"}
    ];

    handlePress(key) {
      if (key == 'comment') {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => PostDetail(post: post)));
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
            buttonAction.length,
            (index) => InkWell(
                  onTap: () {
                    handlePress(buttonAction[index]['key']);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 4, bottom: 4),
                    child: ButtonLayout(button: buttonAction[index]),
                  ),
                )),
      ),
    );
  }
}

class ButtonLayout extends StatelessWidget {
  final dynamic button;
  const ButtonLayout({
    super.key,
    this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          button['icon'],
          size: 18,
          color: greyColor,
        ),
        const SizedBox(
          width: 3,
        ),
        Text(
          button['label'],
          style: const TextStyle(
              fontWeight: FontWeight.w500, color: greyColor, fontSize: 12),
        )
      ],
    );
  }
}
