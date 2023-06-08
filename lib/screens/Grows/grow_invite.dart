import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/data/event.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/grow/grow_provider.dart';
import 'package:social_network_app_mobile/screens/Grows/grow_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/share_modal_bottom.dart';

class GrowInvite extends ConsumerStatefulWidget {
  final dynamic event;
  const GrowInvite({Key? key, this.event}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<GrowInvite> createState() => _GrowInviteState();
}

class _GrowInviteState extends ConsumerState<GrowInvite> {
  late double width;
  late double height;
  bool eventAction = true;
  var paramsConfig = {"limit": 10};
  bool loading = false;

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(Duration.zero, () => _fetchGetListInvite());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fetchGetListInvite() async {
    setState(() {
      loading = true;
    });
    await ref
        .read(growControllerProvider.notifier)
        .getListGrowsInvite(paramsConfig);
    setState(() {
      loading = false;
    });
  }

  void _fetchGetListInviteHost() async {
    setState(() {
      loading = true;
    });
    await ref
        .read(growControllerProvider.notifier)
        .getListGrowsInviteHost(null);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List grows = ref.watch(growControllerProvider).growsInvite;
    List growsInviteHost = ref.watch(growControllerProvider).growsInviteHost;
    bool isMore = ref.watch(growControllerProvider).isMore;

    final theme = pv.Provider.of<ThemeManager>(context);
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          eventAction ? _fetchGetListInvite() : _fetchGetListInviteHost();
        },
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Text(
                'Lời mời quan tâm dự án',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          eventAction = true;
                          _fetchGetListInvite();
                        });
                      },
                      child: Container(
                        height: 38,
                        width: MediaQuery.of(context).size.width * 0.43,
                        decoration: BoxDecoration(
                            color: eventAction
                                ? secondaryColor
                                : const Color.fromARGB(189, 202, 202, 202),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(width: 0.2, color: greyColor)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Mời tham gia',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: eventAction
                                      ? Colors.white
                                      : colorWord(context),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ]),
                      )),
                  const SizedBox(width: 16),
                  InkWell(
                      onTap: () {
                        setState(() {
                          eventAction = false;
                          _fetchGetListInviteHost();
                        });
                      },
                      child: Container(
                        height: 38,
                        width: MediaQuery.of(context).size.width * 0.43,
                        decoration: BoxDecoration(
                            color: !eventAction
                                ? secondaryColor
                                : const Color.fromARGB(189, 202, 202, 202),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(width: 0.2, color: greyColor)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Mời làm đồng tổ chức',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w700,
                                color: !eventAction
                                    ? Colors.white
                                    : colorWord(context),
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
            eventAction
                ? grows.isNotEmpty
                    ? SizedBox(
                        child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: grows.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, indexInteresting) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                            child: CardComponents(
                              type: 'homeScreen',
                              imageCard: SizedBox(
                                height: 180,
                                width: width,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  child: ExtendedImage.network(
                                    grows[indexInteresting]['project']
                                                ['banner'] !=
                                            null
                                        ? grows[indexInteresting]['project']
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
                                        builder: (context) => GrowDetail(
                                            data: grows[indexInteresting]
                                                ['project'])));
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
                                        grows[indexInteresting]['project']
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
                                        'Cam kết mục tiêu ${convertNumberToVND(grows[indexInteresting]['project']['target_value'] ~/ 1)} VNĐ',
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
                                        '${grows[indexInteresting]['project']['followers_count'].toString()} người quan tâm · ${grows[indexInteresting]['project']['backers_count'].toString()} người ủng hộ',
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
                                          if (grows[indexInteresting]['project']
                                                      ['project_relationship']
                                                  ['follow_project'] ==
                                              true) {
                                            ref
                                                .read(growControllerProvider
                                                    .notifier)
                                                .updateStatusGrowInvite(
                                                    grows[indexInteresting]
                                                        ['project']['id'],
                                                    false);
                                          } else {
                                            ref
                                                .read(growControllerProvider
                                                    .notifier)
                                                .updateStatusGrowInvite(
                                                    grows[indexInteresting]
                                                        ['project']['id'],
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
                                                color: grows[indexInteresting]
                                                                    ['project'][
                                                                'project_relationship']
                                                            [
                                                            'follow_project'] ==
                                                        true
                                                    ? secondaryColor
                                                        .withOpacity(0.45)
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
                                                                        [
                                                                        'project']
                                                                    [
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
                                                    color: grows[indexInteresting]
                                                                        [
                                                                        'project']
                                                                    [
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
                                                  const ShareModalBottom());
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
                                                  width: 0.2,
                                                  color: greyColor)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
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
                        },
                      ))
                    : const SizedBox()
                : growsInviteHost.isNotEmpty
                    ? SizedBox(
                        child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: growsInviteHost.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, indexHost) {
                          String statusHost =
                              growsInviteHost[indexHost]['status'] ?? '';
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                            child: CardComponents(
                              type: 'homeScreen',
                              imageCard: SizedBox(
                                height: 180,
                                width: width,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  child: ExtendedImage.network(
                                    growsInviteHost[indexHost]['project']
                                                ['banner'] !=
                                            null
                                        ? growsInviteHost[indexHost]['project']
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
                                        builder: (context) => GrowDetail(
                                            data: growsInviteHost[indexHost]
                                                ['project'])));
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
                                        growsInviteHost[indexHost]['project']
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
                                        'Cam kết mục tiêu ${convertNumberToVND(growsInviteHost[indexHost]['project']['target_value'] ~/ 1)} VNĐ',
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
                                        '${growsInviteHost[indexHost]['project']['followers_count'].toString()} người quan tâm · ${growsInviteHost[indexHost]['project']['backers_count'].toString()} người ủng hộ',
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
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(10),
                                              ),
                                            ),
                                            context: context,
                                            builder: (context) =>
                                                StatefulBuilder(builder:
                                                    (context, setStateful) {
                                              return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin: const EdgeInsets.only(
                                                    top: 10),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                      'Phản hồi của bạn',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    const CrossBar(),
                                                    Column(
                                                      children: List.generate(
                                                          iconEventHost.length,
                                                          (indexGes) =>
                                                              GestureDetector(
                                                                onTap: () {
                                                                  ref
                                                                      .read(growControllerProvider
                                                                          .notifier)
                                                                      .updateStatusInviteHost(
                                                                          growsInviteHost[indexHost]['project']
                                                                              ['id'],
                                                                          {
                                                                        'status':
                                                                            iconEventHost[indexGes]['key']
                                                                      });

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: ListTile(
                                                                  dense: true,
                                                                  contentPadding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          0.0),
                                                                  visualDensity:
                                                                      const VisualDensity(
                                                                          horizontal:
                                                                              -4,
                                                                          vertical:
                                                                              -1),
                                                                  title: Text(
                                                                      iconEventHost[
                                                                              indexGes]
                                                                          [
                                                                          'label'],
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w600)),
                                                                  trailing: Radio(
                                                                      groupValue: statusHost,
                                                                      value: iconEventHost[indexGes]['key'],
                                                                      onChanged: (value) {
                                                                        ref.read(growControllerProvider.notifier).updateStatusInviteHost(
                                                                            growsInviteHost[indexHost]['project']['id'],
                                                                            {
                                                                              'status': value
                                                                            });

                                                                        Navigator.pop(
                                                                            context);
                                                                      }),
                                                                ),
                                                              )),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                          );
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
                                          child: Container(
                                            height: 32,
                                            width: width * 0.7,
                                            decoration: BoxDecoration(
                                                color: statusHost != "pending"
                                                    ? secondaryColor
                                                    : const Color.fromARGB(
                                                        189, 202, 202, 202),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    width: 0.2,
                                                    color: greyColor)),
                                            child: statusHost == 'approved'
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 3.0),
                                                        child: Icon(
                                                            FontAwesomeIcons
                                                                .circleCheck,
                                                            color: theme
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : secondaryColor,
                                                            size: 14),
                                                      ),
                                                      const SizedBox(
                                                        width: 5.0,
                                                      ),
                                                      Text(
                                                        'Chấp nhận',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: theme
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : secondaryColor),
                                                      ),
                                                      const SizedBox(
                                                        width: 5.0,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 5.0),
                                                        child: Icon(
                                                            FontAwesomeIcons
                                                                .sortDown,
                                                            color: theme
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : secondaryColor,
                                                            size: 14),
                                                      ),
                                                    ],
                                                  )
                                                : statusHost == 'rejected'
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                              FontAwesomeIcons
                                                                  .circleCheck,
                                                              color: theme
                                                                      .isDarkMode
                                                                  ? Colors.white
                                                                  : secondaryColor,
                                                              size: 14),
                                                          const SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          Text(
                                                            'Từ chối',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: theme
                                                                        .isDarkMode
                                                                    ? Colors
                                                                        .white
                                                                    : secondaryColor),
                                                          ),
                                                          const SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom:
                                                                        4.0),
                                                            child: Icon(
                                                                FontAwesomeIcons
                                                                    .sortDown,
                                                                color: theme
                                                                        .isDarkMode
                                                                    ? Colors
                                                                        .white
                                                                    : secondaryColor,
                                                                size: 14),
                                                          )
                                                        ],
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        3.0),
                                                            child: Icon(
                                                                FontAwesomeIcons
                                                                    .circleCheck,
                                                                color: Colors
                                                                    .black,
                                                                size: 14),
                                                          ),
                                                          SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          Text(
                                                            'Đang chờ',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .black),
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
                                                  const ShareModalBottom());
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
                                                  width: 0.2,
                                                  color: greyColor)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
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
                        },
                      ))
                    : const SizedBox(),
            loading &&
                        (eventAction && grows.isEmpty ||
                            !eventAction && growsInviteHost.isEmpty) ||
                    isMore == true
                ? const Center(child: CupertinoActivityIndicator())
                : eventAction && grows.isEmpty ||
                        !eventAction && growsInviteHost.isEmpty
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
        )),
      ),
    );
  }
}
