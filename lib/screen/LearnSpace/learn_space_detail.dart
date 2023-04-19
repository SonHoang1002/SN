import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/grow/grow_provider.dart';
import 'package:social_network_app_mobile/providers/learn_space/learn_space_provider.dart';
import 'package:social_network_app_mobile/screen/LearnSpace/learn_space_intro.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/chip_menu.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/modal_invite_friend.dart';

class LearnSpaceDetail extends ConsumerStatefulWidget {
  final dynamic data;
  const LearnSpaceDetail({
    super.key,
    this.data,
  });

  @override
  ConsumerState<LearnSpaceDetail> createState() => _LearnSpaceDetailState();
}

class _LearnSpaceDetailState extends ConsumerState<LearnSpaceDetail> {
  dynamic courseDetail = {};
  bool isCourseInterested = false;
  String courseMenu = 'intro';
  @override
  void initState() {
    super.initState();
    if (mounted) {
      loadData();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadData() async {
    await ref
        .read(learnSpaceStateControllerProvider.notifier)
        .getDetailCourses(widget.data['id']);
    await ref
        .read(learnSpaceStateControllerProvider.notifier)
        .getListCoursesSimilar({'only_current_user': true, 'limit': 5});
    await ref
        .read(learnSpaceStateControllerProvider.notifier)
        .getListCoursesPropose({
      'status': 'approved',
      'exclude_current_user': true,
      'limit': 5,
      'visibility': 'public'
    });
    await ref.read(growControllerProvider.notifier).getGrowTransactions({});
    setState(() {
      courseDetail = ref.read(learnSpaceStateControllerProvider).detailCourse;
    });
  }

  List itemChipCourse = [
    {
      'key': 'intro',
      'label': 'Giới thiệu',
    },
    {
      'key': 'discussion',
      'label': 'Thảo luận',
    },
    {
      'key': 'course',
      'label': 'Bài học',
    },
    {
      'key': 'faq',
      'label': 'FAQ',
    },
    {
      'key': 'review',
      'label': 'Đánh giá',
    },
    {
      'key': 'course_bought',
      'label': 'Danh sách đã mua',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    var transactions = ref.watch(growControllerProvider).growTransactions;
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pop(context);
          },
          child: courseDetail['title'] != null
              ? Container(
                  height: 26,
                  width: 26,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(width: 0.2, color: greyColor)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(FontAwesomeIcons.angleLeft,
                          color: Colors.white, size: 16),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
        elevation: 0.0,
      ),
      body: courseDetail['title'] != null
          ? Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    ref
                        .read(learnSpaceStateControllerProvider.notifier)
                        .getDetailCourses(widget.data['id']);
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              child: Hero(
                                tag: courseDetail['banner']['url'] ??
                                    "https://sn.emso.vn/static/media/group_cover.81acfb42.png",
                                child: ClipRRect(
                                  child: ImageCacheRender(
                                    path: courseDetail['banner']['url'] ?? "",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  courseDetail['title'],
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 8.0),
                          child: Row(
                            children: [
                              courseDetail['course_relationships']
                                          ['host_course'] ==
                                      true
                                  ? Row(
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: Container(
                                              height: 35,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      189, 202, 202, 202),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  border: Border.all(
                                                      width: 0.2,
                                                      color: greyColor)),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Text(
                                                      'Quảng cáo',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ])),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showBarModalBottomSheet(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                context: context,
                                                builder: (context) =>
                                                    const InviteFriend());
                                          },
                                          child: Container(
                                              height: 35,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              decoration: BoxDecoration(
                                                  color: isCourseInterested
                                                      ? secondaryColor
                                                      : const Color.fromARGB(
                                                          189, 202, 202, 202),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
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
                                                        size: 14,
                                                        color:
                                                            isCourseInterested
                                                                ? Colors.white
                                                                : Colors.black),
                                                    const SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Text(
                                                      'Mời',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color:
                                                            isCourseInterested
                                                                ? Colors.white
                                                                : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ])),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (!courseDetail[
                                                    'course_relationships']
                                                ['participant_course']) {
                                              if (courseDetail['price'] != 0) {
                                                showDialog(
                                                    context: context,
                                                    builder: (_) {
                                                      return CupertinoAlertDialog(
                                                        title: const Text(
                                                            'Xác nhận thanh toán'),
                                                        content: RichText(
                                                            text: TextSpan(
                                                                text:
                                                                    'Bạn có muốn thanh toán khoá học ',
                                                                style: TextStyle(
                                                                    color: colorWord(
                                                                        context)),
                                                                children: [
                                                              TextSpan(
                                                                  text: courseDetail[
                                                                          'title'] ??
                                                                      '',
                                                                  style:
                                                                      TextStyle(
                                                                    color: colorWord(
                                                                        context),
                                                                  )),
                                                              TextSpan(
                                                                  text:
                                                                      ' với giá ',
                                                                  style: TextStyle(
                                                                      color: colorWord(
                                                                          context))),
                                                              TextSpan(
                                                                  text: convertNumberToVND(
                                                                          courseDetail['price'] ~/
                                                                              1)
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: colorWord(
                                                                          context),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              TextSpan(
                                                                  text: ' VNĐ?',
                                                                  style: TextStyle(
                                                                      color: colorWord(
                                                                          context))),
                                                            ])),
                                                        actions: <
                                                            CupertinoDialogAction>[
                                                          CupertinoDialogAction(
                                                            isDefaultAction:
                                                                true,
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'Huỷ'),
                                                          ),
                                                          CupertinoDialogAction(
                                                            isDefaultAction:
                                                                true,
                                                            onPressed:
                                                                () async {
                                                              if (transactions[
                                                                      'balance'] >
                                                                  courseDetail[
                                                                          'price'] ~/
                                                                      1) {
                                                                Navigator.pop(
                                                                    context);
                                                                final result = await ref
                                                                    .read(learnSpaceStateControllerProvider
                                                                        .notifier)
                                                                    .updatePaymentCourse(
                                                                        widget.data[
                                                                            'id']);
                                                                if (result) {
                                                                  setState(() {
                                                                    courseDetail = ref
                                                                        .read(
                                                                            learnSpaceStateControllerProvider)
                                                                        .detailCourse;
                                                                  });
                                                                }
                                                              } else {
                                                                Navigator.pop(
                                                                    context);
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (_) {
                                                                      return CupertinoAlertDialog(
                                                                        title: const Text(
                                                                            'Thông báo'),
                                                                        content:
                                                                            const Text('Số dư trong ví không đủ để thanh toán khoá học. Vui lòng nạp thêm tiền vào ví để thanh toán khoá học.'),
                                                                        actions: <
                                                                            CupertinoDialogAction>[
                                                                          CupertinoDialogAction(
                                                                            isDefaultAction:
                                                                                true,
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                const Text('Đóng'),
                                                                          ),
                                                                          CupertinoDialogAction(
                                                                            isDefaultAction:
                                                                                true,
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                const Text('Nạp'),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    });
                                                              }
                                                            },
                                                            child: const Text(
                                                                'Thanh toán'),
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder: (_) {
                                                      return CupertinoAlertDialog(
                                                        title: const Text(
                                                            'Xác nhận đăng ký khoá học'),
                                                        content: RichText(
                                                            text: TextSpan(
                                                                text:
                                                                    'Bạn có muốn đăng ký khoá học ',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                                children: [
                                                              TextSpan(
                                                                  text: courseDetail[
                                                                          'title'] ??
                                                                      '',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                  )),
                                                              const TextSpan(
                                                                  text:
                                                                      ' không?',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black)),
                                                            ])),
                                                        actions: <
                                                            CupertinoDialogAction>[
                                                          CupertinoDialogAction(
                                                            isDefaultAction:
                                                                true,
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'Huỷ'),
                                                          ),
                                                          CupertinoDialogAction(
                                                            isDefaultAction:
                                                                true,
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                              final result = await ref
                                                                  .read(learnSpaceStateControllerProvider
                                                                      .notifier)
                                                                  .updatePaymentCourse(
                                                                      widget.data[
                                                                          'id']);
                                                              if (result) {
                                                                setState(() {
                                                                  courseDetail = ref
                                                                      .read(
                                                                          learnSpaceStateControllerProvider)
                                                                      .detailCourse;
                                                                });
                                                              }
                                                            },
                                                            child: const Text(
                                                                'Đăng ký'),
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              }
                                            }
                                          },
                                          child: Container(
                                              height: 35,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              decoration: BoxDecoration(
                                                  color: secondaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  border: Border.all(
                                                      width: 0.2,
                                                      color: greyColor)),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                        courseDetail[
                                                                    'course_relationships']
                                                                [
                                                                'participant_course']
                                                            ? FontAwesomeIcons
                                                                .circleCheck
                                                            : courseDetail[
                                                                        'price'] !=
                                                                    0
                                                                ? FontAwesomeIcons
                                                                    .shoppingCart
                                                                : FontAwesomeIcons
                                                                    .bookOpen,
                                                        size: 14,
                                                        color: Colors.white),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      courseDetail[
                                                                  'course_relationships']
                                                              [
                                                              'participant_course']
                                                          ? 'Đã tham gia'
                                                          : courseDetail[
                                                                      'price'] !=
                                                                  0
                                                              ? 'Mua khoá học'
                                                              : 'Đăng ký học',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ])),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              isCourseInterested =
                                                  !isCourseInterested;
                                            });
                                            ref
                                                .read(
                                                    learnSpaceStateControllerProvider
                                                        .notifier)
                                                .updateStatusCourse(
                                                    isCourseInterested,
                                                    widget.data['id']);
                                          },
                                          child: Container(
                                              height: 35,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.37,
                                              decoration: BoxDecoration(
                                                  color: isCourseInterested
                                                      ? secondaryColor
                                                      : const Color.fromARGB(
                                                          189, 202, 202, 202),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
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
                                                        size: 14,
                                                        color:
                                                            isCourseInterested
                                                                ? Colors.white
                                                                : Colors.black),
                                                    const SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Text(
                                                      'Quan tâm',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color:
                                                            isCourseInterested
                                                                ? Colors.white
                                                                : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ])),
                                        ),
                                      ],
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            189, 202, 202, 202),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            width: 0.2, color: greyColor)),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(FontAwesomeIcons.ellipsis,
                                              size: 14)
                                        ])),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: List.generate(
                                  itemChipCourse.length,
                                  (index) => InkWell(
                                        onTap: () {
                                          setState(() {
                                            courseMenu =
                                                itemChipCourse[index]['key'];
                                          });
                                        },
                                        child: ChipMenu(
                                            isSelected: courseMenu ==
                                                itemChipCourse[index]['key'],
                                            label: itemChipCourse[index]
                                                ['label']),
                                      )),
                            ),
                          ),
                        ),
                        courseMenu == 'intro'
                            ? LearnSpaceIntro(
                                courseDetail: courseDetail,
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 70),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CupertinoActivityIndicator(),
            ),
    );
  }
}
