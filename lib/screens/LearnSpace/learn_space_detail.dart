import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/data/event.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/grow/grow_provider.dart';
import 'package:social_network_app_mobile/providers/learn_space/learn_space_provider.dart';
import 'package:social_network_app_mobile/screens/LearnSpace/learn_space_course.dart';
import 'package:social_network_app_mobile/screens/LearnSpace/learn_space_discussion.dart';
import 'package:social_network_app_mobile/screens/LearnSpace/learn_space_faq.dart';
import 'package:social_network_app_mobile/screens/LearnSpace/learn_space_intro.dart';
import 'package:social_network_app_mobile/screens/LearnSpace/learn_space_purchased.dart';
import 'package:social_network_app_mobile/screens/LearnSpace/learn_space_review.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/chip_menu.dart';
import 'package:social_network_app_mobile/widgets/icon_action_ellipsis.dart';
import 'package:social_network_app_mobile/widgets/modal_invite_friend.dart';

import '../../widgets/Loading/tiktok_loading.dart';

class LearnSpaceDetail extends ConsumerStatefulWidget {
  final dynamic data;
  final bool? isUseLearnData;
  const LearnSpaceDetail({super.key, this.data, this.isUseLearnData});

  @override
  ConsumerState<LearnSpaceDetail> createState() => _LearnSpaceDetailState();
}

