// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:social_network_app_mobile/apis/post_api.dart';
// import 'package:social_network_app_mobile/constant/post_type.dart';
// import 'package:social_network_app_mobile/helper/reaction.dart';
// import 'package:social_network_app_mobile/providers/post_provider.dart';
// import 'package:social_network_app_mobile/screen/Post/comment_post_modal.dart';
// import 'package:social_network_app_mobile/screen/Post/post_detail.dart';
// import 'package:social_network_app_mobile/theme/colors.dart';
// import 'package:social_network_app_mobile/widget/Reaction/flutter_reaction_button.dart';
// import 'package:social_network_app_mobile/widget/screen_share.dart';

// class PostFooterButton extends ConsumerStatefulWidget {
//   final dynamic post;
//   final dynamic type;
//   const PostFooterButton({Key? key, this.post, this.type}) : super(key: key);

//   @override
//   ConsumerState<PostFooterButton> createState() => _PostFooterButtonState();
// }

// class _PostFooterButtonState extends ConsumerState<PostFooterButton>
//     with TickerProviderStateMixin {
//   @override
//   Widget build(BuildContext context) {
//     List buttonAction = [
//       {
//         "key": "comment",
//         "icon": "assets/reaction/comment_light.png",
//         "label": "Bình luận"
//       },
//       {
//         "key": "share",
//         "icon": "assets/reaction/share_light.png",
//         "label": "Chia sẻ"
//       }
//     ];
//     String viewerReaction = widget.post['viewer_reaction'] ?? '';
//     handlePress(key) {
//       if (key == 'comment') {
//         if (![postDetail, postMultipleMedia].contains(widget.type)) {
//           Navigator.push(
//               context,
//               CupertinoPageRoute(
//                   builder: (context) => PostDetail(post: widget.post)));
//         } else if (widget.type == postMultipleMedia) {
//           showBarModalBottomSheet(
//               context: context,
//               backgroundColor: Colors.transparent,
//               builder: (context) => CommentPostModal(post: widget.post));
//         }
//       } else if (key == 'share') {
//         showBarModalBottomSheet(
//             context: context,
//             backgroundColor: Colors.transparent,
//             builder: (context) => ScreenShare(
//                 entityShare: widget.post,
//                 type: widget.type,
//                 entityType: 'post'));
//       }
//     }

//     handleReaction(react) async {
//       var newPost = widget.post;
//       List newFavourites = newPost['reactions'];

//       int index = newPost['reactions']
//           .indexWhere((element) => element['type'] == react);
//       int indexCurrent = viewerReaction.isNotEmpty && react != viewerReaction
//           ? newPost['reactions']
//               .indexWhere((element) => element['type'] == viewerReaction)
//           : -1;

//       if (index >= 0) {
//         newFavourites[index] = {
//           "type": react,
//           "${react}s_count": newFavourites[index]['${react}s_count'] + 1
//         };
//       }

//       if (indexCurrent >= 0) {
//         newFavourites[indexCurrent] = {
//           "type": viewerReaction,
//           "${viewerReaction}s_count":
//               newFavourites[indexCurrent]["${viewerReaction}s_count"] - 1
//         };
//       }

//       if (react != null) {
//         dynamic data = {"custom_vote_type": react};
//         newPost = {
//           ...newPost,
//           "favourites_count": newPost['viewer_reaction'] != null
//               ? newPost['favourites_count']
//               : newPost['favourites_count'] + 1,
//           "viewer_reaction": react,
//           "reactions": newFavourites
//         };

//         ref
//             .read(postControllerProvider.notifier)
//             .actionUpdateDetailInPost(widget.type, newPost);

//         await PostApi().reactionPostApi(widget.post['id'], data);
//       } else {
//         newPost = {
//           ...newPost,
//           "favourites_count": newPost['favourites_count'] != null
//               ? newPost['favourites_count'] - 1
//               : newPost['favourites_count'],
//           "viewer_reaction": null,
//           "reactions": newFavourites
//         };

