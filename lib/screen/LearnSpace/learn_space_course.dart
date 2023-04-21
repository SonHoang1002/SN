import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/learn_space/learn_space_provider.dart';

class LearnSpaceCourse extends ConsumerStatefulWidget {
  final String? id;
  const LearnSpaceCourse({super.key, this.id});

  @override
  ConsumerState<LearnSpaceCourse> createState() => _LearnSpaceCourseState();
}

class _LearnSpaceCourseState extends ConsumerState<LearnSpaceCourse> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      ref
          .read(learnSpaceStateControllerProvider.notifier)
          .getListCoursesChapter({"limit": 6, "offset": 0}, widget.id);
      // ref
      //     .read(learnSpaceStateControllerProvider.notifier)
      //     .getListCoursesLessonChapter({"chapter_id": widget.id});
    }
  }

  @override
  Widget build(BuildContext context) {
    List courseChapter =
        ref.watch(learnSpaceStateControllerProvider).courseChapter;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: courseChapter.length,
                    itemBuilder: (context, index) {
                      return Text(courseChapter[index]['title']);
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
