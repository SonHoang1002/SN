import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/grow_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/feed_video.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/flick_multiple_manager.dart';
import 'package:social_network_app_mobile/widget/card_components.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/share_modal_bottom.dart';
import 'package:social_network_app_mobile/widget/text_readmore.dart';

class GrowIntro extends ConsumerStatefulWidget {
  final dynamic data;
  const GrowIntro({super.key, this.data});

  @override
  ConsumerState<GrowIntro> createState() => _GrowIntroState();
}

List hosts = [];
List growSuggest = [];

class _GrowIntroState extends ConsumerState<GrowIntro> {
  late FlickMultiManager flickMultiManager;


  var paramsConfig = {
    "limit": 3,
    "exclude_current_user": true,
    "status": 'approved'
  };
  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    flickMultiManager = FlickMultiManager();
    Future.delayed(
        Duration.zero,
        () => ref
            .read(growControllerProvider.notifier)
            .getGrowHosts(widget.data['id']));
    Future.delayed(
        Duration.zero,
        () => ref
            .read(growControllerProvider.notifier)
            .getListGrowSuggest(paramsConfig));

  }

  List<bool> isReadMoreList = [true, true, true];

  @override
  Widget build(BuildContext context) {
    List hosts = ref.watch(growControllerProvider).hosts;
    List grows = ref.watch(growControllerProvider).growsSuggest;
    var growDetail = widget.data;
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mô tả dự án',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextReadMore(
                      description: growDetail['description_project'],
                      isReadMore: isReadMoreList[0],
                      onTap: () {
                        setState(() {
                          isReadMoreList[0] = !isReadMoreList[0];
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 20,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mô tả doanh nghiệp',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextReadMore(
                      description: growDetail['description_company'],
                      isReadMore: isReadMoreList[1],
                      onTap: () {
                        setState(() {
                          isReadMoreList[1] = !isReadMoreList[1];
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 20,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mô tả doanh nghiệp',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextReadMore(
                      description: growDetail['description_company'],
                      isReadMore: isReadMoreList[2],
                      onTap: () {
                        setState(() {
                          isReadMoreList[2] = !isReadMoreList[2];
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 20,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Video giới thiệu',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      // height: MediaQuery.of(context).size.height - 66,
                      height: growDetail['introduction_video']['meta'] != null && growDetail['introduction_video']['meta']['small'] != null
                          ? growDetail['introduction_video']['meta']['small']
                                      ['aspect'] <
                                  0.58
                              ? MediaQuery.of(context).size.height - 66
                              : null
                          :  MediaQuery.of(context).size.height - 66,
                      child: FeedVideo(
                          type: 'showFullScreen',
                          path: growDetail['banner']['remote_url'] ??
                            "",
                          flickMultiManager: flickMultiManager,
                          image: growDetail['introduction_video']
                                  ['preview_url'] ??
                             ""),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 20,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gặp gỡ người tổ chức',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView.builder(
                        itemCount: hosts.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            width: hosts.length > 1
                                ? MediaQuery.of(context).size.width * 0.61
                                : MediaQuery.of(context).size.width * 0.91,
                            margin: const EdgeInsets.only(top: 10),
                            child: CardComponents(
                              imageCard: Column(
                                children: [
                                  hosts[index]['account']['group']
                                      ? ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15)),
                                          child: ImageCacheRender(
                                            path: hosts[index]['account']
                                                        ['avatar_media'] !=
                                                    null
                                                ? hosts[index]['account']
                                                    ['avatar_media']['url']
                                                : hosts[index]['account']
                                                    ['avatar_static'],
                                            width: hosts.length > 1
                                                ? MediaQuery.of(context).size.width * 0.61
                                                : MediaQuery.of(context).size.width * 0.91,
                                            height: 180.0,
                                          ),
                                        )
                                      : ClipOval(
                                          child: ImageCacheRender(
                                            path: hosts[index]['account']
                                                        ['avatar_media'] !=
                                                    null
                                                ? hosts[index]['account']
                                                    ['avatar_media']['url']
                                                : hosts[index]['account']
                                                    ['avatar_static'],
                                            width: 180.0,
                                            height: 180.0,
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0,
                                        bottom: 8.0,
                                        left: 8.0,
                                        right: 8.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        hosts[index]['account']
                                                ['display_name'] ??
                                            "",
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${hosts[index]['account']['followers_count'].toString()} người quan tâm · ${hosts[index]['account']['following_count'].toString()} người theo dõi',
                                        style: const TextStyle(
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 1,
                                  )
                                ],
                              ),
                              textCard: Padding(
                                padding: const EdgeInsets.only(top: 35.0),
                                child: Text(
                                  hosts[index]['account']['description'] ?? "",
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              buttonCard: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 30,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          189, 202, 202, 202),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          width: 0.2, color: greyColor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(FontAwesomeIcons.user,
                                          color: Colors.black, size: 14),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        'Xem',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
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
                          );
                        }),
                  )
                ],
              ),
            ),
            const Divider(
              height: 20,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dự án đề xuất',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView.builder(
                        itemCount: grows.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, indexSuggest) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            margin: const EdgeInsets.only(top: 10),
                            child: CardComponents(
                              imageCard: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                    child: ImageCacheRender(
                                      path: grows[indexSuggest]['banner']
                                          ['url'],
                                      height: 180.0,
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                    ),
                                  ),
                                ],
                              ),
                              textCard: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 40,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          grows[indexSuggest]['title'],
                                          maxLines: 2,
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w700,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          'Cam kết mục tiêu ${convertNumberToVND(grows[indexSuggest]['target_value'] ~/ 1)} VNĐ',
                                          maxLines: 2,
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            color: greyColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          '${grows[indexSuggest]['followers_count'].toString()} người quan tâm · ${grows[indexSuggest]['backers_count'].toString()} người ủng hộ',
                                          maxLines: 2,
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            color: greyColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              buttonCard: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: InkWell(
                                      onTap: () {
                                        if (grows[indexSuggest]
                                                    ['project_relationship']
                                                ['follow_project'] ==
                                            true) {
                                          ref
                                              .read(growControllerProvider
                                                  .notifier)
                                              .updateStatusHost(
                                                  grows[indexSuggest]['id'],
                                                  false);
                                        } else {
                                          ref
                                              .read(growControllerProvider
                                                  .notifier)
                                              .updateStatusHost(
                                                  grows[indexSuggest]['id'],
                                                  true);
                                        }
                                      },
                                      child: Container(
                                        height: 30,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.37,
                                        decoration: BoxDecoration(
                                            color: grows[indexSuggest][
                                                            'project_relationship']
                                                        ['follow_project'] ==
                                                    true
                                                ? secondaryColor
                                                    .withOpacity(0.45)
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
                                                color: grows[indexSuggest][
                                                                'project_relationship']
                                                            [
                                                            'follow_project'] ==
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
                                                color: grows[indexSuggest][
                                                                'project_relationship']
                                                            [
                                                            'follow_project'] ==
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
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(10),
                                              ),
                                            ),
                                            context: context,
                                            builder: (context) =>
                                                const ShareModalBottom());
                                      },
                                      child: Container(
                                        height: 30,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    0.1 -
                                                2.3,
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
                          );
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}