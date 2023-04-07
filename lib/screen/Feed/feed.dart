import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screen/Feed/create_post_button.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/skeleton.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class Feed extends ConsumerStatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  ConsumerState<Feed> createState() => _FeedState();
}

class _FeedState extends ConsumerState<Feed> {
  final scrollController = ScrollController();
  var paramsConfig = {"limit": 3, "exclude_replies": true};

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(
        Duration.zero,
        () => ref
            .read(postControllerProvider.notifier)
            .getListPost(paramsConfig));

    scrollController.addListener(() {
      if ((scrollController.offset + 1600).toInt() ==
          scrollController.position.maxScrollExtent.toInt()) {
        String maxId = ref.read(postControllerProvider).posts.last['score'];
        ref
            .read(postControllerProvider.notifier)
            .getListPost({"max_id": maxId, ...paramsConfig});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List posts = ref.watch(postControllerProvider).posts;
    bool isMore = ref.watch(postControllerProvider).isMore;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref
              .read(postControllerProvider.notifier)
              .refreshListPost(paramsConfig);
        },
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              const CreatePostButton(),
              const CrossBar(
                height: 5,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: posts.length + 1,
                  itemBuilder: (context, index) {
                    if (index < posts.length) {
                      return Post(type: feedPost, post: posts[index]);
                    } else {
                      return isMore == true
                          ? Center(
                              child: SkeletonCustom().postSkeleton(context),
                            )
                          : const SizedBox();
                    }
                  }),
              isMore
                  ? Center(
                      child: SkeletonCustom().postSkeleton(context),
                    )
                  : const Center(
                      child: TextDescription(
                          description: "Bạn đã xem hết các bài viết mới rồi"),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
