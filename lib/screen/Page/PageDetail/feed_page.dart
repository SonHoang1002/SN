import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screen/Feed/create_post_button.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/skeleton.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class FeedPage extends ConsumerStatefulWidget {
  final pageData;
  const FeedPage(this.pageData, {Key? key}) : super(key: key);

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  @override
  void initState() {
    if (!mounted) return;
    Map<String, dynamic> paramsConfig = {
      "limit": 5,
      "exclude_replies": true,
      'page_id': widget.pageData['id'],
      'page_owner_id': widget.pageData['id']
    };
    if (ref.read(pageControllerProvider).pageFeed.isEmpty) {
      Future.delayed(
          Duration.zero,
          () => ref
              .read(pageControllerProvider.notifier)
              .getListPageFeed(paramsConfig, widget.pageData['id']));
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List feedPage = ref.watch(pageControllerProvider).pageFeed;
    bool isMoreFeed = ref.watch(pageControllerProvider).isMoreFeed;

    return Column(
      children: [
        const CreatePostButton(),
        const CrossBar(
          height: 5,
        ),
        ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: feedPage.length + 1,
            itemBuilder: (context, index) {
              if (index < feedPage.length) {
                return Post(type: feedPost, post: feedPage[index]);
              } else {
                return isMoreFeed == true
                    ? Center(
                        child: SkeletonCustom().postSkeleton(context),
                      )
                    : const SizedBox();
              }
            }),
        isMoreFeed
            ? Center(
                child: SkeletonCustom().postSkeleton(context),
              )
            : const Center(
                child: TextDescription(
                    description: "Bạn đã xem hết các bài viết mới rồi"),
              )
      ],
    );
  }
}
