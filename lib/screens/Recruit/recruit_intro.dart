import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/recruit/recruit_provider.dart';
import 'package:social_network_app_mobile/screens/Recruit/recuit_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';
import 'package:social_network_app_mobile/widgets/share_modal_bottom.dart';
import 'package:social_network_app_mobile/widgets/text_readmore.dart';

import '../Page/PageDetail/page_detail.dart';
import '../UserPage/user_page.dart';

class RecruitIntro extends ConsumerStatefulWidget {
  final dynamic recruitDetail;
  const RecruitIntro({super.key, required this.recruitDetail});

  @override
  ConsumerState<RecruitIntro> createState() => _RecruitIntroState();
}

class _RecruitIntroState extends ConsumerState<RecruitIntro> {
  @override
  Widget build(BuildContext context) {
    var recruitDetail = widget.recruitDetail;
    List recruitsPropose = ref.watch(recruitControllerProvider).recruitsPropose;
    List recruitsSimilar = ref.watch(recruitControllerProvider).recruitsSimilar;
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
                RecruitmentRow(
                  leadingIcon: Icons.access_alarm,
                  title: 'Mức lương',
                  subtitle:
                      'Từ ${shortenNumber(recruitDetail?['salary_min'] ~/ 1)} - ${shortenNumber(recruitDetail?['salary_max'] ~/ 1)}',
                ),
                RecruitmentRow(
                  leadingIcon: Icons.access_time,
                  title: 'Số lượng tuyển',
                  subtitle: '${recruitDetail['recruitments_count']}',
                ),
              ],
            ),
            Row(
              children: [
                RecruitmentRow(
                  leadingIcon: Icons.account_balance,
                  title: 'Hình thức làm việc',
                  subtitle: recruitDetail['working_form'] == 'internship'
                      ? 'Thực tập'
                      : recruitDetail['working_form'] == 'fulltime'
                          ? 'Toàn thời gian'
                          : recruitDetail['parttime'] == 'fulltime'
                              ? 'Bán thời gian'
                              : 'Làm từ xa',
                ),
                RecruitmentRow(
                  leadingIcon: Icons.account_box,
                  title: 'Cấp bậc',
                  subtitle: recruitDetail['level'] == 'intership'
                      ? 'Thực tập sinh'
                      : recruitDetail['level'] == 'staff'
                          ? 'Nhân viên'
                          : recruitDetail['level'] == 'leader'
                              ? 'Trưởng phòng'
                              : 'Quản lý',
                ),
              ],
            ),
            Row(
              children: [
                RecruitmentRow(
                  leadingIcon: Icons.add_alarm,
                  title: 'Giới tính',
                  subtitle: recruitDetail['gender'] == 'all'
                      ? 'Không yêu cầu'
                      : recruitDetail['gender'] == 'men'
                          ? 'Nam'
                          : 'Nữ',
                ),
                RecruitmentRow(
                  leadingIcon: Icons.add_circle,
                  title: 'Kinh nghiệm',
                  subtitle: recruitDetail['work_experience'],
                ),
              ],
            ),
          ],
        ),
        _buildDivider(),
        CategoryWidget(
          title: 'Vị trí ứng tuyển',
          content: recruitDetail['recruit_category']['text'],
          isReadMore: false,
        ),
        _buildDivider(),
        CategoryWidget(
          title: 'Mô tả công việc',
          content: recruitDetail['job_description'],
          isReadMore: true,
        ),
        _buildDivider(),
        CategoryWidget(
          title: 'Yêu cầu ứng viên',
          content: recruitDetail['requirement'],
          isReadMore: true,
        ),
        _buildDivider(),
        CategoryWidget(
          title: 'Quyền lợi',
          content: recruitDetail['benefits'],
          isReadMore: true,
        ),
        _buildDivider(),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin nhà tuyển dụng',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                    height: 340,
                    child: Container(
                      width: MediaQuery.sizeOf(context).width,
                      margin: const EdgeInsets.only(top: 10),
                      child: CardComponents(
                        imageCard: Column(
                          children: [
                            recruitDetail['page_owner'] != null
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                    child: ExtendedImage.network(
                                      recruitDetail['page_owner']['banner'] !=
                                              null
                                          ? recruitDetail['page_owner']
                                              ['avatar_media']['preview_url']
                                          : recruitDetail['page_owner']
                                              ['avatar_media']['show_url'],
                                      fit: BoxFit.cover,
                                      width: MediaQuery.sizeOf(context).width,
                                      height: 180.0,
                                    ),
                                  )
                                : Center(
                                    child: ClipOval(
                                      child: ExtendedImage.network(
                                        recruitDetail['account']
                                                    ['avatar_media'] !=
                                                null
                                            ? recruitDetail['account']['avatar_media']['url'] ?? recruitDetail['account']['avatar_media']['preview_url']
                                            : recruitDetail['account']['avatar_static'],
                                        fit: BoxFit.cover,
                                        width: 180.0,
                                        height: 180.0,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        onTap: () {
                          recruitDetail['page_owner'] != null
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PageDetail(),
                                    settings: RouteSettings(
                                        arguments: recruitDetail['page_owner']
                                                ['id']
                                            .toString()),
                                  ))
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const UserPageHome(),
                                    settings: RouteSettings(
                                      arguments: {
                                        'id': recruitDetail['account']['id'],
                                        "user":recruitDetail['account']
                                      },
                                    ),
                                  ));
                        },
                        textCard: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  recruitDetail['account']['display_name'] ??
                                      "",
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
                            child: InkWell(
                              onTap: () {
                                recruitDetail['page_owner'] != null
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const PageDetail(),
                                          settings: RouteSettings(
                                              arguments:
                                                  recruitDetail['page_owner']
                                                          ['id']
                                                      .toString()),
                                        ))
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const UserPageHome(),
                                          settings: RouteSettings(
                                            arguments: {
                                              'id': recruitDetail['account']
                                                  ['id'],"user":recruitDetail['account']
                                            },
                                          ),
                                        ));
                              },
                              child: Container(
                                height: 35,
                                width: MediaQuery.sizeOf(context).width * 0.8,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        189, 202, 202, 202),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        width: 0.2, color: greyColor)),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
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
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
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
                      ),
                    )),
              ],
            ),
          ),
        ),
        recruitsPropose.isNotEmpty
            ? Column(
                children: [
                  _buildDivider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Việc làm đề xuất',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 380,
                          child: ListView.builder(
                              itemCount: recruitsPropose.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, indexPropose) {
                                return Container(
                                  width: MediaQuery.sizeOf(context).width * 0.6,
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
                                            recruitsPropose[indexPropose]
                                                        ['banner'] !=
                                                    null
                                                ? recruitsPropose[indexPropose]
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
                                                  RecruitDetail(
                                                      data: recruitsPropose[
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
                                            height: 30,
                                            child: Text(
                                              '${recruitsPropose[indexPropose]['title']}',
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w800,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                            child: Text(
                                              '${recruitsPropose[indexPropose]['account']['display_name']}',
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: greyColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                            child: Text(
                                              '${convertNumberToVND(recruitsPropose[indexPropose]['salary_min'] ~/ 1)}'
                                              ' - '
                                              '${convertNumberToVND(recruitsPropose[indexPropose]['salary_max'] ~/ 1)} VNĐ',
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: greyColor,
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
                                                if (recruitsPropose[
                                                                indexPropose][
                                                            'recruit_relationships']
                                                        ['follow_recruit'] ==
                                                    true) {
                                                  setState(() {
                                                    recruitsPropose[
                                                                indexPropose][
                                                            'recruit_relationships']
                                                        [
                                                        'follow_recruit'] = false;
                                                    ref
                                                        .read(
                                                            recruitControllerProvider
                                                                .notifier)
                                                        .updateStatusRecruit(
                                                            false,
                                                            recruitsPropose[
                                                                    indexPropose]
                                                                ['id'],
                                                            name:
                                                                'recruitsPropose');
                                                  });
                                                } else {
                                                  setState(() {
                                                    recruitsPropose[
                                                                indexPropose][
                                                            'recruit_relationships']
                                                        [
                                                        'follow_recruit'] = true;
                                                    ref
                                                        .read(
                                                            recruitControllerProvider
                                                                .notifier)
                                                        .updateStatusRecruit(
                                                            true,
                                                            recruitsPropose[
                                                                    indexPropose]
                                                                ['id'],
                                                            name:
                                                                'recruitsPropose');
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
                                                    color: recruitsPropose[
                                                                    indexPropose]
                                                                [
                                                                'recruit_relationships']
                                                            ['follow_recruit']
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
                                                        color: recruitsPropose[
                                                                        indexPropose]
                                                                    [
                                                                    'recruit_relationships']
                                                                [
                                                                'follow_recruit']
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
                                                        color: recruitsPropose[
                                                                        indexPropose]
                                                                    [
                                                                    'recruit_relationships']
                                                                [
                                                                'follow_recruit']
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
                                                      top: Radius.circular(10),
                                                    ),
                                                  ),
                                                  context: context,
                                                  builder: (context) =>
                                                      ShareModalBottom(
                                                    data: recruitsPropose[
                                                        indexPropose],
                                                    type: 'recruit',
                                                  ),
                                                );
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
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
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
        recruitsSimilar.isNotEmpty
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
                          'Việc làm tương tự',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 380,
                          child: ListView.builder(
                              itemCount: recruitsSimilar.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, indexSimilar) {
                                return Container(
                                  width: MediaQuery.sizeOf(context).width * 0.6,
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
                                            recruitsSimilar[indexSimilar]
                                                        ['banner'] !=
                                                    null
                                                ? recruitsSimilar[indexSimilar]
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
                                                  RecruitDetail(
                                                      data: recruitsSimilar[
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
                                            height: 30,
                                            child: Text(
                                              '${recruitsSimilar[indexSimilar]['title']}',
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w800,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                            child: Text(
                                              '${recruitsSimilar[indexSimilar]?['account']?['display_name']}',
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: greyColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                            child: Text(
                                              '${convertNumberToVND(recruitsSimilar[indexSimilar]?['salary_min'] ~/ 1)}'
                                              ' - '
                                              '${convertNumberToVND(recruitsSimilar[indexSimilar]?['salary_max'] ~/ 1)} VNĐ',
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: greyColor,
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
                                                if (recruitsSimilar[
                                                                indexSimilar][
                                                            'recruit_relationships']
                                                        ['follow_recruit'] ==
                                                    true) {
                                                  setState(() {
                                                    ref
                                                        .read(
                                                            recruitControllerProvider
                                                                .notifier)
                                                        .updateStatusRecruit(
                                                            false,
                                                            recruitsSimilar[
                                                                    indexSimilar]
                                                                ['id'],
                                                            name:
                                                                'recruitsSimilar');
                                                    recruitsSimilar[
                                                                indexSimilar][
                                                            'recruit_relationships']
                                                        [
                                                        'follow_recruit'] = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    ref
                                                        .read(
                                                            recruitControllerProvider
                                                                .notifier)
                                                        .updateStatusRecruit(
                                                            true,
                                                            recruitsSimilar[
                                                                    indexSimilar]
                                                                ['id'],
                                                            name:
                                                                'recruitsSimilar');
                                                    recruitsSimilar[
                                                                indexSimilar][
                                                            'recruit_relationships']
                                                        [
                                                        'follow_recruit'] = true;
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
                                                    color: recruitsSimilar[
                                                                    indexSimilar]
                                                                [
                                                                'recruit_relationships']
                                                            ['follow_recruit']
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
                                                        color: recruitsSimilar[
                                                                        indexSimilar]
                                                                    [
                                                                    'recruit_relationships']
                                                                [
                                                                'follow_recruit']
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
                                                        color: recruitsSimilar[
                                                                        indexSimilar]
                                                                    [
                                                                    'recruit_relationships']
                                                                [
                                                                'follow_recruit']
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
                                                      top: Radius.circular(10),
                                                    ),
                                                  ),
                                                  context: context,
                                                  builder: (context) =>
                                                      ShareModalBottom(
                                                    type: 'recruit',
                                                    data: recruitsSimilar[
                                                        indexSimilar],
                                                  ),
                                                );
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
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
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

class RecruitmentRow extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String subtitle;

  const RecruitmentRow({
    Key? key,
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

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
          child: Icon(leadingIcon),
        ),
        title: Text(title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
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
