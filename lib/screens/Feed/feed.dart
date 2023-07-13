import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/model/post_model.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screens/Feed/create_post_button.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/screens/Reef_ShortVideo/reef.dart';
import 'package:social_network_app_mobile/services/isar_post_service.dart';
import 'package:social_network_app_mobile/services/isar_service.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/Suggestions/suggest.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/skeleton.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Feed extends ConsumerStatefulWidget {
  final Function? callbackFunction;
  const Feed({Key? key, this.callbackFunction}) : super(key: key);

  @override
  ConsumerState<Feed> createState() => _FeedState();
}

class _FeedState extends ConsumerState<Feed> {
  final scrollController = ScrollController();
  var paramsConfig = {"limit": 3, "exclude_replies": true};
  double heightOfProcessingPost = 0;
  bool dataHasVideoPending = false;
  ValueNotifier<dynamic> focusCurrentPostIndex = ValueNotifier("");
  ValueNotifier<bool> loadingTo40 = ValueNotifier(false);
  ThemeManager? theme;
  List posts = [];

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    // Future.delayed(Duration.zero, () async {
    //   await ref.read(postControllerProvider.notifier).getListPost(paramsConfig);
    //   await IsarPostService()
    //       .addPostIsar(ref.read(postControllerProvider).posts);
    // });
    // Future.delayed(Duration.zero, () async {
    //   while ((await IsarPostService().getCountPostIsar()) < 400) {
    //     await useIsolate(paramsConfig);
    //   }
    // });

