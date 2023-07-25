import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:social_network_app_mobile/providers/learn_space/learn_space_provider.dart';

class LearnSpacePurchased extends ConsumerStatefulWidget {
  final dynamic courseDetail;
  const LearnSpacePurchased({Key? key, this.courseDetail}) : super(key: key);

  @override
  ConsumerState<LearnSpacePurchased> createState() =>
      _LearnSpacePurchasedState();
}

class _LearnSpacePurchasedState extends ConsumerState<LearnSpacePurchased> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(
          Duration.zero,
          () => ref
              .read(learnSpaceStateControllerProvider.notifier)
              .getListCoursePurchased(widget.courseDetail['id']));
    }
  }

  @override
  Widget build(BuildContext context) {
    List coursePurchased =
        ref.watch(learnSpaceStateControllerProvider).coursePurchased;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
              'Danh sách những người mua khóa học (${coursePurchased.length})'),
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: coursePurchased.length,
            itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(coursePurchased[index]
                      ['account']['avatar_media']['show_url']),
                ),
                title: Text(coursePurchased[index]['account']['display_name']),
                subtitle: Text(
                    'Đã mua vào ${GetTimeAgo.parse(DateTime.parse(coursePurchased[index]['updated_at']))}'),
                trailing: TextButton(
                  onPressed: () {},
                  child: const Text('Chat'),
                )),
          ),
        ),
      ],
    );
  }
}
