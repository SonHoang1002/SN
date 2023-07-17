import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/connectivity_provider.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/post_current_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/providers/posts/processing_post_provider.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/post_center.dart';
import 'package:social_network_app_mobile/screens/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screens/Post/post_header.dart';
import 'package:social_network_app_mobile/screens/Post/post_suggest.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/Posts/processing_indicator_widget.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';

class Post extends ConsumerStatefulWidget {
  final dynamic post;
  final String? type;
  final bool? isHiddenCrossbar;
  final bool? isHiddenFooter;
  final dynamic data;
  final Function? reloadFunction;
  final Function(dynamic newData)? updateDataFunction;
  final bool? isFocus;
  final bool? visible;
  final String? preType;

  const Post(
      {Key? key,
      this.post,
      this.type,
      this.isHiddenCrossbar,
      this.data,
      this.isHiddenFooter,
      this.reloadFunction,
      this.isFocus,
      this.visible,
      this.preType,
      this.updateDataFunction})
      : super(key: key);

  @override
  ConsumerState<Post> createState() => _PostState();
}

class _PostState extends ConsumerState<Post> with WidgetsBindingObserver {
  bool isHaveSuggest = true;
  final ValueNotifier<bool> _isShowCommentBox = ValueNotifier(false);
  dynamic currentPost;
  // tranh truong hop tao bai viet moi nhung khong co hieu ung cho va co the reaction o cac loai post khac o cac phan he khac
  bool isNeedInitPost = true;
  String warning = "Không có kết nối";
  dynamic meData;

  _changeShowCommentBox() {
    setState(() {
      _isShowCommentBox.value = true;
    });
  }

  updateNewPost(dynamic newData) {
    setState(() {
      isNeedInitPost = false;
      currentPost = ref.watch(currentPostControllerProvider).currentPost;
    });
    widget.updateDataFunction != null ? widget.updateDataFunction!(newData) : null;
  }

  @override
  void initState() {
    setState(() {
      currentPost = widget.post;
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    currentPost = null;
    meData = null;
    _isShowCommentBox.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    meData ??= ref.watch(meControllerProvider)[0];
    if (isNeedInitPost) {
      currentPost = widget.post;
    }
    if (ref.read(connectivityControllerProvider).connectInternet == false &&
        currentPost['processing'] == "isProcessing") {
      if (warning != "Sẽ thử lại bài viết của bạn") {
        Timer(const Duration(seconds: 5), () {
          setState(() {
            warning = "Sẽ thử lại bài viết của bạn";
          });
        });
      }
    }
    return
        // currentPost != null
        //     ?
        Column(
      children: [
        Visibility.maintain(
          // visible: widget.visible == true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.type != postPageUser &&
                      currentPost?['account']?['id'] != meData['id']
                  ? PostSuggest(
                      post: currentPost,
                      type: widget.type,
                      renderFunction: () {
                        isHaveSuggest = false;
                      },
                      updateDataFunction: updateNewPost,
                    )
                  : const SizedBox(),
              ref.watch(connectivityControllerProvider).connectInternet ==
                          false &&
                      currentPost['processing'] == "isProcessing"
                  ? InternetWarningCreatePost(
                      warning: warning,
                      showDeletePostPopup: showDeletePostPopup,
                    )
                  : const SizedBox(),
              currentPost['processing'] == "isProcessing"
                  ? const CustomLinearProgressIndicator()
                  : const SizedBox(),
              Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: currentPost['processing'] == "isProcessing"
                            ? const EdgeInsets.only(top: 7)
                            : null,
                        child: PostHeader(
                            post: currentPost,
                            type: widget.type,
                            // isHaveAction:
                            //     widget.type != postPageUser ? !isHaveSuggest : true,
                            reloadFunction: () {
                              setState(() {});
                            },
                            updateDataFunction: updateNewPost),
                      ),
                      PostCenter(
                          post: currentPost,
                          type: widget.type,
                          data: widget.data,
                          reloadFunction: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              widget.reloadFunction != null
                                  ? widget.reloadFunction!()
                                  : null;
                              setState(() {});
                            });
                          },
                          preType: widget.preType,
                          isFocus: widget.isFocus,
                          updateDataFunction: updateNewPost,
                          showCmtBoxFunction: () {
                            _changeShowCommentBox();
                          }),
                    ],
                  ),
                  currentPost['processing'] == "isProcessing"
                      ? Container(
                          height: ref
                                      .watch(processingPostController)
                                      .heightOfProcessingPost !=
                                  0
                              ? (ref
                                      .watch(processingPostController)
                                      .heightOfProcessingPost -
                                  80)
                              : 0,
                          color: greyColor.withOpacity(0.4),
                        )
                      : const SizedBox()
                ],
              ),
              (widget.isHiddenFooter != null &&
                          widget.isHiddenFooter == true) ||
                      currentPost['processing'] == "isProcessing"
                  ? const SizedBox()
                  : PostFooter(
                      post: currentPost,
                      type: widget.type,
                      updateDataFunction: updateNewPost,
                      isShowCommentBox: _isShowCommentBox.value,
                      preType: widget.preType,
                    ),
            ],
          ),
        ),
        widget.isHiddenCrossbar != null && widget.isHiddenCrossbar == true
            ? const SizedBox()
            : const CrossBar(
                height: 5,
                onlyBottom: 12,
                onlyTop: 6,
              ),
      ],
    );
    // : const SizedBox();
  }

  showDeletePostPopup() {
    return showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: buildTextContent("Bỏ bài viết", false,
                fontSize: 18, isCenterLeft: false),
            content: buildTextContent(
                "Khi nào kết nối internet mạnh hơn, chúng tôi sẽ tự động đăng nội dung này cho bạn",
                false,
                fontSize: 14,
                isCenterLeft: false),
            actions: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Flex(direction: Axis.horizontal, children: [
                  Flexible(
                    child: CupertinoButton(
                        child: buildTextContent("Hủy", false,
                            fontSize: 13, isCenterLeft: false),
                        onPressed: () {
                          popToPreviousScreen(context);
                        }),
                  ),
                  Container(
                    color: greyColor,
                    width: 0.5,
                    height: 50,
                  ),
                  Flexible(
                    child: CupertinoButton(
                        child: buildTextContent("Bỏ", false,
                            fontSize: 13, colorWord: red, isCenterLeft: false),
                        onPressed: () {
                          popToPreviousScreen(context);
                          ref
                              .read(postControllerProvider.notifier)
                              .removeProgessingPost();
                          widget.reloadFunction != null
                              ? widget.reloadFunction!()
                              : null;
                        }),
                  ),
                  buildDivider(color: greyColor),
                ]),
              )
            ],
          );
        });
  }
}

class InternetWarningCreatePost extends StatelessWidget {
  final dynamic warning;
  final Function showDeletePostPopup;
  const InternetWarningCreatePost(
      {Key? key, this.warning, required this.showDeletePostPopup})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/icons/retry_create_post.png",
                    height: 20,
                    color: secondaryColor,
                  ),
                  buildSpacer(width: 5),
                  buildTextContent(warning, false,
                      colorWord: secondaryColor, fontSize: 13)
                ],
              ),
              InkWell(
                onTap: () {
                  showDeletePostPopup();
                },
                child: Image.asset(
                  "assets/icons/remove_create_post.png",
                  height: 20,
                  color: secondaryColor,
                ),
              ),
            ],
          ),
        ),
        buildSpacer(height: 10),
        buildDivider(color: greyColor)
      ],
    );
  }
}
