import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/helper/reaction.dart';
import 'package:social_network_app_mobile/providers/post_current_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/providers/posts/reaction_message_content.dart';
import 'package:social_network_app_mobile/screen/Post/comment_post_modal.dart';
import 'package:social_network_app_mobile/screen/Post/post_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/Reaction/flutter_reaction_button.dart';
import 'package:social_network_app_mobile/widget/screen_share.dart';

String suggestReaction = "Trượt ngón tay để chọn";
String cancelReaction = "Buông ra để hủy";

class PostFooterButton extends ConsumerStatefulWidget {
  final dynamic post;
  final dynamic type;
  final String? preType;
  final Function? backFunction;

  const PostFooterButton(
      {Key? key, this.post, this.type, this.backFunction, this.preType})
      : super(key: key);

  @override
  ConsumerState<PostFooterButton> createState() => _PostFooterButtonState();
}

class _PostFooterButtonState extends ConsumerState<PostFooterButton>
    with TickerProviderStateMixin {
  // bool suggestReactionStatus = false;
  String suggestReactionContent = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List buttonAction = [
      {
        "key": "comment",
        "icon": "assets/reaction/comment_light.png",
        "label": "Bình luận",
      },
      {
        "key": "share",
        "icon": "assets/reaction/share_light.png",
        "label": "Chia sẻ",
      }
    ];
    String viewerReaction = widget.post['viewer_reaction'] ?? '';
    handlePress(key) {
      if (key == 'comment') {
        if (![postDetail, postMultipleMedia].contains(widget.type)) {
           pushCustomCupertinoPageRoute(
                            context,
                           PostDetail(
                        post: widget.post,
                        preType: widget.type,
                      ));
          // Navigator.push(
          //     context,
          //     CupertinoPageRoute(
          //         builder: (context) => PostDetail(
          //               post: widget.post,
          //               preType: widget.type,
          //             )));
        } else if (widget.type == postMultipleMedia) {
          showBarModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => CommentPostModal(
                    post: widget.post,
                    preType: widget.preType,
                  ));
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
        ref.read(postControllerProvider.notifier).actionUpdateDetailInPost(
            widget.type, newPost,
            preType: widget.preType);
        ref
            .read(currentPostControllerProvider.notifier)
            .saveCurrentPost(newPost);
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
        ref.read(postControllerProvider.notifier).actionUpdateDetailInPost(
            widget.type, newPost,
            preType: widget.preType);
        ref
            .read(currentPostControllerProvider.notifier)
            .saveCurrentPost(newPost);
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

    return GestureDetector(
        onTap: () {
          setState(() {
            suggestReactionContent = "";
            // suggestReactionStatus = false;
          });
        },
        child: suggestReactionContent == ""
            ? SizedBox(
                height: 30,
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      flex: 1,
                      child: ReactionButton(
                        onReactionChanged: (value) {
                          handleReaction(value);
                        },
                        handlePressButton: handlePressButton,
                        onWaitingReaction: () {
                          setState(() {
                            suggestReactionContent = "Trượt để chọn";
                            // suggestReactionStatus = false;
                          });
                        },
                        // onHoverReaction: () {
                        //   setState(() {
                        //     suggestReactionContent = "";
                        //     suggestReactionStatus = false;
                        //   });
                        // },
                        onCancelReaction: () {
                          setState(() {
                            suggestReactionContent = "";
                          });
                        },
                        reactions: <Reaction>[
                          Reaction(
                            previewIcon: renderGif('gif', 'like'),
                            icon: renderGif('png', 'like', size: 20),
                            value: 'like',
                          ),
                        ],
                        initialReaction: Reaction(
                            icon: viewerReaction.isNotEmpty
                                ? viewerReaction != "like"
                                    ? renderGif(
                                        'png',
                                        viewerReaction,
                                        size: 20,
                                        iconPadding: 5,
                                      )
                                    : Container(
                                        padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                            top: 4,
                                            bottom: 1),
                                        child: const ButtonLayout(
                                          button: {
                                            "key": "reaction",
                                            "icon":
                                                "assets/reaction/img_like_fill.png",
                                            "label": "Thích",
                                            "textColor": secondaryColor,
                                            "color": secondaryColor
                                          },
                                        ),
                                      )
                                : Container(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 6, bottom: 1),
                                    child: const ButtonLayout(
                                      button: {
                                        "key": "reaction",
                                        "icon":
                                            "assets/reaction/like_light.png",
                                        "label": "Thích"
                                      },
                                    ),
                                  ),
                            value: 'kakakak'),
                      ),
                    ),
                    ...List.generate(
                        buttonAction.length,
                        (index) => Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  handlePress(buttonAction[index]['key']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    // left: 8,
                                    // right: 8,
                                    top: 6,
                                  ),
                                  child: Container(
                                      margin: index == 1
                                          ? const EdgeInsets.only(right: 20)
                                          : null,
                                      child: ButtonLayout(
                                          button: buttonAction[index])),
                                ),
                              ),
                            )),
                  ],
                ),
              )
            : SizedBox(
                height: 40,
                child: buildTextContent(suggestReactionContent, false,
                    isCenterLeft: false),
              ));
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          button['icon'] is IconData
              ? Icon(
                  button['icon'],
                  size: 18,
                  color: button["color"] ?? greyColor,
                )
              : Image.asset(
                  button['icon'],
                  height: 15,
                  color: button["color"] ?? greyColor,
                ),
          const SizedBox(
            width: 3,
          ),
          Text(
            button['label'],
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: button["textColor"] ?? greyColor,
                fontSize: 12),
          )
        ],
      ),
    );
  }
}
