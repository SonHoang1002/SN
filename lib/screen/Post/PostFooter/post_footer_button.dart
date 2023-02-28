import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screen/Post/comment_post_modal.dart';
import 'package:social_network_app_mobile/screen/Post/post_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/widget/screen_share.dart';

class PostFooterButton extends StatefulWidget {
  final dynamic post;
  final dynamic type;
  const PostFooterButton({Key? key, this.post, this.type}) : super(key: key);

  @override
  State<PostFooterButton> createState() => _PostFooterButtonState();
}

class _PostFooterButtonState extends State<PostFooterButton>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    List buttonAction = [
      {
        "key": "comment",
        "icon": FontAwesomeIcons.message,
        "label": "Bình luận"
      },
      {"key": "share", "icon": Icons.share, "label": "Chia sẻ"}
    ];

    handlePress(key) {
      if (key == 'comment') {
        if (![postDetail, postMultipleMedia].contains(widget.type)) {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => PostDetail(post: widget.post)));
        } else if (widget.type == postMultipleMedia) {
          Navigator.push(
              context,
              CupertinoModalPopupRoute(
                  builder: ((context) => CommentPostModal(post: widget.post))));
        }
      } else if (key == 'share') {
        showBarModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => ScreenShare(
                entityShare: widget.post,
                type: widget.type,
                entityType: 'post'));
      }
    }

    renderImage(link) {
      return Image.asset(
        link,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(FontAwesomeIcons.faceAngry),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerRight,
            child: ReactionButton(
              onReactionChanged: (value) {
                print(value);
              },
              reactions: <Reaction>[
                Reaction(
                  previewIcon: SizedBox(
                    height: 40,
                    width: 40,
                    child: renderImage('assets/reaction/like.gif'),
                  ),
                  icon: SizedBox(
                    height: 20,
                    width: 20,
                    child: renderImage('assets/reaction/like.png'),
                  ),
                  value: null,
                ),
                Reaction(
                  previewIcon: SizedBox(
                    height: 40,
                    width: 40,
                    child: renderImage('assets/reaction/tym.gif'),
                  ),
                  icon: SizedBox(
                    height: 20,
                    width: 20,
                    child: renderImage('assets/reaction/love.png'),
                  ),
                  value: null,
                ),
                Reaction(
                  previewIcon: SizedBox(
                    height: 40,
                    width: 40,
                    child: renderImage('assets/reaction/hug.gif'),
                  ),
                  icon: SizedBox(
                    height: 20,
                    width: 20,
                    child: renderImage('assets/reaction/yay.png'),
                  ),
                  value: null,
                ),
                Reaction(
                  previewIcon: SizedBox(
                    height: 40,
                    width: 40,
                    child: renderImage('assets/reaction/wow.gif'),
                  ),
                  icon: SizedBox(
                    height: 20,
                    width: 20,
                    child: renderImage('assets/reaction/wow.png'),
                  ),
                  value: null,
                ),
                Reaction(
                  previewIcon: SizedBox(
                    height: 40,
                    width: 40,
                    child: renderImage('assets/reaction/haha.gif'),
                  ),
                  icon: SizedBox(
                    height: 20,
                    width: 20,
                    child: renderImage('assets/reaction/haha.png'),
                  ),
                  value: null,
                ),
                Reaction(
                  previewIcon: SizedBox(
                    height: 40,
                    width: 40,
                    child: renderImage('assets/reaction/cry.gif'),
                  ),
                  icon: SizedBox(
                    height: 20,
                    width: 20,
                    child: renderImage('assets/reaction/sad.png'),
                  ),
                  value: null,
                ),
                Reaction(
                  previewIcon: SizedBox(
                    height: 40,
                    width: 40,
                    child: renderImage('assets/reaction/mad.gif'),
                  ),
                  icon: SizedBox(
                    height: 20,
                    width: 20,
                    child: renderImage('assets/reaction/angry.png'),
                  ),
                  value: null,
                ),
              ],
              initialReaction: Reaction(
                  icon: const Padding(
                    padding:
                        EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                    child: ButtonLayout(
                      button: {
                        "key": "reaction",
                        "icon": FontAwesomeIcons.thumbsUp,
                        "label": "Thích"
                      },
                    ),
                  ),
                  value: const Padding(
                    padding:
                        EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                    child: ButtonLayout(
                      button: {
                        "key": "reaction",
                        "icon": FontAwesomeIcons.thumbsUp,
                        "label": "Thích"
                      },
                    ),
                  )),
            ),
          ),
          ...List.generate(
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
        ],
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
