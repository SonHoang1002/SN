import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/providers/posts/position_post_provider.dart';
import 'package:social_network_app_mobile/screen/Feed/create_post_button.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/screen/Reef_ShortVideo/reef.dart';
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
    Future.delayed(Duration.zero, () async {
      ref.read(postControllerProvider.notifier).getListPost(paramsConfig);
      // if (ref.watch(positionPostProvider).positionScroll == null ||
      //     ref.watch(positionPostProvider).positionScroll == "") {
      //   ref.read(positionPostProvider.notifier).setPostionPost(0);
      // }
      // final prefs = await SharedPreferences.getInstance();
      // final double offset = prefs.getDouble('scrollOffset') ?? 0.0;
      // scrollController.jumpTo(offset);
    });

    scrollController.addListener(() {
      // if (scrollController.position.maxScrollExtent < 3000 ||
      //     (scrollController.offset).toDouble() <
      //             scrollController.position.maxScrollExtent &&
      //         (scrollController.offset).toDouble() >
      //             scrollController.position.maxScrollExtent - 3000) {
      //   EasyDebounce.debounce('my-debouncer', const Duration(milliseconds: 300),
      //       () {
      //     String maxId = ref.watch(postControllerProvider).posts.last['score'];
      //     ref.read(postControllerProvider.notifier).getListPost({
      //       "max_id": maxId,
      //       "multi": 2,
      //       ...paramsConfig,
      //     });
      //   });
      // }

      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (double.parse((scrollController.offset).toStringAsFixed(0)) %
                120.0 ==
            0) {
          EasyDebounce.debounce(
              'my-debouncer', const Duration(milliseconds: 1000), () {
            String maxId =
                ref.watch(postControllerProvider).posts.last['score'];
            ref.read(postControllerProvider.notifier).getListPost({
              "max_id": maxId,
              "multi": 2,
              ...paramsConfig,
            });
          });
        }
      }
    });
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
              const Reef(),
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

  @override
  Future<void> dispose() async {
    super.dispose();
    scrollController.dispose();
    // if (scrollController.offset > 0) {
    //   final prefs = await SharedPreferences.getInstance();
    //   prefs.setDouble('scrollOffset', scrollController.offset);
    // }
  }
}
