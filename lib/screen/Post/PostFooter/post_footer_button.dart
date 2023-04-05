import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/reaction.dart';
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
  const PostFooterButton({Key? key, this.post, this.type}) : super(key: key);

  @override
  ConsumerState<PostFooterButton> createState() => _PostFooterButtonState();
}

class _PostFooterButtonState extends ConsumerState<PostFooterButton>
    with TickerProviderStateMixin {
  bool suggestReactionStatus = false;
  String suggestReactionContent = "";

  // Future _init() async {
  //   Future.delayed(const Duration(seconds: 0), () {
  //     if (ref.watch(commentMessageContentProvider).message == null ||
  //         ref.watch(commentMessageContentProvider).message == 0) {
  //       ref.read(commentMessageContentProvider.notifier).setCommentMessage("");
  //       ref
  //           .read(commentMessageStatusProvider.notifier)
  //           .setCommentMessageStatus(false);
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // Future.wait([_init()]);
  }

  @override
  Widget build(BuildContext context) {
    List buttonAction = [
      {
        "key": "comment",
        "icon": "assets/reaction/comment_light.png",
        "label": "Bình luận"
      },
      {
        "key": "share",
        "icon": "assets/reaction/share_light.png",
        "label": "Chia sẻ"
      }
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
          showBarModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => CommentPostModal(post: widget.post));
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

    return GestureDetector(
      onTap: () {
        setState(() {
          suggestReactionContent = "";
          suggestReactionStatus = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child:
            //  ref.watch(commentMessageContentProvider).message != 0 &&
            //         ref.watch(commentMessageContentProvider).message != "" &&
            //         ref
            //             .watch(commentMessageStatusProvider1)
            //             .listStatus
            //             .contains(true)
            //     ? Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 7),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             const SizedBox(),
            //             GestureDetector(
            //               onTap: () {
            //                 ref
            //                     .read(commentMessageContentProvider.notifier)
            //                     .setCommentMessage("");
            //               },
            //               child: buildTextContent(
            //                   ref
            //                       .watch(commentMessageContentProvider)
            //                       .message
            //                       .toString(),
            //                   false,
            //                   fontSize: 13,
            //                   isCenterLeft: false),
            //             ),
            //             const SizedBox(),
            //           ],
            //         ),
            //       )
            //     :
            Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(left: 20),
              child: ReactionButton(
                onReactionChanged: (value) {
                  handleReaction(value);
                },
                onWaitingReaction: () {
                  // setState(() {
                  //   suggestReactionStatus = true;
                  //   suggestReactionContent = "Nhấn để chọn cảm xúc";
                  // });
                },
                onIconFocus: () {
                  // setState(() {
                  //   suggestReactionContent = "Trượt ngón tay để chọn";
                  // });
                },
                onHoverReaction: () {
                  // if (suggestReactionContent != cancelReaction) {
                  //   setState(() {
                  //     suggestReactionContent = "Buông ra để hủy";
                  //   });
                  // }
                },
                handlePressButton: handlePressButton,
                reactions: <Reaction>[
                  Reaction(
                    previewIcon: Container(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: renderGif('gif', 'like', size: 38)),
                    icon: renderGif('png', 'like', size: 25),
                    value: 'like',
                  ),
                  Reaction(
                      previewIcon: Container(
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.only(top: 15),
                          child: renderGif('gif', 'tym', size: 70)),
                      icon: renderGif('png', 'love', size: 25),
                      value: 'love',
                      needBottomPadding: true),
                  Reaction(
                      previewIcon: Container(
                          // color: greyColor,
                          alignment: Alignment.bottomCenter,
                          padding: const EdgeInsets.only(
                            bottom: 7,
                          ),
                          child: renderGif('gif', 'hug', size: 63)),
                      icon: renderGif('png', 'yay', size: 25),
                      value: 'yay',
                      needBottomPadding: true),
                  Reaction(
                    previewIcon: Container(
                        // color: blackColor,
                        padding: const EdgeInsets.only(
                          bottom: 6,
                        ),
                        alignment: Alignment.bottomCenter,
                        child: renderGif(
                          'gif',
                          'wow',
                          size: 42,
                        )),
                    icon: renderGif('png', 'wow', size: 25),
                    value: 'wow',
                  ),
                  Reaction(
                    previewIcon: Container(
                        // color: Colors.pink,
                        padding: const EdgeInsets.only(),
                        alignment: Alignment.bottomCenter,
                        child: renderGif('gif', 'haha', size: 55)),
                    icon: renderGif('png', 'haha', size: 25),
                    value: 'haha',
                  ),
                  Reaction(
                    previewIcon: Container(
                        // color: Colors.yellow,
                        padding: const EdgeInsets.only(
                          bottom: 5 ,
                        ),
                        alignment: Alignment.bottomCenter,
                        child: renderGif('gif', 'cry', size: 45)),
                    icon: renderGif('png', 'sad', size: 25),
                    value: 'sad',
                  ),
                  Reaction(
                    previewIcon: Container(
                        // color: Colors.blue,
                        padding: const EdgeInsets.only(bottom: 5 ),
                        alignment: Alignment.bottomCenter,
                        child: renderGif('gif', 'mad', size: 40)),
                    icon: renderGif('png', 'angry', size: 25),
                    value: 'angry',
                  ),
                ],
                initialReaction: Reaction(
                    icon: viewerReaction.isNotEmpty
                        ? viewerReaction != "like"
                            ? renderGif('png', viewerReaction, size: 20,iconPadding: 5)
                            : const Padding(
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, top: 4, bottom: 1),
                                child: ButtonLayout(
                                  button: {
                                    "key": "reaction",
                                    "icon": "assets/reaction/img_like_fill.png",
                                    "label": "Thích",
                                    "textColor": secondaryColor,
                                    "color": secondaryColor
                                  },
                                ),
                              )
                        : const Padding(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 4, bottom: 1),
                            child: ButtonLayout(
                              button: {
                                "key": "reaction",
                                "icon": "assets/reaction/like_light.png",
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
                          left: 8,
                          right: 8,
                          top: 6,
                        ),
                        child: Container(
                            margin: index == 1
                                ? const EdgeInsets.only(right: 20)
                                : null,
                            child: ButtonLayout(button: buttonAction[index])),
                      ),
                    )),
          ],
        ),
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
    );
  }
}