//         ref
//             .read(postControllerProvider.notifier)
//             .actionUpdateDetailInPost(widget.type, newPost);

//         await PostApi().unReactionPostApi(widget.post['id']);
//       }
//     }

//     handlePressButton() {
//       if (viewerReaction.isNotEmpty) {
//         handleReaction(null);
//       } else {
//         handleReaction('like');
//       }
//     }

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             alignment: Alignment.centerRight,
//             child: ReactionButton(
//               onReactionChanged: (value) {
//                 handleReaction(value);
//               },
//               handlePressButton: handlePressButton,
//               reactions: <Reaction>[
//                 Reaction(
//                   previewIcon: Container(
//                       padding: const EdgeInsets.only(bottom: 12),
//                       child: renderGif('gif', 'like', size: 40)),
//                   icon: renderGif('png', 'like', size: 25),
//                   value: 'like',
//                 ),
//                 Reaction(
//                   previewIcon: Container(
//                       padding: const EdgeInsets.only(top: 24),
//                       child: renderGif('gif', 'tym', size: 75)),
//                   icon: renderGif('png', 'love', size: 25),
//                   value: 'love',
//                 ),
//                 Reaction(
//                   previewIcon: Container(
//                       padding: const EdgeInsets.only(
//                         bottom: 5,
//                         left: 0,
//                         right: 0,
//                       ),
//                       child: renderGif('gif', 'hug', size: 70)),
//                   icon: renderGif('png', 'yay', size: 25),
//                   value: 'yay',
//                 ),
//                 Reaction(
//                   previewIcon: Container(
//                       padding: const EdgeInsets.only(bottom: 13),
//                       child: renderGif(
//                         'gif',
//                         'wow',
//                         size: 45,
//                       )),
//                   icon: renderGif('png', 'wow', size: 25),
//                   value: 'wow',
//                 ),
//                 Reaction(
//                   previewIcon: Container(
//                       padding: const EdgeInsets.only(bottom: 10),
//                       child: renderGif('gif', 'haha', size: 60)),
//                   icon: renderGif('png', 'haha', size: 25),
//                   value: 'haha',
//                 ),
//                 Reaction(
//                   previewIcon: Container(
//                       padding: const EdgeInsets.only(bottom: 10),
//                       child: renderGif('gif', 'cry', size: 50)),
//                   icon: renderGif('png', 'sad', size: 25),
//                   value: 'sad',
//                 ),
//                 Reaction(
//                   previewIcon: Container(
//                       padding: const EdgeInsets.only(bottom: 14),
//                       child: renderGif('gif', 'mad', size: 45)),
//                   icon: renderGif('png', 'angry', size: 25),
//                   value: 'angry',
//                 ),
//               ],
//               initialReaction: Reaction(
//                   icon: viewerReaction.isNotEmpty
//                       ? viewerReaction != "like"
//                           ? renderGif('png', viewerReaction, size: 20)
//                           : const Padding(
//                               padding: EdgeInsets.only(
//                                   left: 8, right: 8, top: 4, bottom: 4),
//                               child: ButtonLayout(
//                                 button: {
//                                   "key": "reaction",
//                                   "icon": "assets/reaction/img_like.png",
//                                   "label": "Thích",
//                                   "textColor": secondaryColor,
//                                   "color": secondaryColor
//                                 },
//                               ),
//                             )
//                       : const Padding(
//                           padding: EdgeInsets.only(
//                               left: 8, right: 8, top: 4, bottom: 4),
//                           child: ButtonLayout(
//                             button: {
//                               "key": "reaction",
//                               "icon": "assets/reaction/img_like.png",
//                               "label": "Thích"
//                             },
//                           ),
//                         ),
//                   value: 'kakakak'),
//             ),
//           ),
//           ...List.generate(
//               buttonAction.length,
//               (index) => InkWell(
//                     onTap: () {
//                       handlePress(buttonAction[index]['key']);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                         left: 8,
//                         right: 8,
//                         top: 6,
//                       ),
//                       child: ButtonLayout(button: buttonAction[index]),
//                     ),
//                   )),
//         ],
//       ),
//     );
//   }
// }

