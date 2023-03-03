import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screen/Post/comment_post_modal.dart';
import 'package:social_network_app_mobile/screen/Post/post_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/widget/Reaction/flutter_reaction_button.dart';
import 'package:social_network_app_mobile/widget/screen_share.dart';

class PostFooterButton extends ConsumerStatefulWidget {
  final dynamic post;
  final dynamic type;
  const PostFooterButton({Key? key, this.post, this.type}) : super(key: key);

  @override
  ConsumerState<PostFooterButton> createState() => _PostFooterButtonState();
}

class _PostFooterButtonState extends ConsumerState<PostFooterButton>
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
    String viewerReaction = widget.post['viewer_reaction'] ?? '';

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

    renderImage(link, type) {
      double size = type == 'gif' ? 40 : 20;
      return Image.asset(
        link,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(FontAwesomeIcons.faceAngry),
      );
    }

    renderText(key) {
      String text = 'Thích';
      if (key == 'like') {
        text = 'Thích';
      } else if (key == 'love') {
        text = 'Yêu thích';
      } else if (key == 'yay') {
        text = 'Tự hào';
      } else if (key == 'wow') {
        text = 'Wow';
      } else if (key == 'haha') {
        text = 'Haha';
      } else if (key == 'sad') {
        text = 'Buồn';
      } else {
        text = 'Phẫn nộ';
      }

      return Text(
        ' $text',
        style: TextStyle(
            fontWeight: FontWeight.w500,
            color: key == 'like'
                ? secondaryColor
                : key == 'love'
                    ? Colors.red
                    : primaryColor,
            fontSize: 12),
      );
    }

    renderGif(type, key, {double size = 40}) {
      return Row(
        children: [
          renderImage('assets/reaction/$key.$type', type),
          type == 'png' ? renderText(key) : const SizedBox()
        ],
      );
    }

    handleReaction(react) async {
      var newPost = widget.post;
      List newFavourites = newPost['reactions'];

      int index = newPost['reactions']
          .indexWhere((element) => element['type'] == react);
      int indexCurrent = viewerReaction.isNotEmpty && react != viewerReaction
          ? newPost['reactions']
              .indexWhere((element) => element['type'] == viewerReaction)
          : -1;

      if (index >= 0) {
        newFavourites[index] = {
          "type": react,
          "${react}s_count": newFavourites[index]['${react}s_count'] + 1
        };
      }

      if (indexCurrent >= 0) {
        newFavourites[indexCurrent] = {
          "type": viewerReaction,
          "${viewerReaction}s_count":
              newFavourites[indexCurrent]["${viewerReaction}s_count"] - 1
        };
      }

      if (react != null) {
        dynamic data = {"custom_vote_type": react};
        newPost = {
          ...newPost,
          "favourites_count": newPost['viewer_reaction'] != null
              ? newPost['favourites_count']
              : newPost['favourites_count'] + 1,
          "viewer_reaction": react,
          "reactions": newFavourites
        };

        ref
            .read(postControllerProvider.notifier)
            .actionUpdateDetailInPost(widget.type, newPost);

        await PostApi().reactionPostApi(widget.post['id'], data);
      } else {
        newPost = {
          ...newPost,
          "favourites_count": newPost['favourites_count'] != null
              ? newPost['favourites_count'] - 1
              : newPost['favourites_count'],
          "viewer_reaction": null,
          "reactions": newFavourites
        };

        ref
            .read(postControllerProvider.notifier)
            .actionUpdateDetailInPost(widget.type, newPost);

        await PostApi().unReactionPostApi(widget.post['id']);
      }
    }

    handlePressButton() {
      if (viewerReaction.isNotEmpty) {
        handleReaction(null);
      } else {
        handleReaction('like');
      }
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
                handleReaction(value);
              },
              handlePressButton: handlePressButton,
              reactions: <Reaction>[
                Reaction(
                  previewIcon: renderGif('gif', 'like'),
                  icon: renderGif('png', 'like', size: 20),
                  value: 'like',
                ),
                Reaction(
                  previewIcon: renderGif('gif', 'tym'),
                  icon: renderGif('png', 'love', size: 20),
                  value: 'love',
                ),
                Reaction(
                  previewIcon: renderGif('gif', 'hug'),
                  icon: renderGif('png', 'yay', size: 20),
                  value: 'yay',
                ),
                Reaction(
                  previewIcon: renderGif('gif', 'wow'),
                  icon: renderGif('png', 'wow', size: 20),
                  value: 'wow',
                ),
                Reaction(
                  previewIcon: renderGif('gif', 'haha'),
                  icon: renderGif('png', 'haha', size: 20),
                  value: 'haha',
                ),
                Reaction(
                  previewIcon: renderGif('gif', 'cry'),
                  icon: renderGif('png', 'sad', size: 20),
                  value: 'sad',
                ),
                Reaction(
                  previewIcon: renderGif('gif', 'mad'),
                  icon: renderGif('png', 'angry', size: 20),
                  value: 'angry',
                ),
              ],
              initialReaction: Reaction(
                  icon: viewerReaction.isNotEmpty
                      ? renderGif('png', viewerReaction, size: 20)
                      : const Padding(
                          padding: EdgeInsets.only(
                              left: 8, right: 8, top: 4, bottom: 4),
                          child: ButtonLayout(
                            button: {
                              "key": "reaction",
                              "icon": FontAwesomeIcons.thumbsUp,
                              "label": "Thích"
                            },
                          ),
                        ),
                  value: 'kakakak'),
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
