import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/watch_provider.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/widget/skeleton.dart';

class WatchHome extends ConsumerStatefulWidget {
  const WatchHome({Key? key}) : super(key: key);

  @override
  _WatchHomeState createState() => _WatchHomeState();
}

class _WatchHomeState extends ConsumerState<WatchHome> {
  final scrollController = ScrollController();

  @override
  void initState() {
    if (mounted && ref.read(watchControllerProvider).watchSuggest.isEmpty) {
      Future.delayed(Duration.zero, () {
        ref
            .read(watchControllerProvider.notifier)
            .getListWatchSuggest({"limit": 3});
      });
    }

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        String maxId =
            ref.read(watchControllerProvider).watchSuggest.last['score'];
        ref
            .read(watchControllerProvider.notifier)
            .getListWatchSuggest({"max_id": maxId, "limit": 3});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List watchSuggest = ref.watch(watchControllerProvider).watchSuggest;

    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Column(
                children: List.generate(
                    watchSuggest.length,
                    (index) => Post(
                          key: Key(watchSuggest[index]['id']),
                          post: watchSuggest[index],
                          type: postWatch,
                        ))),
            SkeletonCustom().postSkeleton(context)
          ],
        ),
      ),
    );
  }
}
