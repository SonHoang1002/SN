import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/learn_space/learn_space_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/card_components.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/share_modal_bottom.dart';

class LearnSpaceCard extends ConsumerStatefulWidget {
  const LearnSpaceCard({super.key});

  @override
  ConsumerState<LearnSpaceCard> createState() => _LearnSpaceCardState();
}

class _LearnSpaceCardState extends ConsumerState<LearnSpaceCard> {
  bool courseFee = false;
  bool courseNoFee = false;
  late double width;
  late double height;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      _fetchCourseList();
    }
  }

  void _fetchCourseList() {
    ref.read(learnSpaceStateControllerProvider.notifier).getListCourses({
      "exclude_current_user": true,
      "visibility": "public",
      'limit': 10,
      'status': 'approved',
    });
  }

  void _fetchCourseFeeList() {
    ref.read(learnSpaceStateControllerProvider.notifier).getListCourses({
      "exclude_current_user": true,
      "visibility": "public",
      'limit': 10,
      'status': 'approved',
      'free': false,
    });
  }

  void _fetchCourseNoFeeList() {
    ref.read(learnSpaceStateControllerProvider.notifier).getListCourses({
      "exclude_current_user": true,
      "visibility": "public",
      'limit': 10,
      'status': 'approved',
      'free': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    List course = ref.watch(learnSpaceStateControllerProvider).course;
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Text(
                'Khám phá khoá học',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          courseFee = !courseFee;
                          if (courseNoFee) {
                            courseNoFee = false;
                          }
                        });
                        if (!courseFee && !courseNoFee) {
                          _fetchCourseList();
                        }
                        if (courseFee && !courseNoFee) {
                          _fetchCourseFeeList();
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 180,
                        decoration: BoxDecoration(
                            color: courseFee
                                ? secondaryColor
                                : const Color.fromARGB(189, 202, 202, 202),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(width: 0.2, color: greyColor)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Trả phí',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: courseFee
                                      ? Colors.white
                                      : colorWord(context),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ]),
                      )),
                  const SizedBox(width: 22),
                  InkWell(
                    onTap: () {
                      setState(() {
                        courseNoFee = !courseNoFee;
                        if (courseFee) {
                          courseFee = false;
                        }
                      });

                      if (!courseFee && !courseNoFee) {
                        _fetchCourseList();
                      }
                      if (!courseFee && courseNoFee) {
                        _fetchCourseNoFeeList();
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 180,
                      decoration: BoxDecoration(
                          color: courseNoFee
                              ? secondaryColor
                              : const Color.fromARGB(189, 202, 202, 202),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(width: 0.2, color: greyColor)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Miễn phí',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: courseNoFee
                                  ? Colors.white
                                  : colorWord(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            course.isNotEmpty
                ? SizedBox(
                    child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: course.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      if (index < course.length) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                          child: CardComponents(
                            type: 'homeScreen',
                            imageCard: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              child: ImageCacheRender(
                                path: course[index]['banner'] != null
                                    ? course[index]['banner']['url']
                                    : "https://sn.emso.vn/static/media/group_cover.81acfb42.png",
                              ),
                            ),
                            onTap: () {},
                            textCard: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 16.0,
                                  right: 16.0,
                                  left: 16.0,
                                  top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      course[index]['title'],
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w800,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      course[index]['account']['display_name'],
                                      style: const TextStyle(
                                        fontSize: 13.0,
                                        color: greyColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      course[index]['free'] == true
                                          ? 'Miễn phí'
                                          : '${convertNumberToVND(course[index]['price'] ~/ 1)} VNĐ',
                                      style: const TextStyle(
                                        fontSize: 13.0,
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            buttonCard: Container(
                              padding: const EdgeInsets.only(
                                  bottom: 16.0, left: 16.0, right: 16.0),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 32,
                                        width: width * 0.7,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                189, 202, 202, 202),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                width: 0.2, color: greyColor)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(FontAwesomeIcons.solidStar,
                                                color: Colors.black, size: 14),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              'Quan tâm',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 3.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 11.0,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(10),
                                              ),
                                            ),
                                            context: context,
                                            builder: (context) =>
                                                const ShareModalBottom());
                                      },
                                      child: Container(
                                        height: 32,
                                        width: width * 0.12,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                189, 202, 202, 202),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                width: 0.2, color: greyColor)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(FontAwesomeIcons.share,
                                                color: Colors.black, size: 14),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ))
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
