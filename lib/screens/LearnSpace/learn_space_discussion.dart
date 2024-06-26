import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/learn_space/learn_space_provider.dart';
import 'package:social_network_app_mobile/screens/Feed/create_post_button.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class LearnSpaceDiscusstion extends ConsumerStatefulWidget {
  final dynamic postDiscussion;
  const LearnSpaceDiscusstion({super.key, this.postDiscussion});

  @override
  ConsumerState<LearnSpaceDiscusstion> createState() =>
      _LearnSpaceDiscusstionState();
}

class _LearnSpaceDiscusstionState extends ConsumerState<LearnSpaceDiscusstion> {
  final scrollController = ScrollController();

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    var paramsListCoursePost = {
      "course_id": widget.postDiscussion['course_id'],
      "exclude_replies": true,
      'limit': 6
    };
    Future.delayed(
        Duration.zero,
        () => ref
            .read(learnSpaceStateControllerProvider.notifier)
            .getListCoursesPosts(
                paramsListCoursePost, widget.postDiscussion['course_id']));
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        String maxId =
            ref.read(learnSpaceStateControllerProvider).coursePosts.last['id'];
        ref
            .read(learnSpaceStateControllerProvider.notifier)
            .getListCoursesPosts({"max_id": maxId, ...paramsListCoursePost},
                widget.postDiscussion['course_id']);
      }
    });
  }

  _reloadFeedFunction(dynamic type, dynamic newData) {
    if (type == null && newData == null) {
      setState(() {});
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(learnSpaceStateControllerProvider.notifier)
          .changeProcessingPostLearnSpace(newData);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List coursePosts = ref.watch(learnSpaceStateControllerProvider).coursePosts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Bài viết',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        CreatePostButton(
          postDiscussion: widget.postDiscussion,
          preType: postLearnSpace,
          reloadFunction: _reloadFeedFunction,
        ),
        _buildDivider(),
        if (coursePosts.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              controller: scrollController,
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              itemCount: coursePosts.length,
              itemBuilder: (context, index) {
                return Post(
                  post: coursePosts[index],
                  type: postLearnSpace,
                );
              }),
        )
        
        else Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 20),
          child: Text("Hiện chưa có cuộc thảo luận nào!", style: TextStyle(color: colorWord(context), fontWeight: FontWeight.bold,)),) 
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 20,
      thickness: 1,
    );
  }
}
