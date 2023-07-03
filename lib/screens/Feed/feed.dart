import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/model/post_model.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/services/isar_post_service.dart';
import 'package:social_network_app_mobile/services/isar_service.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/skeleton.dart';
import 'package:provider/provider.dart' as pv;

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
  // ValueNotifier<List> posts = ValueNotifier([]);
  ValueNotifier<bool> loadingTo40 = ValueNotifier(false);
  ThemeManager? theme;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    Future.delayed(Duration.zero, () async {
      await ref.read(postControllerProvider.notifier).getListPost(paramsConfig);
      await IsarPostService()
          .addPostIsar(ref.read(postControllerProvider).posts);
    });
    Future.delayed(Duration.zero, () async {
      while ((await IsarPostService().getPostIsar()) < 100) {
        await useIsolate(paramsConfig);
      }
    });

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
              'my-debouncer', const Duration(milliseconds: 300), () async {
            String maxId = ref.watch(postControllerProvider).posts.isNotEmpty
                ? ref.watch(postControllerProvider).posts.last['score']
                : '';

            dynamic params = {
              "max_id": maxId,
              "multi": 2,
              ...paramsConfig,
            };
          });
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
            newDataList, paramsConfig,
            // removeHeaderPostList:
            //     (ref.read(postControllerProvider).posts.length > 40)
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

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();
    Future.delayed(Duration.zero, () async {
      logger.d("getPostIsar ${await IsarPostService().getPostIsar()}");
    });

    if (loadingTo40.value == false &&
        ref.read(postControllerProvider).posts.length >= 40) {
      loadingTo40.value = true;
    }
    bool isMore = ref.watch(postControllerProvider).isMore;
    theme ??= pv.Provider.of<ThemeManager>(context);
    return RefreshIndicator(
        onRefresh: () async {
          ref
              .read(postControllerProvider.notifier)
              .refreshListPost(paramsConfig);
        },
        child: Stack(
          children: [
            ListView.builder(
                shrinkWrap: true,
                controller: scrollController,
                itemCount: ref.read(postControllerProvider).posts.length + 1,
                itemBuilder: (context, index) {
                  if (index < ref.read(postControllerProvider).posts.length) {
                    return Post(
                        type: feedPost,
                        post: ref.read(postControllerProvider).posts[index],
                        reloadFunction: () {
                          setState(() {});
                        },
                        isFocus: focusCurrentPostIndex.value ==
                            ref.read(postControllerProvider).posts[index]['id']
                        // )
                        );
                  } else {
                    return isMore == true
                        ? Center(
                            child: SkeletonCustom().postSkeleton(context),
                          )
                        : const SizedBox();
                  }
                }),
            // Container(
            //   color: greyColor,
            //   height: 40,
            //   width: double.infinity,
            //   child: Center(
            //       child: buildTextContent(
            //           "${posts.value.length} posts", true,
            //           fontSize: 20, isCenterLeft: false)),
            // ),
          ],
        )
        // : Container(
        //     alignment: Alignment.center,
        //     margin: const EdgeInsets.only(top: 10),
        //     child: CupertinoActivityIndicator(
        //         color: theme!.isDarkMode ? Colors.white : Colors.black)),
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
