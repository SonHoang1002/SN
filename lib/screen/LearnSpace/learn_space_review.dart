import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/providers/learn_space/learn_space_provider.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class LearnSpaceReview extends ConsumerStatefulWidget {
  final dynamic courseDetail;
  const LearnSpaceReview({super.key, this.courseDetail});

  @override
  ConsumerState<LearnSpaceReview> createState() => _LearnSpaceReviewState();
}

class _LearnSpaceReviewState extends ConsumerState<LearnSpaceReview> {
  final TextEditingController reviewController =
      TextEditingController(text: '');
  int point = 5;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(
          Duration.zero,
          () => ref
              .read(learnSpaceStateControllerProvider.notifier)
              .getListCourseReview(widget.courseDetail['id']));
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseReview =
        ref.watch(learnSpaceStateControllerProvider).courseReview;

    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              height: 20,
              thickness: 1,
            ),
            const Text('Xếp hạng khóa học này', style: TextStyle(fontSize: 17)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cho chúng tôi biết suy nghĩ của bạn.',
                  style: TextStyle(fontSize: 14),
                ),
                TextButton(
                    onPressed: () {
                      showBarModalBottomSheet(
                        context: context,
                        builder: (context) => StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return SingleChildScrollView(
                            primary: true,
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom *
                                        0.8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                height: 300,
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: List.generate(
                                        5,
                                        (index) => index < point
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    point = index + 1;
                                                  });
                                                },
                                                child: const Icon(Icons.star,
                                                    size: 35,
                                                    color: Colors.yellow))
                                            : InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    point = index + 1;
                                                  });
                                                },
                                                child: const Icon(
                                                  Icons.star_border,
                                                  size: 35,
                                                  color: greyColor,
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextFormField(
                                      controller: reviewController,
                                      maxLines: 4,
                                      decoration: const InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey, width: 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12))),
                                          hintText: "Đề xuất của bạn",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)))),
                                    ),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(top: 24.0),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: Size(
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  45),
                                              foregroundColor:
                                                  Colors.white, // foreground
                                            ),
                                            onPressed: () async {},
                                            child: const Text('Đánh giá'))),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                    child: const Text('Viết bài đánh giá'))
              ],
            ),
            const Divider(
              height: 20,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  primary: false,
                  itemCount: courseReview.length,
                  itemBuilder: (context, index) {
                    return Post(
                        post: courseReview[index]['comment'],
                        data: courseReview[index],
                        type: 'rating');
                  }),
            )
          ],
        ),
      ),
    );
  }
}
