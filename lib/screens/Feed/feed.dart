import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/friend/friend_provider.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screens/Feed/create_post_button.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/screens/Reef_ShortVideo/reef.dart'; 
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/Suggestions/suggest.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/skeleton.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';
import 'package:provider/provider.dart' as pv;

class Feed extends ConsumerStatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  ConsumerState<Feed> createState() => _FeedState();
}

class _FeedState extends ConsumerState<Feed> {
  final scrollController = ScrollController();
  var paramsConfig = {"limit": 3, "exclude_replies": true};
  double heightOfProcessingPost = 0;
  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(Duration.zero, () async {
      ref.read(postControllerProvider.notifier).getListPost(paramsConfig);
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
                100.0 ==
            0) {
          EasyDebounce.debounce(
              'my-debouncer', const Duration(milliseconds: 800), () {
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

  // avoid bug look up ...
  _reloadFeedFunction(dynamic type, dynamic newData) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(postControllerProvider.notifier)
          .changeProcessingPost(type, newData);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List posts = List.from(ref.watch(postControllerProvider).posts);
    bool isMore = ref.watch(postControllerProvider).isMore;
    final theme = pv.Provider.of<ThemeManager>(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref
              .read(postControllerProvider.notifier)
              .refreshListPost(paramsConfig);
        },
        child: (ref.watch(meControllerProvider).isNotEmpty &&
                ref.watch(meControllerProvider)[0] != null)
            ? SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    CreatePostButton(
                      preType: feedPost,
                      reloadFunction: _reloadFeedFunction,
                    ),
                    const CrossBar(
                      height: 5,
                    ),
                    posts.length == 5 || isMore == false
                        ? Column(
                            children: const [
                              Reef(),
                              CrossBar(
                                height: 5,
                              ),
                            ],
                          )
                        : const SizedBox(),
                    posts.length == 20 || isMore == false
                        ? Suggest(
                            type: suggestGroups,
                            headerWidget: Image.asset(
                              'assets/icon/logo_app.png',
                              height: 20,
                            ),
                            subHeaderWidget: Column(children: [
                              buildSpacer(height: 5),
                              buildTextContent(
                                  ref.watch(meControllerProvider)[0]
                                          ['display_name'] +
                                      " ơi, bạn có thể sẽ thích các nhóm sau ",
                                  true,
                                  fontSize: 17),
                              buildSpacer(height: 5),
                              buildTextContent(
                                  "Kết nối với và học hỏi từ những người có chung sở thích với bạn",
                                  false,
                                  fontSize: 16),
                            ]),
                            reloadFunction: () {
                              setState(() {});
                            },
                            footerTitle: "Khám phá thêm nhóm")
                        : const SizedBox(),
                    posts.length == 40 || isMore == false
                        ? Suggest(
                            type: suggestFriends,
                            headerWidget: buildTextContent(
                                "Những người bạn có thể biết", true,
                                fontSize: 17),
                            reloadFunction: () {
                              setState(() {});
                            },
                            footerTitle: "Xem thêm")
                        : const SizedBox(),
                    ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: posts.length + 1,
                        itemBuilder: (context, index) {
                          if (index < posts.length) {
                            return Post(
                              type: feedPost,
                              post: posts[index],
                              reloadFunction: () {
                                setState(() {});
                              },
                            );
                          } else {
                            return isMore == true
                                ? Center(
                                    child:
                                        SkeletonCustom().postSkeleton(context),
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
                                description:
                                    "Bạn đã xem hết các bài viết mới rồi"),
                          )
                  ],
                ),
              )
            : Container(
                margin: const EdgeInsets.only(top: 10),
                child: CupertinoActivityIndicator(
                    color: theme.isDarkMode ? Colors.white : Colors.black)),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(() {});
    scrollController.dispose();
  }
}
