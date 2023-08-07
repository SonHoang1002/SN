import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/grow/grow_provider.dart';
import 'package:social_network_app_mobile/providers/learn_space/learn_space_provider.dart';
import 'package:social_network_app_mobile/screens/LearnSpace/learn_space_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';
import 'package:social_network_app_mobile/widgets/share_modal_bottom.dart';

import '../../constant/common.dart';
import '../../widgets/skeleton.dart';

class LearnSpaceInvitations extends ConsumerStatefulWidget {
  const LearnSpaceInvitations({Key? key}) : super(key: key);

  @override
  ConsumerState<LearnSpaceInvitations> createState() =>
      _LearnSpaceInvitationsState();
}

class _LearnSpaceInvitationsState extends ConsumerState<LearnSpaceInvitations> {
  late double width;
  late double height;
  var paramsConfigList = {"limit": 10};

  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(Duration.zero, () {
        ref
            .read(learnSpaceStateControllerProvider.notifier)
            .getListCoursesInvitations(paramsConfigList);
        ref.read(growControllerProvider.notifier).getGrowTransactions({});
      });
    }
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        String maxId = ref
            .read(learnSpaceStateControllerProvider)
            .courseInvitations
            .last['id'];
        ref
            .read(learnSpaceStateControllerProvider.notifier)
            .getListCoursesInvitations({"max_id": maxId, ...paramsConfigList});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var transactions = ref.watch(growControllerProvider).growTransactions;
    List courseInvitations =
        ref.watch(learnSpaceStateControllerProvider).courseInvitations;
    bool isMore = ref.watch(learnSpaceStateControllerProvider).isMore;
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Expanded(
        child: RefreshIndicator(
      onRefresh: () async {
        ref
            .read(learnSpaceStateControllerProvider.notifier)
            .getListCoursesInvitations(paramsConfigList);
      },
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Text(
                'Lời mời quan tâm khoá học',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            courseInvitations.isNotEmpty
                ? SizedBox(
                    child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: courseInvitations.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      if (index < courseInvitations.length) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                          child: CardComponents(
                            // type: 'homeScreen',
                            imageCard: SizedBox(
                              height: 180,
                              width: width,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                                child: ExtendedImage.network(
                                  courseInvitations[index]['course']
                                              ['banner'] !=
                                          null
                                      ? courseInvitations[index]['course']
                                          ['banner']['url']
                                      : linkBannerDefault,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => LearnSpaceDetail(
                                          data: courseInvitations[index]
                                              ['course'])));
                            },
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
                                      courseInvitations[index]['course']
                                          ['title'],
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
                                      courseInvitations[index]['course']
                                          ['account']['display_name'],
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: greyColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      courseInvitations[index]['course']
                                                  ['free'] ==
                                              true
                                          ? 'Miễn phí'
                                          : '${convertNumberToVND(courseInvitations[index]['course']['price'] ~/ 1)} VNĐ',
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
                                      onTap: () {
                                        if (!courseInvitations[index]['course']
                                                ['course_relationships']
                                            ['participant_course']) {
                                          if (courseInvitations[index]['course']
                                                  ['price'] !=
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
                                                              text: courseInvitations[
                                                                              index]
                                                                          [
                                                                          'course']
                                                                      [
                                                                      'title'] ??
                                                                  '',
                                                              style: TextStyle(
                                                                color: colorWord(
                                                                    context),
                                                              )),
                                                          TextSpan(
                                                              text: ' với giá ',
                                                              style: TextStyle(
                                                                  color: colorWord(
                                                                      context))),
                                                          TextSpan(
                                                              text: convertNumberToVND(
                                                                      courseInvitations[index]['course']
                                                                              [
                                                                              'price'] ~/
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
                                                    actions: <CupertinoDialogAction>[
                                                      CupertinoDialogAction(
                                                        isDefaultAction: true,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Huỷ'),
                                                      ),
                                                      CupertinoDialogAction(
                                                        isDefaultAction: true,
                                                        onPressed: () async {
                                                          if (transactions[
                                                                  'balance'] >
                                                              courseInvitations[
                                                                              index]
                                                                          [
                                                                          'course']
                                                                      [
                                                                      'price'] ~/
                                                                  1) {
                                                            Navigator.pop(
                                                                context);
                                                            await ref
                                                                .read(learnSpaceStateControllerProvider
                                                                    .notifier)
                                                                .updatePaymentCourse(
                                                                    courseInvitations[
                                                                            index]
                                                                        [
                                                                        'course']['id'],
                                                                    context);
                                                          } else {
                                                            Navigator.pop(
                                                                context);
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (_) {
                                                                  return CupertinoAlertDialog(
                                                                    title: const Text(
                                                                        'Thông báo'),
                                                                    content:
                                                                        const Text(
                                                                            'Số dư trong ví không đủ để thanh toán khoá học. Vui lòng nạp thêm tiền vào ví để thanh toán khoá học.'),
                                                                    actions: <CupertinoDialogAction>[
                                                                      CupertinoDialogAction(
                                                                        isDefaultAction:
                                                                            true,
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: const Text(
                                                                            'Đóng'),
                                                                      ),
                                                                      CupertinoDialogAction(
                                                                        isDefaultAction:
                                                                            true,
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: const Text(
                                                                            'Nạp'),
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
                                                            style:
                                                                 TextStyle(
                                                                    color: colorWord(context)),
                                                            children: [
                                                          TextSpan(
                                                              text: courseInvitations[
                                                                              index]
                                                                          [
                                                                          'course']
                                                                      [
                                                                      'title'] ??
                                                                  '',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                          const TextSpan(
                                                              text: ' không?',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                        ])),
                                                    actions: <CupertinoDialogAction>[
                                                      CupertinoDialogAction(
                                                        isDefaultAction: true,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Huỷ'),
                                                      ),
                                                      CupertinoDialogAction(
                                                        isDefaultAction: true,
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          await ref
                                                              .read(
                                                                  learnSpaceStateControllerProvider
                                                                      .notifier)
                                                              .updatePaymentCourse(
                                                                  courseInvitations[
                                                                          index]
                                                                      [
                                                                      'course']['id'],
                                                                  context);
                                                        },
                                                        child: const Text(
                                                            'Đăng ký'),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                  'Bạn đã tham gia khoá học này!'),
                                              duration: const Duration(
                                                  milliseconds: 1500),
                                              width: 300.0,
                                              // Width of the SnackBar.
                                              padding: const EdgeInsets
                                                      .symmetric(
                                                  horizontal: 8.0,
                                                  vertical:
                                                      16.0 // Inner padding for SnackBar content.
                                                  ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 32,
                                        width: width * 0.35,
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
                                          children: [
                                            Icon(
                                                courseInvitations[index]
                                                        ['course']['free']
                                                    ? FontAwesomeIcons.bookOpen
                                                    : FontAwesomeIcons
                                                        .shoppingCart,
                                                color: Colors.black,
                                                size: 14),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              courseInvitations[index]['course']
                                                      ['free']
                                                  ? 'Đăng ký khoá học'
                                                  : 'Mua khoá học',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
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
                                    width: 8.0,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: InkWell(
                                      onTap: () {
                                        if (courseInvitations[index]['course']
                                                    ['course_relationships']
                                                ['follow_course'] ==
                                            true) {
                                          ref
                                              .read(
                                                  learnSpaceStateControllerProvider
                                                      .notifier)
                                              .updateStatusCourse(
                                                  false,
                                                  courseInvitations[index]
                                                      ['course']['id']);
                                          setState(() {
                                            courseInvitations[index]['course']
                                                    ['course_relationships']
                                                ['follow_course'] = false;
                                          });
                                        } else {
                                          ref
                                              .read(
                                                  learnSpaceStateControllerProvider
                                                      .notifier)
                                              .updateStatusCourse(
                                                  true,
                                                  courseInvitations[index]
                                                      ['course']['id']);
                                          setState(() {
                                            courseInvitations[index]['course']
                                                    ['course_relationships']
                                                ['follow_course'] = true;
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 32,
                                        width: width * 0.35,
                                        decoration: BoxDecoration(
                                            color: courseInvitations[index]
                                                            ['course']
                                                        ['course_relationships']
                                                    ['follow_course']
                                                ? secondaryColor
                                                : const Color.fromARGB(
                                                    189, 202, 202, 202),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                width: 0.2, color: greyColor)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(FontAwesomeIcons.solidStar,
                                                color: courseInvitations[index]
                                                                ['course'][
                                                            'course_relationships']
                                                        ['follow_course']
                                                    ? Colors.white
                                                    : Colors.black,
                                                size: 14),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              'Quan tâm',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: courseInvitations[index]
                                                                ['course'][
                                                            'course_relationships']
                                                        ['follow_course']
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w700,
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
                                    width: 8.0,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(10),
                                            ),
                                          ),
                                          context: context,
                                          builder: (context) =>
                                              ShareModalBottom(
                                                  type: 'course',
                                                  data:
                                                      courseInvitations[index]),
                                        );
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
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
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
                        return null;
                      }
                    },
                  ))
                : const SizedBox(),
            isMore == true
                ? Center(child: SkeletonCustom().eventSkeleton(context))
                : courseInvitations.isEmpty
                    ? Column(
                        children: [
                          Center(
                            child: Image.asset(
                              "assets/wow-emo-2.gif",
                              height: 125.0,
                              width: 125.0,
                            ),
                          ),
                          const Text('Không tìm thấy kết quả nào'),
                        ],
                      )
                    : const SizedBox(),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