    getListPost();
    updatePostIsar();
    addScrollListener();
  }

  Future<void> getListPost() async {
    await ref.read(postControllerProvider.notifier).getListPost(paramsConfig);
    await IsarPostService().addPostIsar(ref.read(postControllerProvider).posts);
  }

  Future<void> updatePostIsar() async {
    while ((await IsarPostService().getCountPostIsar()) < 100) {
      await useIsolate(paramsConfig);
    }
  }

  void addScrollListener() {
    scrollController.addListener(() async {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        widget.callbackFunction != null
            ? widget.callbackFunction!(false)
            : null;

        if (double.parse((scrollController.offset).toStringAsFixed(0)) %
                120.0 ==
            0) {
          EasyDebounce.debounce(
              'my-debouncer', const Duration(milliseconds: 300), () async {});
          getDataFromIsar();
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.callbackFunction != null ? widget.callbackFunction!(true) : null;
        if (double.parse((scrollController.offset).toStringAsFixed(0)) %
                120.0 ==
            0) {}
      }
      hiddenKeyboard(context);
    });
  }

  useIsolate(dynamic params) async {
    final ReceivePort receivePort = ReceivePort();
    RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
    try {
      await Isolate.spawn(callGetListPostIsolate, [
        receivePort.sendPort,
        [rootIsolateToken, params ?? paramsConfig]
      ]);
    } on Object {
      debugPrint('Isolate Failed');
      receivePort.close();
    }
    final response = await receivePort.first;
    await IsarPostService().addPostIsar(response);
    return response;
  }

  getDataFromIsar() async {
    if (ref.watch(postControllerProvider).posts.isEmpty) return;
    final instance = await IsarService.instance;
    final allPostInIsar = await instance.postModels.where().findAll();
    final postIdList = allPostInIsar.map((e) => e.postId).toList();
    final index =
        postIdList.indexOf(ref.watch(postControllerProvider).posts.last['id']);

    if (allPostInIsar.length > index + 10) {
      List newDataList = allPostInIsar
          .map((e) => jsonDecode(e.objectPost!))
          .toList()
          .sublist(index + 1, index + 10);
      ref.read(postControllerProvider.notifier).addListPost(
            newDataList,
            paramsConfig,
          );
    }
  }

  static Future<void> callGetListPostIsolate(List<dynamic> args) async {
    SendPort resultPort = args[0];
    BackgroundIsolateBinaryMessenger.ensureInitialized(args[1][0]);
    final response = await PostApi().getListPostApi(args[1][1]);
    Isolate.exit(resultPort, response);
  }

  updateDataInRiverpod(String scrollDirection) async {
    final instance = await IsarService.instance;
    final allPostInIsar = await instance.postModels.where().findAll();
    final postIdList = allPostInIsar.map((e) => e.postId).toList();
    dynamic resultData;
    if (scrollDirection == "fromBottomToTop") {
    } else if (scrollDirection == "fromTopToBottom") {
      final index =
          postIdList.indexOf(ref.watch(postControllerProvider).posts[0]['id']);
      if (index > 0) {
        resultData = allPostInIsar[index - 1];
      }
    }

    if (resultData != null) {
      ref
          .read(postControllerProvider.notifier)
          .updatePostWhenScroll(scrollDirection, resultData);
    }
  }

  // // avoid bug look up ...
  _reloadFeedFunction(dynamic type, dynamic newData) async {
    if (type == null && newData == null) {
      setState(() {});
      return;
    }
    if (newData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(postControllerProvider.notifier).changeProcessingPost(newData);
        bool isHaveVideo = false;
        newData['media_attachments'].forEach((ele) {
          if (ele['type'] == "video") {
            isHaveVideo = true;
          }
        });
        if (isHaveVideo) {
          _buildSnackBar("Video của bạn đã sẵn sàng.");
        }
      });
    }
  }

  _buildSnackBar(String title) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(title),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(9)))),
    );
  }

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();
    Future.delayed(Duration.zero, () async {
      logger.d("getPostIsar ${await IsarPostService().getCountPostIsar()}");
    });
    List posts = List.from(ref.read(postControllerProvider).posts);

    // if (loadingTo40.value == false &&
    //     ref.read(postControllerProvider).posts.length >= 40) {
    //   loadingTo40.value = true;
    // }
    bool isMore = ref.watch(postControllerProvider).isMore;
    theme ??= pv.Provider.of<ThemeManager>(context);
    posts = ref.read(postControllerProvider).posts;

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(postControllerProvider.notifier).refreshListPost(paramsConfig);
      },
      child: (ref.watch(meControllerProvider).isNotEmpty &&
              ref.watch(meControllerProvider)[0] != null)
          ? CustomScrollView(controller: scrollController, slivers: [
              SliverToBoxAdapter(
                  child: Column(children: [
                CreatePostButton(
                  preType: feedPost,
                  reloadFunction: _reloadFeedFunction,
                ),
                const CrossBar(
                  height: 5,
                ),
                posts.isEmpty
                    ? Column(
                        children: [
                          ref
                                  .watch(momentControllerProvider)
                                  .momentSuggest
                                  .isNotEmpty
                              ? const Column(
                                  children: [
                                    Reef(),
                                    CrossBar(
                                      height: 5,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          Suggest(
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
                              footerTitle: "Khám phá thêm nhóm"),
                          Suggest(
                              type: suggestFriends,
                              headerWidget: buildTextContent(
                                  "Những người bạn có thể biết", true,
                                  fontSize: 17),
                              reloadFunction: () {
                                setState(() {});
                              },
                              footerTitle: "Xem thêm")
                        ],
                      )
                    : const SizedBox(),
              ])),
              posts.isNotEmpty
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return VisibilityDetector(
                          key: Key(posts[index]['id']),
                          onVisibilityChanged: (info) {
                            double visibleFraction = info.visibleFraction;
                            if (visibleFraction > 0.6) {
                              if (focusCurrentPostIndex.value !=
                                  posts[index]['id']) {
                                focusCurrentPostIndex.value =
                                    posts[index]['id'];
                              }
                            }
                          },
                          child: Column(
                            children: [
                              index == 4
                                  ? const Column(
                                      children: [
                                        Reef(),
                                        CrossBar(
                                          height: 5,
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              index == 19
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
                              index == 39
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
                              Post(
                                  type: feedPost,
                                  post: posts[index],
                                  reloadFunction: () {
                                    setState(() {});
                                  },
                                  isFocus: focusCurrentPostIndex.value ==
                                      posts[index]['id']),
                            ],
                          ),
                        );
                      }, childCount: posts.length),
                    )
                  : const SliverToBoxAdapter(child: SizedBox()),
              isMore
                  ? SliverToBoxAdapter(
                      child:
                          Center(child: SkeletonCustom().postSkeleton(context)))
                  : const SliverToBoxAdapter(
                      child: Center(child: Text('Không còn bài post nào')))
            ])
          : Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 10),
              child: CupertinoActivityIndicator(
                  color: theme!.isDarkMode ? Colors.white : Colors.black)),
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    focusCurrentPostIndex.dispose();
    super.dispose();
  }
}
