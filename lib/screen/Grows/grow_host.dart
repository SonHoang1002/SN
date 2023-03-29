import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/grow/grow_provider.dart';
import 'package:social_network_app_mobile/screen/Grows/grow_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/card_components.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/share_modal_bottom.dart';

class GrowHost extends ConsumerStatefulWidget {
  const GrowHost({Key? key}) : super(key: key);

  @override
  ConsumerState<GrowHost> createState() => _GrowHostState();
}

class _GrowHostState extends ConsumerState<GrowHost> {

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(
        Duration.zero,
            () => ref
            .read(growControllerProvider.notifier)
            .getListGrow({"only_current_user": true,"time": "past"}));
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    List grows = ref.watch(growControllerProvider).grows;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(children: [
          grows.isNotEmpty ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                child: Text(
                  'Dự án bạn tổ chức',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: grows.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, indexOwner) {
                      return Padding(
                        padding: const EdgeInsets.only(top:8.0, left: 8.0, right: 8.0, bottom: 8.0),
                        child: CardComponents(
                          imageCard: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                            child: ImageCacheRender(
                              path: grows[indexOwner]['banner'] != null ? grows[indexOwner]['banner']['url'] : "https://sn.emso.vn/static/media/group_cover.81acfb42.png",
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        GrowDetail(data: grows[indexOwner])));
                          },
                          textCard: Column(
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
                          buttonCard: Container(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Row(
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: InkWell(
                                    onTap: () {
                                      if (grows[indexOwner]['project_relationship']
                                      ['follow_project'] ==
                                          true) {
                                        ref
                                            .read(growControllerProvider.notifier)
                                            .updateStatusGrow(grows[indexOwner]['id'], false);
                                      } else {
                                        ref
                                            .read(growControllerProvider.notifier)
                                            .updateStatusGrow(grows[indexOwner]['id'], true);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Container(
                                        height: 32,
                                        width: width * 0.7,
                                        decoration: BoxDecoration(
                                            color: grows[indexOwner]['project_relationship']
                                            ['follow_project'] ==
                                                true
                                                ? secondaryColor.withOpacity(0.45)
                                                : const Color.fromARGB(189, 202, 202, 202),
                                            borderRadius: BorderRadius.circular(6),
                                            border:
                                            Border.all(width: 0.2, color: greyColor)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(FontAwesomeIcons.solidStar,
                                                color: grows[indexOwner]['project_relationship']
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
                                                color: grows[indexOwner]['project_relationship']
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
                                      height: 32,
                                      width: width * 0.12,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(189, 202, 202, 202),
                                          borderRadius: BorderRadius.circular(6),
                                          border:
                                          Border.all(width: 0.2, color: greyColor)),
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
                        ),
                      );
                    },
                  )),
            ],
          ) : const SizedBox(),
        ]),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
}
