import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/learn_space/learn_space_provider.dart';
import 'package:social_network_app_mobile/screen/LearnSpace/learn_space_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/feed_video.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/flick_multiple_manager.dart';
import 'package:social_network_app_mobile/widget/card_components.dart';
import 'package:social_network_app_mobile/widget/share_modal_bottom.dart';
import 'package:social_network_app_mobile/widget/text_readmore.dart';

import '../../constant/common.dart';

class LearnSpaceIntro extends ConsumerStatefulWidget {
  final dynamic courseDetail;
  const LearnSpaceIntro({super.key, required this.courseDetail});

  @override
  ConsumerState<LearnSpaceIntro> createState() => _LearnSpaceIntroState();
}

class _LearnSpaceIntroState extends ConsumerState<LearnSpaceIntro> {
  late FlickMultiManager flickMultiManager;

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    flickMultiManager = FlickMultiManager();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var courseDetail = widget.courseDetail;
    List coursePropose =
        ref.watch(learnSpaceStateControllerProvider).coursePropose;
    List courseSimilar =
        ref.watch(learnSpaceStateControllerProvider).courseSimilar;
    final theme = pv.Provider.of<ThemeManager>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDivider(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                'Thông tin chung',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Row(
              children: [
                CourseRow(
                  leadingIcon: Icons.access_alarm,
                  title: 'Học phí',
                  subtitle: courseDetail['price'] ~/ 1 == 0
                      ? 'Miễn phí'
                      : shortenNumber(courseDetail['price'] ~/ 1),
                ),
                CourseRow(
                  leadingIcon: Icons.access_time,
                  title: 'Số người quan tâm',
                  subtitle: '${courseDetail['followers_count']}',
                ),
              ],
            ),
            Row(
              children: [
                CourseRow(
                  leadingIcon: Icons.account_balance,
                  title: 'Đối tượng',
                  subtitle: courseDetail['age_restrictions'] == 'all'
                      ? 'Trẻ em và Người lớn'
                      : courseDetail['age_restrictions'] == 'adult'
                          ? 'Người lớn'
                          : 'Trẻ em',
                ),
                CourseRow(
                    leadingIcon: Icons.account_box,
                    title: 'Đánh giá',
                    star: courseDetail['rating']),
              ],
            ),
          ],
        ),
        _buildDivider(),
        CategoryWidget(
          title: 'Mô tả khoá học',
          content: courseDetail['description_course'],
          isReadMore: true,
        ),
        _buildDivider(),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin giảng viên',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                    height: 340,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 10),
                      child: CardComponents(
                        imageCard: Column(
                          children: [
                            courseDetail['page_owner'] != null
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                    child: ExtendedImage.network(
                                        courseDetail['page_owner'] != null
                                            ? courseDetail['page_owner']
                                                ['avatar_media']['preview_url']
                                            : courseDetail['page_owner']
                                                ['avatar_media']['show_url'],
                                        fit: BoxFit.cover,
                                        height: 180.0,
                                        width:
                                            MediaQuery.of(context).size.width),
                                  )
                                : ClipOval(
                                    child: ExtendedImage.network(
                                      courseDetail['account']['avatar_media'] !=
                                              null
                                          ? courseDetail['account']
                                              ['avatar_media']['url']
                                          : courseDetail['account']
                                              ['avatar_static'],
                                      fit: BoxFit.cover,
                                      width: 180.0,
                                      height: 180.0,
                                    ),
                                  ),
                          ],
                        ),
                        textCard: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  courseDetail['account']['display_name'] ?? "",
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              height: 20,
                            ),
                          ],
                        ),
                        buttonCard: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 35,
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(189, 202, 202, 202),
                                  borderRadius: BorderRadius.circular(6),
                                  border:
                                      Border.all(width: 0.2, color: greyColor)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    FontAwesomeIcons.user,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    'Xem',
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
                      ),
                    )),
              ],
            ),
          ),
        ),
        courseDetail['introduction_video'] != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDivider(),
                  Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: const Text(
                      'Video giới thiệu',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: SizedBox(
                      height: courseDetail['introduction_video'] != null &&
                              courseDetail['introduction_video']['meta'] !=
                                  null &&
                              courseDetail['introduction_video']['meta']
                                      ['small'] !=
                                  null
                          ? courseDetail['introduction_video']['meta']['small']
                                      ['aspect'] <
                                  0.58
                              ? MediaQuery.of(context).size.height - 66
                              : null
                          : 200,
                      width: 500,
                      child: FeedVideo(
                          type: 'showFullScreen',
                          path: courseDetail['introduction_video'] != null
                              ? courseDetail['introduction_video']
                                              ['remote_url'] !=
                                          "pending" &&
                                      courseDetail['introduction_video']
                                              ['remote_url'] !=
                                          null
                                  ? courseDetail['introduction_video']
                                      ['remote_url']
                                  : courseDetail['introduction_video']
                                      ['show_url']
                              : "",
                          flickMultiManager: flickMultiManager,
                          image: courseDetail['introduction_video'] != null &&
                                  courseDetail['introduction_video']
                                          ['preview_url'] !=
                                      null
                              ? courseDetail['introduction_video']
                                  ['preview_url']
                              : courseDetail['introduction_video']['show_url']),
                    ),
                  ),
                ],
              )
            : const SizedBox(),
        coursePropose.isNotEmpty
            ? Column(
                children: [
                  _buildDivider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Khoá học đề xuất',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 380,
                          child: ListView.builder(
                              itemCount: coursePropose.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, indexPropose) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: CardComponents(
                                    imageCard: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15)),
                                          child: ExtendedImage.network(
                                            coursePropose[indexPropose]
                                                        ['banner'] !=
                                                    null
                                                ? coursePropose[indexPropose]
                                                    ['banner']['preview_url']
                                                : linkBannerDefault,
                                            fit: BoxFit.cover,
                                            height: 180.0,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  LearnSpaceDetail(
                                                      data: coursePropose[
                                                          indexPropose])));
                                    },
                                    textCard: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 16.0,
                                          right: 16.0,
                                          left: 16.0,
                                          top: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            child: Text(
                                              '${coursePropose[indexPropose]['title']}',
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w800,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 40,
                                            child: Text(
                                              '${coursePropose[indexPropose]['account']['display_name']}',
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: greyColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                            child: Text(
                                              coursePropose[indexPropose]
                                                          ['price'] ==
                                                      0
                                                  ? 'Miễn Phí'
                                                  : '${convertNumberToVND(coursePropose[indexPropose]['price'] ~/ 1)}',
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: secondaryColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    buttonCard: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16.0),
                                      child: Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: InkWell(
                                              onTap: () {
                                                if (coursePropose[indexPropose][
                                                            'course_relationships']
                                                        ['follow_course'] ==
                                                    true) {
                                                  ref
                                                      .read(
                                                          learnSpaceStateControllerProvider
                                                              .notifier)
                                                      .updateStatusCourse(
                                                          false,
                                                          coursePropose[
                                                                  indexPropose]
                                                              ['id']);
                                                  setState(() {
                                                    coursePropose[indexPropose][
                                                            'course_relationships']
                                                        [
                                                        'follow_course'] = false;
                                                  });
                                                } else {
                                                  ref
                                                      .read(
                                                          learnSpaceStateControllerProvider
                                                              .notifier)
                                                      .updateStatusCourse(
                                                          true,
                                                          coursePropose[
                                                                  indexPropose]
                                                              ['id']);
                                                  setState(() {
                                                    coursePropose[indexPropose][
                                                            'course_relationships']
                                                        [
                                                        'follow_course'] = true;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                height: 33,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.37,
                                                decoration: BoxDecoration(
                                                    color: coursePropose[
                                                                        indexPropose]
                                                                    [
                                                                    'course_relationships']
                                                                [
                                                                'follow_course'] ==
                                                            true
                                                        ? secondaryColor
                                                        : const Color.fromARGB(
                                                            189, 202, 202, 202),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    border: Border.all(
                                                        width: 0.2,
                                                        color: greyColor)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                        FontAwesomeIcons
                                                            .solidStar,
                                                        color: coursePropose[
                                                                            indexPropose]
                                                                        [
                                                                        'course_relationships']
                                                                    [
                                                                    'follow_course'] ==
                                                                true
                                                            ? Colors.white
                                                            : Colors.black,
                                                        size: 14),
                                                    const SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Text(
                                                      'Quan tâm',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: coursePropose[
                                                                            indexPropose]
                                                                        [
                                                                        'course_relationships']
                                                                    [
                                                                    'follow_course'] ==
                                                                true
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    const SizedBox(
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
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        top:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    context: context,
                                                    builder: (context) =>
                                                        const ShareModalBottom());
                                              },
                                              child: Container(
                                                height: 33,
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.1 -
                                                    2.3,
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        189, 202, 202, 202),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    border: Border.all(
                                                        width: 0.2,
                                                        color: greyColor)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(FontAwesomeIcons.share,
                                                        color: Colors.black,
                                                        size: 14),
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
                              }),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
        courseSimilar.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDivider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Khoá học tương tự',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 380,
                          child: ListView.builder(
                              itemCount: courseSimilar.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, indexSimilar) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: CardComponents(
                                    imageCard: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15)),
                                          child: ExtendedImage.network(
                                            courseSimilar[indexSimilar]
                                                        ['banner'] !=
                                                    null
                                                ? courseSimilar[indexSimilar]
                                                    ['banner']['preview_url']
                                                : linkBannerDefault,
                                            fit: BoxFit.cover,
                                            height: 180.0,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  LearnSpaceDetail(
                                                      data: courseSimilar[
                                                          indexSimilar])));
                                    },
                                    textCard: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 16.0,
                                          right: 16.0,
                                          left: 16.0,
                                          top: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            child: Text(
                                              '${courseSimilar[indexSimilar]['title']}',
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w800,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 40,
                                            child: Text(
                                              '${courseSimilar[indexSimilar]['account']['display_name']}',
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: greyColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                            child: Text(
                                              courseSimilar[indexSimilar]
                                                          ['price'] ==
                                                      0
                                                  ? 'Miễn Phí'
                                                  : '${convertNumberToVND(courseSimilar[indexSimilar]['price'] ~/ 1)}',
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: secondaryColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    buttonCard: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16.0),
                                      child: Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: InkWell(
                                              onTap: () {
                                                if (courseSimilar[indexSimilar][
                                                            'course_relationships']
                                                        ['follow_course'] ==
                                                    true) {
                                                  ref
                                                      .read(
                                                          learnSpaceStateControllerProvider
                                                              .notifier)
                                                      .updateStatusCourse(
                                                          false,
                                                          courseSimilar[
                                                                  indexSimilar]
                                                              ['id']);
                                                  setState(() {
                                                    courseSimilar[indexSimilar][
                                                            'course_relationships']
                                                        [
                                                        'follow_course'] = false;
                                                  });
                                                } else {
                                                  ref
                                                      .read(
                                                          learnSpaceStateControllerProvider
                                                              .notifier)
                                                      .updateStatusCourse(
                                                          true,
                                                          courseSimilar[
                                                                  indexSimilar]
                                                              ['id']);
                                                  setState(() {
                                                    courseSimilar[indexSimilar][
                                                            'course_relationships']
                                                        [
                                                        'follow_course'] = true;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                height: 33,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.37,
                                                decoration: BoxDecoration(
                                                    color: courseSimilar[
                                                                        indexSimilar]
                                                                    [
                                                                    'course_relationships']
                                                                [
                                                                'follow_course'] ==
                                                            true
                                                        ? secondaryColor
                                                        : const Color.fromARGB(
                                                            189, 202, 202, 202),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    border: Border.all(
                                                        width: 0.2,
                                                        color: greyColor)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                        FontAwesomeIcons
                                                            .solidStar,
                                                        color: courseSimilar[
                                                                            indexSimilar]
                                                                        [
                                                                        'course_relationships']
                                                                    [
                                                                    'follow_course'] ==
                                                                true
                                                            ? Colors.white
                                                            : Colors.black,
                                                        size: 14),
                                                    const SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Text(
                                                      'Quan tâm',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: courseSimilar[
                                                                            indexSimilar]
                                                                        [
                                                                        'course_relationships']
                                                                    [
                                                                    'follow_course'] ==
                                                                true
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    const SizedBox(
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
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        top:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    context: context,
                                                    builder: (context) =>
                                                        const ShareModalBottom());
                                              },
                                              child: Container(
                                                height: 33,
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.1 -
                                                    2.3,
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        189, 202, 202, 202),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    border: Border.all(
                                                        width: 0.2,
                                                        color: greyColor)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(FontAwesomeIcons.share,
                                                        color: Colors.black,
                                                        size: 14),
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
                              }),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 20,
      indent: 15,
      endIndent: 15,
      thickness: 1,
    );
  }
}

class CourseRow extends StatefulWidget {
  final IconData leadingIcon;
  final String title;
  final subtitle;
  final star;
  const CourseRow({
    Key? key,
    required this.leadingIcon,
    required this.title,
    this.subtitle,
    this.star,
  }) : super(key: key);

  @override
  State<CourseRow> createState() => _CourseRowState();
}

class _CourseRowState extends State<CourseRow> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 0.0,
        ),
        visualDensity: const VisualDensity(
          horizontal: -4,
          vertical: -2,
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
          child: Icon(widget.leadingIcon),
        ),
        title: Text(widget.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        subtitle: widget.star == null
            ? Text(widget.subtitle, style: const TextStyle(fontSize: 12))
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                    5,
                    (index) => index < widget.star
                        ? const Icon(Icons.star, size: 20, color: Colors.yellow)
                        : const Icon(
                            Icons.star_border,
                            size: 20,
                            color: greyColor,
                          ))),
      ),
    );
  }
}

class CategoryWidget extends StatefulWidget {
  final String title;
  final String content;
  final bool isReadMore;

  const CategoryWidget(
      {Key? key,
      required this.title,
      required this.content,
      required this.isReadMore})
      : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  bool isReadMoreList = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: !widget.isReadMore
              ? Text(
                  widget.content,
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                )
              : TextReadMore(
                  description: widget.content,
                  isReadMore: isReadMoreList,
                  fontSize: 14.0,
                  onTap: () {
                    setState(() {
                      isReadMoreList = !isReadMoreList;
                    });
                  },
                ),
        ),
      ],
    );
  }
}
