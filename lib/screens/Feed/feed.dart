import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_persistent_keyboard_height/flutter_persistent_keyboard_height.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/a_test/fake_post.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/model/post_model.dart';
import 'package:social_network_app_mobile/providers/connectivity_provider.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screens/Feed/create_post_button.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/screens/Reef_ShortVideo/reef.dart';
import 'package:social_network_app_mobile/services/isar_post_service.dart';
import 'package:social_network_app_mobile/services/isar_service.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/Suggestions/suggest.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/skeleton.dart';
import 'package:social_network_app_mobile/widgets/snack_bar_custom.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Feed extends ConsumerStatefulWidget {
  final Function? callbackFunction;
  const Feed({Key? key, this.callbackFunction}) : super(key: key);

  @override
  ConsumerState<Feed> createState() => _FeedState();
}

class _FeedState extends ConsumerState<Feed> {
  final scrollController = ScrollController();
  var paramsConfig = {"limit": 6, "exclude_replies": true};
  double heightOfProcessingPost = 0;
  bool dataHasVideoPending = false;
  ValueNotifier<dynamic> focusCurrentPostIndex = ValueNotifier("");
  ValueNotifier<bool> loadingTo40 = ValueNotifier(false);
  ThemeManager? theme;
  List posts = [];
  ValueNotifier<bool> _isMore = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    Future.delayed(Duration.zero, () async {
      updatePostIsar();
      initRiverpodData();
      addScrollListener();
      // getListPost();
      _isMore.value = ref.read(postControllerProvider).isMore;
    });
  }

  // init 4  first post for riverpod post
  initRiverpodData() async {
    final isarPostCount = await IsarPostService().getCountPostIsar();

    if ((isarPostCount != 0)) {
      final isarPostDataList = await IsarPostService().getAllPostsFromIsar();
      if (isarPostCount >= 5) {
        ref.read(postControllerProvider.notifier).addListPost(
              isarPostDataList.sublist(0, 5),
              paramsConfig,
            );
      } else {
        ref
            .read(postControllerProvider.notifier)
            .addListPost(isarPostDataList, paramsConfig);
      }
    }
  }

  Future<void> getListPost() async {
    await IsarPostService().addPostIsar(ref.read(postControllerProvider).posts);
  }

  Future<void> updatePostIsar() async {
    // final isarPostCount = await IsarPostService().getCountPostIsar();
    // while (isarPostCount < 100 ||
    //   isarPostCount == ref.read(postControllerProvider).posts.length) {
    // if (isarPostCount > 0) {
    //   _isMore.value = true;
    // } else {
    //   _isMore.value = false;
    // }
    await useIsolate(paramsConfig);
    // }
  }

  void addScrollListener() {
    scrollController.addListener(() async {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        widget.callbackFunction != null
            ? widget.callbackFunction!(false)
            : null;
        hiddenKeyboard(context);
        if (double.parse((scrollController.offset).toStringAsFixed(0)) %
                    120.0 ==
                0 ||
            scrollController.offset ==
                scrollController.position.maxScrollExtent) {
          EasyDebounce.debounce(
              'my-debouncer', const Duration(milliseconds: 180), () async {
            // kiểm tra không có kết nối hoặc có kết nối mà không còn bài viết nào khác nữa --> lấy data từ isar
            if (!ref.watch(connectivityControllerProvider).connectInternet ||
                ((_isMore.value != true ||
                        ref.watch(postControllerProvider).isMore != true) &&
                    ref
                        .watch(connectivityControllerProvider)
                        .connectInternet)) {
              getDataFromIsar();
            }
            updatePostIsar();
          });
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.callbackFunction != null ? widget.callbackFunction!(true) : null;
        hiddenKeyboard(context);
        if (double.parse((scrollController.offset).toStringAsFixed(0)) %
                120.0 ==
            0) {}
      }
    });
  }

  getDataFromIsar() async {
    final instance = await IsarService.instance;
    final allPostInIsar = await instance.postModels.where().findAll();
    final postIdList = allPostInIsar.map((e) => e.postId).toList();
    if (ref.watch(postControllerProvider).posts.isEmpty) {
      renderPostForRiverpod(allPostInIsar, 0);
    } else {
      var index = postIdList
          .indexOf(ref.watch(postControllerProvider).posts.last['id']);
      renderPostForRiverpod(allPostInIsar, index);
    }
  }

  renderPostForRiverpod(List isarPostList, int index) {
    if (isarPostList.length >= index + 7) {
      List newDataList = isarPostList
          .map((e) => jsonDecode(e.objectPost!))
          .toList()
          .sublist(index + 1, index + 7);
      ref
          .read(postControllerProvider.notifier)
          .addListPost(newDataList, paramsConfig);
    } else {
      ref.read(postControllerProvider.notifier).addListPost(
            isarPostList.map((e) => jsonDecode(e.objectPost!)).toList(),
            paramsConfig,
          );
    }
  }
