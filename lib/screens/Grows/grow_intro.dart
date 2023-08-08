
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/grow/grow_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/flick_multiple_manager.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/video_player_none_controller.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';
import 'package:social_network_app_mobile/widgets/share_modal_bottom.dart';
import 'package:social_network_app_mobile/widgets/text_readmore.dart';

import '../Page/PageDetail/page_detail.dart';
import '../UserPage/user_page.dart';
import 'grow_detail.dart';

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
                  const Divider(
                    height: 20,
                    thickness: 1,
                  ),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    height: 20,
                    thickness: 1,
                  ),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    height: 20,
                    thickness: 1,
                  ),
                  const Text(
                    'Mô tả kế hoạch',
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  height: 20,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: const Text(
                    'Video giới thiệu',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                      height: growDetail['introduction_video'] != null &&
                              growDetail['introduction_video']['meta'] !=
                                  null &&
                              growDetail['introduction_video']['meta']
                                      ['small'] !=
                                  null
                          ? growDetail['introduction_video']['meta']['small']
                                      ['aspect'] <
                                  0.58
                              ? MediaQuery.sizeOf(context).height - 66
                              : null
                          : 200,
                      width: 500,
                      child: VideoPlayerNoneController(
                        isShowVolumn: true,
                        path: growDetail['introduction_video'] != null
                            ? growDetail['introduction_video']['remote_url'] !=
                                        "pending" &&
                                    growDetail['introduction_video']
                                            ['remote_url'] !=
                                        null
                                ? growDetail['introduction_video']['remote_url']
                                : growDetail['introduction_video']['show_url']
                            : "",
                        type: 'local',
                        media: growDetail['introduction_video'],
                      )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    height: 20,
                    thickness: 1,
                  ),
                  const Text(
                    'Gặp gỡ người tổ chức',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 340,
                    child: ListView.builder(
                        itemCount: hosts.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            width: hosts.length > 1
                                ? MediaQuery.sizeOf(context).width * 0.61
                                : MediaQuery.sizeOf(context).width * 0.91,
                            margin: const EdgeInsets.only(top: 10),
                            child: CardComponents(
                              imageCard: Column(
                                children: [
                                  hosts[index]['account']['group']
                                      ? ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15)),
                                          child: ExtendedImage.network(
                                            hosts[index]['account']
                                                        ['avatar_media'] !=
                                                    null
                                                ? hosts[index]['account']
                                                    ['avatar_media']['url']
                                                : hosts[index]['account']
                                                    ['avatar_static'],
                                            fit: BoxFit.cover,
                                            width: hosts.length > 1
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.61
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.91,
                                            height: 180.0,
                                          ),
                                        )
                                      : Center(
                                          child: ClipOval(
                                            child: ExtendedImage.network(
                                              hosts[index]['account']
                                                          ['avatar_media'] !=
                                                      null
                                                  ? hosts[index]['account']
                                                      ['avatar_media']['url']
                                                  : hosts[index]['account']
                                                      ['avatar_static'],
                                              fit: BoxFit.cover,
                                              width: 180.0,
                                              height: 180.0,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                              onTap: () {
                                hosts[index]['account']['group']
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const PageDetail(),
                                          settings: RouteSettings(
                                              arguments: hosts[index]['account']
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
                                              'id': hosts[index]['account']
                                                  ['id']
                                            },
                                          ),
                                        ));
                              },
                              textCard: Column(
                                children: [
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
                                    height: 20,
                                  ),
                                  Text(
                                    hosts[index]['account']['description'] ??
                                        "",
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              buttonCard: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: InkWell(
                                    onTap: () {
                                      hosts[index]['account']['group']
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const PageDetail(),
                                                settings: RouteSettings(
                                                    arguments: hosts[index]
                                                            ['account']['id']
                                                        .toString()),
                                              ))
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const UserPageHome(),
                                                settings: RouteSettings(
                                                  arguments: {
                                                    'id': hosts[index]
                                                        ['account']['id']
                                                  },
                                                ),
                                              ));
                                    },
                                    child: Container(
                                      height: 35,
                                      width: MediaQuery.sizeOf(context).width *
                                          0.8,
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
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    height: 20,
                    thickness: 1,
                  ),
                  const Text(
                    'Dự án đề xuất',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 380,
                    child: ListView.builder(
                        itemCount: grows.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, indexSuggest) {
                          return Container(
                            width: MediaQuery.sizeOf(context).width * 0.6,
                            margin: const EdgeInsets.only(top: 10),
                            child: CardComponents(
                              imageCard: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                    child: ExtendedImage.network(
                                      grows[indexSuggest]['banner'] != null
                                          ? grows[indexSuggest]['banner']['url']
                                          : linkBannerDefault,
                                      fit: BoxFit.cover,
                                      height: 180.0,
                                      width: MediaQuery.sizeOf(context).width *
                                          0.6,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => GrowDetail(
                                            data: grows[indexSuggest])));
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
                                    SizedBox(
                                      height: 30,
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
                                    SizedBox(
                                      height: 30,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
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
                                    SizedBox(
                                      height: 40,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
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
                              buttonCard: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0),
                                child: Row(
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
                                          height: 33,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.37,
                                          decoration: BoxDecoration(
                                              color: grows[indexSuggest][
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
                                                  color: grows[indexSuggest][
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
                                                  color: grows[indexSuggest][
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
                                                    data: grows[indexSuggest]),
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
                                                  BorderRadius.circular(6),
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
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
