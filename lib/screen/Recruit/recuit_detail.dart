import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/providers/recruit/recruit_provider.dart';
import 'package:social_network_app_mobile/screen/Recruit/recruit_intro.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/modal_invite_friend.dart';

import '../../constant/common.dart';
import '../../widget/Loading/tiktok_loading.dart';

class RecruitDetail extends ConsumerStatefulWidget {
  final dynamic data;
  final bool? isUseRecruitData;
  const RecruitDetail({Key? key, this.data, this.isUseRecruitData})
      : super(key: key);

  @override
  ConsumerState<RecruitDetail> createState() => _RecruitDetailState();
}

class _RecruitDetailState extends ConsumerState<RecruitDetail> {
  bool isRecruitInterested = false;
  dynamic recruitDetail = {};

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
    if ((recruitDetail.isEmpty) && (widget.isUseRecruitData == true)) {
      recruitDetail = widget.data;
    } else {
      await ref
          .read(recruitControllerProvider.notifier)
          .getDetailRecruit(widget.data['id'])
          .then((value) {
        recruitDetail = ref.read(recruitControllerProvider).detailRecruit;
      });
    }
    isRecruitInterested =
        widget.data['recruit_relationships']['follow_recruit'];
    await ref
        .read(recruitControllerProvider.notifier)
        .getListRecruitPropose({'exclude_current_user': true, 'limit': 5});
    await ref.read(recruitControllerProvider.notifier).getListRecruitSimilar({
      'recruit_id': widget.data['id'],
      'recruit_category_id': widget.data['recruit_category']['id'],
      'limit': 5,
      'time': 'upcoming'
    });

    setState(() {});
  }

  /// Re-render when component changed
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   recruitDetail = ref.watch(recruitControllerProvider).detailRecruit;
  // }

  @override
  Widget build(BuildContext context) { 
    final theme = pv.Provider.of<ThemeManager>(context);
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
                  .read(recruitControllerProvider.notifier)
                  .getDetailRecruit(widget.data['id']);
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
                  recruitDetail.isNotEmpty && recruitDetail['title'] != null
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
                                      'Hạn nộp hồ sơ: ${GetTimeAgo.parse(
                                        DateTime.parse(
                                            recruitDetail['created_at']),
                                      )}',
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      recruitDetail['title'],
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
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isRecruitInterested =
                                            !isRecruitInterested;
                                        ref
                                            .read(recruitControllerProvider
                                                .notifier)
                                            .updateStatusRecruit(
                                                isRecruitInterested,
                                                widget.data['id'],
                                                name: 'detailRecruit');
                                      });
                                    },
                                    child: Container(
                                        height: 35,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        decoration: BoxDecoration(
                                            color: isRecruitInterested
                                                ? secondaryColor
                                                : const Color.fromARGB(
                                                    189, 202, 202, 202),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                                width: 0.2, color: greyColor)),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(FontAwesomeIcons.solidStar,
                                                  size: 14,
                                                  color: isRecruitInterested
                                                      ? Colors.white
                                                      : Colors.black),
                                              const SizedBox(
                                                width: 5.0,
                                              ),
                                              Text(
                                                'Quan tâm',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: isRecruitInterested
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w700,
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
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          context: context,
                                          builder: (context) =>
                                              const InviteFriend());
                                    },
                                    child: Container(
                                        height: 35,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
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
                                              Text(
                                                'Mời',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ])),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                        height: 35,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
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
                                                  size: 14, color: Colors.black)
                                            ])),
                                  ),
                                ],
                              ),
                            ),
                            RecruitIntro(recruitDetail: recruitDetail),
                            const SizedBox(height: 70),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          recruitDetail['title'] == null
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
