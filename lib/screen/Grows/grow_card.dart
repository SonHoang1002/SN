import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/grow_provider.dart';
import 'package:social_network_app_mobile/screen/Grows/grow_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/card_components.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/share_modal_bottom.dart';

class GrowCard extends ConsumerStatefulWidget {
  final dynamic grows;
  const GrowCard({Key? key, this.grows}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<GrowCard> createState() => _GrowCardState();
}

class _GrowCardState extends ConsumerState<GrowCard> {
  late double width;
  late double height;
  var paramsConfig = {"limit": 4};

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(
        Duration.zero,
        () => ref
            .read(growControllerProvider.notifier)
            .getListGrow(paramsConfig));
  }

  @override
  Widget build(BuildContext context) {
    List grows = ref.watch(growControllerProvider).grows;
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
            child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: grows.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CardComponents(
                type: 'homeScreen',
                imageCard: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: ImageCacheRender(
                    path: grows[index]['banner']['url'],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              GrowDetail(data: grows[index])));
                },
                textCard: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        grows[index]['title'],
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        'Cam kết mục tiêu ${convertNumberToVND(grows[index]['target_value'] ~/ 1)} VNĐ',
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
                        '${grows[index]['followers_count'].toString()} người quan tâm · ${grows[index]['backers_count'].toString()} người ủng hộ',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: greyColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                buttonCard: Row(
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: InkWell(
                        onTap: () {
                          if (grows[index]['project_relationship']
                                  ['follow_project'] ==
                              true) {
                            ref
                                .read(growControllerProvider.notifier)
                                .updateStatusGrow(grows[index]['id'], false);
                          } else {
                            ref
                                .read(growControllerProvider.notifier)
                                .updateStatusGrow(grows[index]['id'], true);
                          }
                        },
                        child: Container(
                          height: 30,
                          width: width * 0.7,
                          decoration: BoxDecoration(
                              color: grows[index]['project_relationship']
                                          ['follow_project'] ==
                                      true
                                  ? secondaryColor.withOpacity(0.45)
                                  : const Color.fromARGB(189, 202, 202, 202),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(width: 0.2, color: greyColor)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FontAwesomeIcons.solidStar,
                                  color: grows[index]['project_relationship']
                                              ['follow_project'] ==
                                          true
                                      ? secondaryColor
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
                                  color: grows[index]['project_relationship']
                                              ['follow_project'] ==
                                          true
                                      ? secondaryColor
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
                              builder: (context) => const ShareModalBottom());
                        },
                        child: Container(
                          height: 30,
                          width: width * 0.12,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(189, 202, 202, 202),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(width: 0.2, color: greyColor)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
            );
          },
        ))
      ]),
    );
  }
}
