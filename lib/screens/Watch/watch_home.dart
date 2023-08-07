import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/watch_provider.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/widgets/skeleton.dart';
import 'package:visibility_detector/visibility_detector.dart';

class WatchHome extends ConsumerStatefulWidget {
  final String type;
  final Function fetchDataWatch;
  final bool? isFocus;
  const WatchHome(
      {Key? key,
      required this.type,
      required this.fetchDataWatch,
      this.isFocus})
      : super(key: key);

  @override
  _WatchHomeState createState() => _WatchHomeState();
}

class _WatchHomeState extends ConsumerState<WatchHome>
    with AutomaticKeepAliveClientMixin {
  final scrollController = ScrollController();

  ValueNotifier<String>? focusIdNotifier;

  @override
  void initState() {
    super.initState();
    scrollController
      ..addListener(() {
        final min = double.parse((scrollController.position.maxScrollExtent)
                .toStringAsFixed(0)) -
            300.0;
        final max = double.parse((scrollController.position.maxScrollExtent)
                .toStringAsFixed(0)) -
            100.0;
        final currentOffset =
            double.parse((scrollController.offset).toStringAsFixed(0));
        if (min < currentOffset && currentOffset < max) {
          String maxId = widget.type == 'watch_home'
              ? ref.read(watchControllerProvider).watchSuggest.last['score']
              : ref.read(watchControllerProvider).watchFollow.last['score'];
          widget.fetchDataWatch(widget.type, {"max_id": maxId, "limit": 3});
        }
      })
      ..addListener(() {
        if ((scrollController.position.maxScrollExtent) ==
            scrollController.offset) {
          // String maxId = widget.type == 'watch_home'
          //     ? ref.read(watchControllerProvider).watchSuggest.last['score']
          //     : ref.read(watchControllerProvider).watchFollow.last['score'];
          // widget.fetchDataWatch(widget.type, {"max_id": maxId, "limit": 3});
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
    List watchData = widget.type == 'watch_home'
        ? ref.watch(watchControllerProvider).watchSuggest
        : ref.watch(watchControllerProvider).watchFollow;
    watchData.isEmpty
        ? null
        : focusIdNotifier ??= ValueNotifier(watchData[0]?['id']);

    // [110750106876372619, 110750102990006995, 110673932458552076,
    // 110673674660771731, 110673437079587627, 110673200636080428]

    // [110687626644559367, 110568916833729667, 110568899606375321,
    // 110568797742857620, 110568789090500908, 110512206994112364]
    print(widget.type.toString() + widget.isFocus.toString());
    return Expanded(
        child: watchData.isNotEmpty
            ? Column(
                children: [
                  Flexible(
                      child: ListView.builder(
                          shrinkWrap: true,
                          controller: scrollController,
                          itemCount: watchData.length,
                          itemBuilder: (context, index) => VisibilityDetector(
                                key: Key((watchData[index]?['id']) ??
                                    Random().nextInt(10000).toString()),
                                onVisibilityChanged: (info) {
                                  double visibleFraction = info.visibleFraction;
                                  if (visibleFraction > 0.7) {
                                    focusIdNotifier!.value =
                                        focusIdNotifier!.value !=
                                                watchData[index]['id']
                                            ? watchData[index]['id']
                                            : focusIdNotifier!.value;
                                    setState(() {});
                                  }
                                },
                                child: Post(
                                    key: Key((watchData[index]?['id']) ??
                                        Random().nextInt(10000).toString()),
                                    post: watchData[index],
                                    type: postWatch,
                                    isFocus:
                                        // widget.isFocus == true && (
                                        focusIdNotifier!.value ==
                                            watchData[index]['id'],
                                    // ),
                                    preType: widget.type == 'watch_home'
                                        ? "suggest"
                                        : "follow"),
                              ))),
                  (widget.type == 'watch_home'
                          ? ref.watch(watchControllerProvider).isMoreSuggest
                          : ref.watch(watchControllerProvider).isMoreFollow)
                      ? const SizedBox()
                      : const Center(
                          child: Text('Không còn bài viết gợi ý nào nữa'))
                ],
              )
            : ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: ((context, index) {
                  return SkeletonCustom().postSkeleton(context);
                }))
        // const Center(child: Text('Không còn bài viết nào')),
        );
  }

  @override
  bool get wantKeepAlive => true;
}