class _LearnSpaceDetailState extends ConsumerState<LearnSpaceDetail> {
  dynamic courseDetail = {};
  bool isCourseInterested = false;
  String courseMenu = 'intro';
  String currentMenu = 'intro';
  String menuCourse = '';
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
    if (courseDetail.isEmpty && (widget.isUseLearnData == true)) {
      courseDetail = widget.data;
      isCourseInterested =
          courseDetail['course_relationships']['follow_course'];
    } else {
      await ref
          .read(learnSpaceStateControllerProvider.notifier)
          .getDetailCourses(widget.data['id'])
          .then((value) {
        setState(() {
          courseDetail =
              ref.read(learnSpaceStateControllerProvider).detailCourse;
          isCourseInterested =
              courseDetail['course_relationships']['follow_course'];
        });
      });
    }
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
      'key': 'more',
      'label': 'Xem thêm',
      'endIcon': FontAwesomeIcons.chevronDown
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
    courseDetail ??= widget.data;
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
            child: Container(
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
            )),
        elevation: 0.0,
      ),
      body: Stack(
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
                        child: ClipRRect(
                          child: ExtendedImage.network(
                            widget.data['banner'] != null
                                ? widget.data['banner']['preview_url']
                                : linkBannerDefault,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  courseDetail.isNotEmpty && courseDetail['title'] != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                                              ?['host_course'] ==
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
                                                      color:
                                                          const Color.fromARGB(
                                                              189,
                                                              202,
                                                              202,
                                                              202),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      border: Border.all(
                                                          width: 0.2,
                                                          color: greyColor)),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
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
                                                          BorderRadius.circular(
                                                              4),
                                                      border: Border.all(
                                                          width: 0.2,
                                                          color: greyColor)),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                            FontAwesomeIcons
                                                                .solidStar,
                                                            size: 14,
                                                            color:
                                                                isCourseInterested
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black),
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
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
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
                                                  if (courseDetail['price'] !=
                                                      0) {
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
                                                                          color:
                                                                              colorWord(context))),
                                                                  TextSpan(
                                                                      text: convertNumberToVND(courseDetail['price'] ~/
                                                                              1)
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          color: colorWord(
                                                                              context),
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  TextSpan(
                                                                      text:
                                                                          ' VNĐ?',
                                                                      style: TextStyle(
                                                                          color:
                                                                              colorWord(context))),
                                                                ])),
                                                            actions: <CupertinoDialogAction>[
                                                              CupertinoDialogAction(
                                                                isDefaultAction:
                                                                    true,
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
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
                                                                    await ref
                                                                        .read(learnSpaceStateControllerProvider
                                                                            .notifier)
                                                                        .updatePaymentCourse(
                                                                            widget.data['id'],
                                                                            context);
                                                                    setState(
                                                                        () {
                                                                      courseDetail = ref
                                                                          .read(
                                                                              learnSpaceStateControllerProvider)
                                                                          .detailCourse;
                                                                    });
                                                                  } else {
                                                                    Navigator.pop(
                                                                        context);
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (_) {
                                                                          return CupertinoAlertDialog(
                                                                            title:
                                                                                const Text('Thông báo'),
                                                                            content:
                                                                                const Text('Số dư trong ví không đủ để thanh toán khoá học. Vui lòng nạp thêm tiền vào ví để thanh toán khoá học.'),
                                                                            actions: <CupertinoDialogAction>[
                                                                              CupertinoDialogAction(
                                                                                isDefaultAction: true,
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: const Text('Đóng'),
                                                                              ),
                                                                              CupertinoDialogAction(
                                                                                isDefaultAction: true,
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: const Text('Nạp'),
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
                                                                          color:
                                                                              Colors.black)),
                                                                ])),
                                                            actions: <CupertinoDialogAction>[
                                                              CupertinoDialogAction(
                                                                isDefaultAction:
                                                                    true,
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Huỷ'),
                                                              ),
                                                              CupertinoDialogAction(
                                                                isDefaultAction:
                                                                    true,
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  await ref
                                                                      .read(learnSpaceStateControllerProvider
                                                                          .notifier)
                                                                      .updatePaymentCourse(
                                                                          widget
                                                                              .data['id'],
                                                                          context);
                                                                  setState(() {
                                                                    courseDetail = ref
                                                                        .read(
                                                                            learnSpaceStateControllerProvider)
                                                                        .detailCourse;
                                                                  });
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
                                                          BorderRadius.circular(
                                                              4),
                                                      border: Border.all(
                                                          width: 0.2,
                                                          color: greyColor)),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
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
                                                            color:
                                                                Colors.white),
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
                                                          style:
                                                              const TextStyle(
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
                                                          BorderRadius.circular(
                                                              4),
                                                      border: Border.all(
                                                          width: 0.2,
                                                          color: greyColor)),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                            FontAwesomeIcons
                                                                .solidStar,
                                                            size: 14,
                                                            color:
                                                                isCourseInterested
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black),
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
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
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
                                    onTap: () {
                                      showBarModalBottomSheet(
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        context: context,
                                        builder: (context) => Container(
                                          margin: const EdgeInsets.only(
                                              left: 8.0, top: 15.0),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: eGLRModalBtmHeight,
                                          child: Column(
                                            children: [
                                              ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    iconActionEllipsis.length,
                                                itemBuilder: ((context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        if (iconActionEllipsis[
                                                                        index]
                                                                    ['key'] !=
                                                                'save' &&
                                                            iconActionEllipsis[
                                                                        index]
                                                                    ['key'] !=
                                                                'copy') {
                                                          showBarModalBottomSheet(
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .scaffoldBackgroundColor,
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      SizedBox(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        child: ActionEllipsis(
                                                                            menuSelected: iconActionEllipsis[
                                                                                index],
                                                                            type:
                                                                                'event',
                                                                            data:
                                                                                courseDetail),
                                                                      ));
                                                        } else if (iconActionEllipsis[
                                                                index]['key'] ==
                                                            'copy') {
                                                          Clipboard.setData(ClipboardData(
                                                              text: courseDetail
                                                                  ? 'https://sn.emso.vn/event/${courseDetail['id']}/about'
                                                                  : 'https://sn.emso.vn/event/${courseDetail['id']}/discussion'));
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                            content: Text(
                                                                'Sao chép thành công'),
                                                            duration: Duration(
                                                                seconds: 3),
                                                            backgroundColor:
                                                                secondaryColor,
                                                          ));
                                                        } else {
                                                          const SizedBox();
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 4.0,
                                                                bottom: 4.0),
                                                        child: Row(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 18.0,
                                                              backgroundColor:
                                                                  greyColor[
                                                                      350],
                                                              child: Icon(
                                                                iconActionEllipsis[
                                                                        index]
                                                                    ["icon"],
                                                                size: 18.0,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          10.0),
                                                              child: Text(
                                                                  iconActionEllipsis[
                                                                          index]
                                                                      ["label"],
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
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
                                      );
                                    },
                                    child: Container(
                                        height: 35,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                189, 202, 202, 202),
                                            borderRadius:
                                                BorderRadius.circular(4),
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
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: List.generate(
                                    itemChipCourse.sublist(0, 4).length,
                                    (index) {
                                      final isMore = itemChipCourse[index]
                                              ['key'] ==
                                          'more';
                                      final isSelected = menuCourse == ""
                                          ? itemChipCourse[index]['key'] ==
                                              currentMenu
                                          : itemChipCourse[index]['key'] ==
                                              courseMenu;
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            courseMenu =
                                                itemChipCourse[index]['key'];
                                            if (itemChipCourse[index]['key'] !=
                                                'more') {
                                              currentMenu =
                                                  itemChipCourse[index]['key'];
                                            }
                                            if (courseMenu != 'more') {
                                              menuCourse = '';
                                            }
                                          });
                                          if (isMore) {
                                            showBarModalBottomSheet(
                                                context: context,
                                                backgroundColor:
                                                    theme.isDarkMode
                                                        ? Colors.black
                                                        : Colors.white,
                                                builder: (context) => SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.25,
                                                    child: ListView.builder(
                                                        itemCount: itemChipCourse
                                                            .sublist(
                                                                4,
                                                                itemChipCourse
                                                                    .length)
                                                            .length,
                                                        itemBuilder:
                                                            (_, newIndex) =>
                                                                ListTile(
                                                                  title: Text(itemChipCourse.sublist(
                                                                          4,
                                                                          itemChipCourse
                                                                              .length)[newIndex]
                                                                      [
                                                                      'label']),
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      menuCourse =
                                                                          itemChipCourse.sublist(
                                                                              4,
                                                                              itemChipCourse.length)[newIndex]['key'];
                                                                      currentMenu =
                                                                          '';
                                                                    });
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ))));
                                          }
                                        },
                                        child: ChipMenu(
                                          endIcon: isMore
                                              ? Icon(
                                                  itemChipCourse[index]
                                                      ['endIcon'],
                                                  size: 10,
                                                  color:
                                                      isSelected ? white : null)
                                              : const SizedBox(),
                                          isSelected: isSelected,
                                          label: itemChipCourse[index]['label'],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            currentMenu == 'intro'
                                ? LearnSpaceIntro(
                                    courseDetail: courseDetail,
                                  )
                                : const SizedBox.shrink(),
                            currentMenu == 'discussion' &&
                                    (courseDetail['course_relationships']
                                            ?['host_course'] ||
                                        courseDetail['course_relationships']
                                            ['participant_course']) &&
                                    courseDetail['allow_discussion']
                                ? LearnSpaceDiscusstion(postDiscussion: {
                                    "course_id": courseDetail['id']
                                  })
                                : const SizedBox.shrink(),
                            currentMenu == 'course'
                                ? LearnSpaceCourse(id: courseDetail['id'])
                                : const SizedBox.shrink(),
                            menuCourse == 'faq'
                                ? LearnSpaceFAQ(courseDetail: courseDetail)
                                : const SizedBox.shrink(),
                            menuCourse == 'review'
                                ? LearnSpaceReview(courseDetail: courseDetail)
                                : const SizedBox.shrink(),
                            menuCourse == 'course_bought'
                                ? LearnSpacePurchased(
                                    courseDetail: courseDetail)
                                : const SizedBox.shrink(),
                            const SizedBox(height: 70),
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          courseDetail['title'] == null
              ? Center(
                  child: Container(
                    width: 52,
                    height: 30,
                    alignment: Alignment.center,
                    child: const TikTokLoadingAnimation(),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
