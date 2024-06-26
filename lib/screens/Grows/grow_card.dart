import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/grow/grow_provider.dart';
import 'package:social_network_app_mobile/screens/Grows/grow_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';
import 'package:social_network_app_mobile/widgets/share_modal_bottom.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../widgets/skeleton.dart';

class GrowCard extends ConsumerStatefulWidget {
  const GrowCard({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<GrowCard> createState() => _GrowCardState();
}

class _GrowCardState extends ConsumerState<GrowCard> {
  late double width;
  late double height;
  var paramsConfigList = {
    "limit": 10,
    "status": "approved",
    "exclude_current_user": true
  };
  var paramsConFigOwnGrow = {"limit": 3, "only_current_user": true};
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(
          Duration.zero,
          () => ref
              .read(growControllerProvider.notifier)
              .getListGrow(paramsConfigList));
    }
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        String maxId = ref.read(growControllerProvider).grows.last['id'];
        ref
            .read(growControllerProvider.notifier)
            .getListGrow({"max_id": maxId, ...paramsConfigList});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List grows = ref.watch(growControllerProvider).grows;
    bool isMore = ref.watch(growControllerProvider).isMore;
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    return Flexible(
      child: RefreshIndicator(
        onRefresh: () async {
          ref
              .read(growControllerProvider.notifier)
              .getListGrow(paramsConfigList);
        },
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                child: Text(
                  'Khám phá dự án gọi vốn cộng đồng',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              grows.isNotEmpty
                  ? SizedBox(
                      child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: grows.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, indexInteresting) {
                        var valueLinearProgressBar = ((grows[indexInteresting]?
                                        ['real_value'] ??
                                    0 - 0) *
                                100) /
                            (grows[indexInteresting]?['target_value'] ?? 0 - 0);
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                          child: CardComponents(
                            imageCard: SizedBox(
                              height: 180,
                              width: width,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                                child: ExtendedImage.network(
                                  ((grows[indexInteresting]?['banner']
                                          ?['url']) ??
                                      (grows[indexInteresting]?['banner']
                                          ?['preview_url']) ??
                                      linkBannerDefault),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => GrowDetail(
                                          data: grows[indexInteresting])));
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
                                      (grows[indexInteresting]?['title']??"--").trim(),
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
                                      'Cam kết mục tiêu ${convertNumberToVND(grows[indexInteresting]?['target_value'] ~/ 1)} VNĐ',
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
                                      '${(grows[indexInteresting]?['followers_count']).toString()} người quan tâm · ${grows[indexInteresting]['backers_count'].toString()} người ủng hộ',
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: greyColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 2,
                                        right: 5,
                                        top: 20.0,
                                        bottom: 5),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: StepProgressIndicator(
                                            totalSteps:
                                                valueLinearProgressBar.toInt() >
                                                        100
                                                    ? 100
                                                    : 100,
                                            currentStep:
                                                valueLinearProgressBar.toInt() >
                                                        100
                                                    ? 100
                                                    : valueLinearProgressBar
                                                        .toInt(),
                                            size: 10,
                                            padding: 0,
                                            selectedColor: primaryColor,
                                            unselectedColor: greyColor,
                                            selectedGradientColor:
                                                const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.deepOrange,
                                                Colors.yellowAccent
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Đã ủng hộ được ',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          colorWord(context)),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            '${convertNumberToVND(grows[indexInteresting]['real_value'] ~/ 1)} VNĐ',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: colorWord(
                                                                context))),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                  '${valueLinearProgressBar == 0 ? 0 : valueLinearProgressBar.toStringAsFixed(2)}%')
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            buttonCard: Container(
                              padding: const EdgeInsets.only(
                                  bottom: 16.0, left: 15.5, right: 15.5),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: InkWell(
                                      onTap: () {
                                        if ((grows[indexInteresting]
                                                    ?['project_relationship']
                                                ?['follow_project']) ==
                                            true) {
                                          ref
                                              .read(growControllerProvider
                                                  .notifier)
                                              .updateStatusGrow(
                                                  grows[indexInteresting]
                                                      ?['id'],
                                                  false);
                                        } else {
                                          ref
                                              .read(growControllerProvider
                                                  .notifier)
                                              .updateStatusGrow(
                                                  grows[indexInteresting]
                                                      ?['id'],
                                                  true);
                                        }
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          height: 32,
                                          width: width * 0.7,
                                          decoration: BoxDecoration(
                                              color: grows[indexInteresting]?[
                                                              'project_relationship']
                                                          ?['follow_project'] ==
                                                      true
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
                                                  color: grows[indexInteresting]
                                                                  ?[
                                                                  'project_relationship']
                                                              ?[
                                                              'follow_project'] ==
                                                          true
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
                                                  color: grows[indexInteresting]
                                                                  ?[
                                                                  'project_relationship']
                                                              ?[
                                                              'follow_project'] ==
                                                          true
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
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(10),
                                              ),
                                            ),
                                            context: context,
                                            builder: (context) =>
                                                ShareModalBottom(
                                                    data:
                                                        grows[indexInteresting],
                                                    type: 'grow'));
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
                      },
                    ))
                  : const SizedBox(),
              isMore == true
                  ? Center(child: SkeletonCustom().growSkeleton(context))
                  : grows.isEmpty
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
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
