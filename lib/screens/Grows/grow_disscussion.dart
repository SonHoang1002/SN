import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';

import '../../providers/grow/grow_provider.dart';

class GrowDiscuss extends ConsumerStatefulWidget {
  final dynamic data;
  const GrowDiscuss({super.key, this.data});

  @override
  ConsumerState<GrowDiscuss> createState() => _GrowDiscussState();
}

class _GrowDiscussState extends ConsumerState<GrowDiscuss> {
  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(
        Duration.zero,
        () => ref.read(growControllerProvider.notifier).getGrowPost(
                widget.data['id'], {
              "project_id": widget.data['id'],
              "exclude_replies": true,
              'limit': 3
            }));
  }

  @override
  Widget build(BuildContext context) {
    List growPosts = ref.watch(growControllerProvider).posts;
    return growPosts.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
                ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    primary: false,
                    itemCount: growPosts.length,
                    itemBuilder: (context, index) {
                      return Post(post: growPosts[index]);
                    })
              ])
        : const SizedBox();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
