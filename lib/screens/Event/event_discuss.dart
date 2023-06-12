import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/event_provider.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';

class EventDiscuss extends ConsumerStatefulWidget {
  final dynamic eventDetail;
  const EventDiscuss({Key? key, this.eventDetail}) : super(key: key);
  @override
  ConsumerState<EventDiscuss> createState() => _EventDiscussState();
}

class _EventDiscussState extends ConsumerState<EventDiscuss> {
  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(
        Duration.zero,
        () => ref.read(eventControllerProvider.notifier).getPostEvent(
                widget.eventDetail['id'], {
              "event_id": widget.eventDetail['id'],
              "exclude_replies": true,
              'limit': 6
            }));
  }

  @override
  Widget build(BuildContext context) {
    List eventPosts = ref.watch(eventControllerProvider).posts;
    return eventPosts.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
                ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    primary: false,
                    itemCount: eventPosts.length,
                    itemBuilder: (context, index) {
                      return Post(post: eventPosts[index]);
                    })
              ])
        : const Center(child: CupertinoActivityIndicator());
  }

  @override
  void dispose() {
    super.dispose();
  }
}
