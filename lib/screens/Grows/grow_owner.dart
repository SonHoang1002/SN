import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/grow/grow_provider.dart';
import 'package:social_network_app_mobile/screens/Grows/grow_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';
import 'package:social_network_app_mobile/widgets/share_modal_bottom.dart';

import '../../constant/common.dart';
import '../../widgets/skeleton.dart';

class GrowOwner extends ConsumerStatefulWidget {
  const GrowOwner({Key? key}) : super(key: key);

  @override
  ConsumerState<GrowOwner> createState() => _GrowOwnerState();
}

class _GrowOwnerState extends ConsumerState<GrowOwner> {
  var configParams = {"limit": 10, "following": true};
  bool isLoading = false;
  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(Duration.zero, () => fetchData());
  }

  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    await ref
        .read(growControllerProvider.notifier)
        .getListGrowsOwner(configParams);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    var width = size.width;
    var height = size.height;
    List grows = ref.watch(growControllerProvider).growsOwner;
    bool isMore = ref.watch(growControllerProvider).isMore;

    return Flexible(
      child: RefreshIndicator(
        onRefresh: () async {
          fetchData();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                child: Text(
                  'Dự án bạn quan tâm',
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
                      itemBuilder: (context, indexOwner) {
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
                                  grows[indexOwner]['banner'] != null
                                      ? grows[indexOwner]['banner']['url']
                                      : linkBannerDefault,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          GrowDetail(data: grows[indexOwner])));
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
                                      grows[indexOwner]['title'],
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
                                      'Cam kết mục tiêu ${convertNumberToVND(grows[indexOwner]['target_value'] ~/ 1)} VNĐ',
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
                                      '${grows[indexOwner]['followers_count'].toString()} người quan tâm · ${grows[indexOwner]['backers_count'].toString()} người ủng hộ',
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
                                  bottom: 16.0, left: 15.5, right: 15.5),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: InkWell(
                                      onTap: () {
                                        if (grows[indexOwner]
                                                    ['project_relationship']
                                                ['follow_project'] ==
                                            true) {
                                          ref
                                              .read(growControllerProvider
                                                  .notifier)
                                              .updateStatusGrow(
                                                  grows[indexOwner]['id'],
                                                  false);
                                        } else {
                                          ref
                                              .read(growControllerProvider
                                                  .notifier)
                                              .updateStatusGrow(
                                                  grows[indexOwner]['id'],
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
                                              color: grows[indexOwner][
                                                              'project_relationship']
                                                          ['follow_project'] ==
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
                                                  color: grows[indexOwner][
                                                                  'project_relationship']
                                                              [
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
                                                  color: grows[indexOwner][
                                                                  'project_relationship']
                                                              [
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
                                                  type: 'grow',
                                                  data: grows[indexOwner],
                                                ));
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
              isLoading && grows.isEmpty || isMore == true
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
    super.dispose();
  }
}
