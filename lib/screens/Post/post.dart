import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/post_current_provider.dart';
import 'package:social_network_app_mobile/providers/posts/processing_post_provider.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/post_center.dart';
import 'package:social_network_app_mobile/screens/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screens/Post/post_header.dart';
import 'package:social_network_app_mobile/screens/Post/post_suggest.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/Posts/processing_indicator_widget.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';

class Post extends ConsumerStatefulWidget {
  final dynamic post;
  final String? type;
  final bool? isHiddenCrossbar;
  final bool? isHiddenFooter;
  final dynamic data;
  final Function? reloadFunction;

  const Post(
      {Key? key,
      this.post,
      this.type,
      this.isHiddenCrossbar,
      this.data,
      this.isHiddenFooter,
      this.reloadFunction})
      : super(key: key);

  @override
  ConsumerState<Post> createState() => _PostState();
}

class _PostState extends ConsumerState<Post> {
  bool isHaveSuggest = true;
  final ValueNotifier<bool> _isShowCommentBox = ValueNotifier(false);
  dynamic newPost;
  dynamic currentPost;
  _changeShowCommentBox() {
    setState(() {
      _isShowCommentBox.value = true;
    });
  }

  updateNewPost() {
    setState(() {
      currentPost = ref.watch(currentPostControllerProvider).currentPost;
    });
  }

  @override
  void initState() {
    currentPost ??= widget.post;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final meData = ref.watch(meControllerProvider)[0];
    return currentPost != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // widget.type != postPageUser &&
              currentPost['account']['id'] != meData['id']
                  ? PostSuggest(
                      post: currentPost,
                      type: widget.type,
                      renderFunction: () {
                        // WidgetsBinding.instance.addPostFrameCallback((_) {
                        isHaveSuggest = false;
                        // });
                      },
                      updateDataFunction: updateNewPost,
                    )
                  : const SizedBox(),
              currentPost['processing'] == "isProcessing"
                  ? const CustomLinearProgressIndicator()
                  : const SizedBox(),
              Stack(
                children: [
                  Column(
                    children: [
                      PostHeader(
                          post: currentPost,
                          type: widget.type,
                          // isHaveAction:
                          //     widget.type != postPageUser ? !isHaveSuggest : true,
                          reloadFunction: () {
                            setState(() {});
                          },
                          updateDataFunction: updateNewPost),
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
                    ),
              widget.isHiddenCrossbar != null && widget.isHiddenCrossbar == true
                  ? const SizedBox()
                  : const CrossBar(
                      height: 5,
                      onlyBottom: 12,
                      onlyTop: 6,
                    ),
            ],
          )
        : const SizedBox();
  }
}
