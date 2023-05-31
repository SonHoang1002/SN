import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/watch_provider.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/widget/skeleton.dart';

class WatchHome extends ConsumerStatefulWidget {
  final String type;
  final Function fetchDataWatch;
  const WatchHome({Key? key, required this.type, required this.fetchDataWatch})
      : super(key: key);

  @override
  _WatchHomeState createState() => _WatchHomeState();
}

class _WatchHomeState extends ConsumerState<WatchHome>
    with AutomaticKeepAliveClientMixin {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        String maxId = widget.type == 'watch_home'
            ? ref.read(watchControllerProvider).watchSuggest.last['score']
            : ref.read(watchControllerProvider).watchFollow.last['score'];
        widget.fetchDataWatch(widget.type, {"max_id": maxId, "limit": 3});
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
    super.build(context);
    List watchData = widget.type == 'watch_home'
        ? ref.watch(watchControllerProvider).watchSuggest
        : ref.watch(watchControllerProvider).watchFollow;

    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: watchData.length,
                itemBuilder: (context, index) => Post(
                      key: Key(watchData[index]['id']),
                      post: watchData[index],
                      type: postWatch,
                    )),
            watchData.isEmpty
                ? const Center(
                    child: Text('Không có dữ liệu hiển thị'),
                  )
                : SkeletonCustom().postSkeleton(context)
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