////////////// begin isolate

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
    if (ref.watch(connectivityControllerProvider).connectInternet) {
      ref.read(postControllerProvider.notifier).addListPost(
            response,
            paramsConfig,
          );
    }
    return response;
  }

  static Future<void> callGetListPostIsolate(List<dynamic> args) async {
    SendPort resultPort = args[0];
    BackgroundIsolateBinaryMessenger.ensureInitialized(args[1][0]);
    final response = await PostApi().getListPostApi(args[1][1]);
    Isolate.exit(resultPort, response);
  }

////////////// end isolate

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
        if (newData?['media_attachments'] != null) {
          newData?['media_attachments'].forEach((ele) {
            if (ele['type'] == "video") {
              isHaveVideo = true;
            }
          });
          if (isHaveVideo) {
            buildSnackBar(context, "Video của bạn đã sẵn sàng.");
          }
        }
      });
    }
  }

  _jumpToOffsetFunction(Offset currentOffset) {
    double keyboardHeight = PersistentKeyboardHeight.of(context).keyboardHeight;
    final screenHeight = MediaQuery.sizeOf(context).height;
    if (keyboardHeight == 0) {
      keyboardHeight = 320.3809523809524;
    }
    scrollController.animateTo(
        scrollController.offset -
            (screenHeight - keyboardHeight - currentOffset.dy),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List posts = List.from(ref.watch(postControllerProvider).posts);
    theme ??= pv.Provider.of<ThemeManager>(context);
    if (!posts.contains(fakePost)) {
      posts.add(fakePost);
    }
    if (!posts.contains(abc)) {
      posts.add(abc);
    }
    Future.delayed(Duration.zero, () async {
      final count = await IsarPostService().getCountPostIsar();
      print("=============== ${count}");
    });
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
                  height: 7,
                  opacity: 0.2,
                ),
                posts.isEmpty
                    ? Column(
                        children: [
                          const Reef(),
                          _buildSuggestGroupWidget(),
                          _buildSuggestFriendsWidget()
                        ],
                      )
                    : const SizedBox(),
              ])),
              posts.isNotEmpty
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return VisibilityDetector(
                          key: Key(posts[index]?['id'] ??
                              Random().nextInt(10000).toString()),
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
                              index == 4 ? const Reef() : const SizedBox(),
                              index == 19
                                  ? _buildSuggestGroupWidget()
                                  : const SizedBox(),
                              index == 39
                                  ? _buildSuggestFriendsWidget()
                                  : const SizedBox(),
                              VisibilityDetector(
                                key: Key(posts[index]['id'] ?? "000"),
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
                                child: Post(
                                    type: feedPost,
                                    post: posts[index],
                                    reloadFunction: () {
                                      setState(() {});
                                    },
                                    friendData:
                                        ref.watch(meControllerProvider)[0],
                                    jumpToOffsetFunction: _jumpToOffsetFunction,
                                    isFocus: focusCurrentPostIndex.value ==
                                        posts[index]['id']),
                              )
                            ],
                          ),
                        );
                      }, childCount: posts.length),
                    )
                  : const SliverToBoxAdapter(child: SizedBox()),
              _isMore.value && ref.read(postControllerProvider).isMore
                  ? SliverToBoxAdapter(
                      child:
                          Center(child: SkeletonCustom().postSkeleton(context)))
                  : SliverToBoxAdapter(
                      child: Container(
                          margin: const EdgeInsets.only(bottom: 40),
                          child: buildTextContent(
                              "Không còn bài viết nào", false,
                              fontSize: 15, isCenterLeft: false)))
            ])
          : Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 10),
              child: CupertinoActivityIndicator(
                  color: theme!.isDarkMode ? Colors.white : Colors.black)),
    );
  }

  Widget _buildSuggestGroupWidget() {
    final meData = ref.watch(meControllerProvider)[0];
    return Suggest(
        type: suggestGroups,
        headerWidget: Image.asset(
          'assets/icon/logo_app.png',
          height: 20,
        ),
        subHeaderWidget: Column(children: [
          buildSpacer(height: 5),
          buildTextContent(
              (meData?['display_name'] ?? meData?['name']) +
                  " ơi, bạn có thể sẽ thích các nhóm sau ",
              true,
              fontSize: 17),
          buildSpacer(height: 5),
          buildTextContent(
              "Kết nối với và học hỏi từ những người có chung sở thích với bạn",
              false,
              fontSize: 16),
        ]),
        cancellMessage: const [
          "Tạm thời, phần Những nhóm được gợi ý đã ẩn khỏi Bảng Feed",
          "Đã ẩn phần những nhóm bạn có thể tham gia"
        ],
        reloadFunction: () {
          setState(() {});
        },
        footerTitle: "Khám phá thêm nhóm");
  }

  Widget _buildSuggestFriendsWidget() {
    return Suggest(
        type: suggestFriends,
        headerWidget:
            buildTextContent("Những người bạn có thể biết", true, fontSize: 17),
        reloadFunction: () {
          setState(() {});
        },
        cancellMessage: const [
          "Tạm thời, phần Những người bạn có thể biết đã ẩn khỏi Bảng Feed",
          "Đã ẩn phần những người bạn có thể biết"
        ],
        footerTitle: "Xem thêm");
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    focusCurrentPostIndex.dispose();
    super.dispose();
  }
}