// class ButtonLayout extends StatelessWidget {
//   final dynamic button;
//   const ButtonLayout({
//     super.key,
//     this.button,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         button['icon'] is IconData
//             ? Icon(
//                 button['icon'],
//                 size: 18,
//                 color: button["color"] ?? greyColor,
//               )
//             : Image.asset(
//                 button['icon'],
//                 height: 15,
//                 color: button["color"] ?? greyColor,
//               ),
//         const SizedBox(
//           width: 3,
//         ),
//         Text(
//           button['label'],
//           style: TextStyle(
//               fontWeight: FontWeight.w500,
//               color: button["textColor"] ?? greyColor,
//               fontSize: 12),
//         )
//       ],
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/reaction.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
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
        child: suggestReactionStatus
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  buildTextContent(suggestReactionContent, false,
                      fontSize: 13, isCenterLeft: false),
                  const SizedBox(),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    
                    alignment: Alignment.centerRight,
                    child: ReactionButton(
                      onReactionChanged: (value) {
                        handleReaction(value);
                      },
                      onWaitingReaction: () {
                        // if (suggestReactionContent != suggestReaction) {
                        //   setState(() {
                        //     suggestReactionStatus = true;
                        //     suggestReactionContent = suggestReaction;
                        //   });
                        // }
                      },
                      onSelectedReaction: () {
                        // setState(() {
                        //   suggestReactionStatus = false;
                        //   suggestReactionContent = "";
                        // });
                      },
                      onHoverReaction: () {
                        // if (suggestReactionContent != cancelReaction) {
                        //   setState(() {
                        //     suggestReactionContent = cancelReaction;
                        //   });
                        // }
                      },
                      handlePressButton: handlePressButton,
                      reactions: <Reaction>[
                        Reaction(
                          previewIcon: Container(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: renderGif('gif', 'like', size: 40)),
                          icon: renderGif('png', 'like', size: 25),
                          value: 'like',
                        ),
                        Reaction(
                          previewIcon: Container(
                              padding: const EdgeInsets.only(top: 24),
                              child: renderGif('gif', 'tym', size: 75)),
                          icon: renderGif('png', 'love', size: 25),
                          value: 'love',
                        ),
                        Reaction(
                          previewIcon: Container(
                              padding: const EdgeInsets.only(
                                bottom: 5,
                                left: 0,
                                right: 0,
                              ),
                              child: renderGif('gif', 'hug', size: 70)),
                          icon: renderGif('png', 'yay', size: 25),
                          value: 'yay',
                        ),
                        Reaction(
                          previewIcon: Container(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: renderGif(
                                'gif',
                                'wow',
                                size: 45,
                              )),
                          icon: renderGif('png', 'wow', size: 25),
                          value: 'wow',
                        ),
                        Reaction(
                          previewIcon: Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: renderGif('gif', 'haha', size: 60)),
                          icon: renderGif('png', 'haha', size: 25),
                          value: 'haha',
                        ),
                        Reaction(
                          previewIcon: Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: renderGif('gif', 'cry', size: 50)),
                          icon: renderGif('png', 'sad', size: 25),
                          value: 'sad',
                        ),
                        Reaction(
                          previewIcon: Container(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: renderGif('gif', 'mad', size: 45)),
                          icon: renderGif('png', 'angry', size: 25),
                          value: 'angry',
                        ),
                      ],
                      initialReaction: Reaction(
                          icon: viewerReaction.isNotEmpty
                              ? viewerReaction != "like"
                                  ? renderGif('png', viewerReaction, size: 20)
                                  : const Padding(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 8, top: 4, bottom: 4),
                                      child: ButtonLayout(
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
                              : const Padding(
                                  padding: EdgeInsets.only(
                                      left: 8, right: 8, top: 4, bottom: 4),
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
                              child: ButtonLayout(button: buttonAction[index]),
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
