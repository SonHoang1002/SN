import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_center.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/screen/Post/post_suggest.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

class Post extends StatefulWidget {
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
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  bool isHaveSuggest = true;

  @override
  Widget build(BuildContext context) {
    return widget.post != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.type != postPageUser
                  ? PostSuggest(
                      post: widget.post,
                      type: widget.type,
                      function: () {
                        // setState(() {
                        isHaveSuggest = false;
                        // });
                      },
                    )
                  : const SizedBox(),
              PostHeader(
                post: widget.post,
                type: widget.type,
                isHaveAction:
                    widget.type != postPageUser ? !isHaveSuggest : true,
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
              widget.isHiddenFooter != null && widget.isHiddenFooter == true
                  ? const SizedBox()
                  : PostFooter(
                      post: widget.post,
                      type: widget.type,
                    ),
              widget.isHiddenCrossbar != null && widget.isHiddenCrossbar == true
                  ? const SizedBox()
                  : const CrossBar(
                      height: 5,
                      // margin: 8,
                      onlyBottom: 12, onlyTop: 6,
                    ),
            ],
          )
        : const SizedBox();
  }
}
