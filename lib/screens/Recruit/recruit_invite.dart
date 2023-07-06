import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/recruit/recruit_provider.dart';
import 'package:social_network_app_mobile/screens/Recruit/recuit_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';
import 'package:social_network_app_mobile/widgets/share_modal_bottom.dart';

import '../../constant/common.dart';

class RecruitInvite extends ConsumerStatefulWidget {
  const RecruitInvite({super.key});

  @override
  ConsumerState<RecruitInvite> createState() => _RecruitInviteState();
}

class _RecruitInviteState extends ConsumerState<RecruitInvite> {
  var paramsList = {
    "limit": 10,
  };
  late double width;
  late double height;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (mounted) {
        ref
            .read(recruitControllerProvider.notifier)
            .getListRecruitInvite(paramsList);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List recruits = ref.watch(recruitControllerProvider).recruitsInvite;
    bool isMore = ref.watch(recruitControllerProvider).isMore;

    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Expanded(
        child: RefreshIndicator(
      onRefresh: () async {
        ref
            .read(recruitControllerProvider.notifier)
            .getListRecruitInvite(paramsList);
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Text(
                'Lời mời quan tâm tuyển dụng',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            recruits.isNotEmpty
                ? SizedBox(
                    child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recruits.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      if (index < recruits.length) {
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
                                  recruits[index]['recruit']['banner'] != null
                                      ? recruits[index]['recruit']['banner']
                                          ['url']
                                      : linkBannerDefault,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => RecruitDetail(
                                          data: recruits[index]['recruit'])));
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
                                      recruits[index]['recruit']['title'],
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
                                      recruits[index]['recruit']['account']
                                          ['display_name'],
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
                                      '${convertNumberToVND(recruits[index]['recruit']['salary_min'] ~/ 1)}'
                                      ' - '
                                      '${convertNumberToVND(recruits[index]['recruit']['salary_max'] ~/ 1)} VNĐ',
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
                            buttonCard: Container(
                              padding: const EdgeInsets.only(
                                  bottom: 16.0, left: 16.0, right: 16.0),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: InkWell(
                                      onTap: () {
                                        if (recruits[index]['recruit']
                                                    ['recruit_relationships']
                                                ['follow_recruit'] ==
                                            true) {
                                          setState(() {
                                            ref
                                                .read(recruitControllerProvider
                                                    .notifier)
                                                .updateStatusRecruit(
                                                    false,
                                                    recruits[index]['recruit']
                                                        ['id'],
                                                    name: 'recruitsInvite');
                                            recruits[index]['recruit']
                                                    ['recruit_relationships']
                                                ['follow_recruit'] = false;
                                          });
                                        } else {
                                          setState(() {
                                            ref
                                                .read(recruitControllerProvider
                                                    .notifier)
                                                .updateStatusRecruit(
                                                    true,
                                                    recruits[index]['recruit']
                                                        ['id'],
                                                    name: 'recruitsInvite');
                                            recruits[index]['recruit']
                                                    ['recruit_relationships']
                                                ['follow_recruit'] = true;
                                          });
                                        }
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          height: 32,
                                          width: width * 0.7,
                                          decoration: BoxDecoration(
                                              color: recruits[index]['recruit'][
                                                          'recruit_relationships']
                                                      ['follow_recruit']
                                                  ? secondaryColor
                                                  : const Color.fromARGB(
                                                      189, 202, 202, 202),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  width: 0.2,
                                                  color: greyColor)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(FontAwesomeIcons.solidStar,
                                                  color: recruits[index]
                                                                  ['recruit'][
                                                              'recruit_relationships']
                                                          ['follow_recruit']
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
                                                  color: recruits[index]
                                                                  ['recruit'][
                                                              'recruit_relationships']
                                                          ['follow_recruit']
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
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(10),
                                            ),
                                          ),
                                          context: context,
                                          builder: (context) =>
                                              ShareModalBottom(
                                                  data: recruits[index],
                                                  type: 'recruit'),
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
                      }
                      return const SizedBox();
                    },
                  ))
                : isMore == true
                    ? const Center(child: CupertinoActivityIndicator())
                    : recruits.isEmpty
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
}
