import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/posts/processing_post_provider.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_center.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/screen/Post/post_suggest.dart'; 
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/Posts/processing_indicator_widget.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    final meData = ref.watch(meControllerProvider)[0];
    return widget.post != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // widget.type != postPageUser &&
                      widget.post['account']['id'] != meData['id']
                  ? PostSuggest(
                      post: widget.post,
                      type: widget.type,
                      renderFunction: () {
                        // WidgetsBinding.instance.addPostFrameCallback((_) {
                        //   isHaveSuggest = false;
                        // });
                      },
                    )
                  : const SizedBox(),
              widget.post['processing'] == "isProcessing"
                  ? const CustomLinearProgressIndicator()
                  : const SizedBox(),
              Stack(
                children: [
                  Column(
                    children: [
                      PostHeader(
                        post: widget.post,
                        type: widget.type,
                        // isHaveAction:
                        //     widget.type != postPageUser ? !isHaveSuggest : true,
                        reloadFunction: () {
                          setState(() {});
                        },
                      ),
                      PostCenter(
                          post: widget.post,
                          type: widget.type,
                          data: widget.data,
                          reloadFunction: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              widget.reloadFunction != null
                                  ? widget.reloadFunction!()
                                  : null;
                              setState(() {});
                            });
                          }),
                    ],
                  ),
                  widget.post['processing'] == "isProcessing"
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
                      widget.post['processing'] == "isProcessing"
                  ? const SizedBox()
                  : PostFooter(
                      post: widget.post,
                      type: widget.type,
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
