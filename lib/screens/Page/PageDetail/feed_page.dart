import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/screens/Feed/create_post_button.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/skeleton.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';

class FeedPage extends ConsumerStatefulWidget {
  final dynamic pageData;
  final bool? isUser;
  final bool isInPage;
  const FeedPage({Key? key, this.pageData, this.isUser, this.isInPage = false})
      : super(key: key);

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  String? pageId;

  @override
  void initState() {
    super.initState();
    if (widget.pageData != null) {
      pageId = widget.pageData['id'];
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ref.read(pageControllerProvider).pageFeed.isEmpty) {
      Map<String, dynamic> paramsConfig = {
        "limit": 5,
        "exclude_replies": true,
        'page_id': pageId,
        'page_owner_id': pageId
      };
      Future.delayed(Duration.zero, () {
        ref
            .read(pageControllerProvider.notifier)
            .getListPageFeed(paramsConfig, pageId);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _reloadFunction(dynamic type, dynamic newData) {
    if (type == null && newData == null) {
      setState(() {});
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pageControllerProvider.notifier).changeProcessingPost(newData);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List feedPage = ref.watch(pageControllerProvider).pageFeed;
    bool isMoreFeed = ref.watch(pageControllerProvider).isMoreFeed;
    return Column(
      children: [
        widget.pageData != null &&
                ["admin", "moderator"]
                    .contains(widget.pageData?['page_relationship']?['role'])
            ? CreatePostButton(
                preType: postPage,
                reloadFunction: _reloadFunction,
                pageData: widget.isUser == true ? null : widget.pageData,
              )
            : const SizedBox(),
        const CrossBar(height: 5),
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: feedPage.length + 1,
          itemBuilder: (context, index) {
            if (index < feedPage.length) {
              return Post(
                isInGroup: widget.isInPage,
                type: postPage,
                post: feedPage[index],
              );
            } else {
              return isMoreFeed == true
                  ? Center(child: SkeletonCustom().postSkeleton(context))
                  : const SizedBox();
            }
          },
        ),
        isMoreFeed
            ? Center(child: SkeletonCustom().postSkeleton(context))
            : const Center(
                child: TextDescription(
                    description: "Bạn đã xem hết các bài viết mới rồi"),
              ),
      ],
    );
  }
}
