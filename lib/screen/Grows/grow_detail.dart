import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:social_network_app_mobile/data/event.dart';
import 'package:social_network_app_mobile/providers/grow_provider.dart';
import 'package:social_network_app_mobile/screen/Grows/grow_disscussion.dart';
import 'package:social_network_app_mobile/screen/Grows/grow_intro.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/icon_action_ellipsis.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class GrowDetail extends ConsumerStatefulWidget {
  final dynamic data;
  const GrowDetail({super.key, this.data});

  @override
  ConsumerState<GrowDetail> createState() => _GrowDetailState();
}

bool growStatus = true;

class _GrowDetailState extends ConsumerState<GrowDetail> {
  var growDetail = {};
  var growTransactions = {};

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(
        Duration.zero,
        () => ref
            .read(growControllerProvider.notifier)
            .getDetailGrow(widget.data['id']));
    Future.delayed(
        Duration.zero,
        () =>
            ref.read(growControllerProvider.notifier).getGrowTransactions({}));
  }

  Future<void> initData() async {
    if (growDetail.isEmpty) {
      await ref
          .read(growControllerProvider.notifier)
          .getDetailGrow(widget.data['id']);
      growDetail = ref.watch(growControllerProvider).detailGrow;
    }
    if (growTransactions.isEmpty) {
      await ref.read(growControllerProvider.notifier).getGrowTransactions({});
      growTransactions = ref.watch(growControllerProvider).growTransactions;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(growTransactions);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          alignment: Alignment.centerLeft,
          icon: Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 0.2, color: greyColor)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(FontAwesomeIcons.angleLeft, color: Colors.white, size: 18),
              ],
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
      ),
      body: FutureBuilder(
          future: initData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
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
                                child: Hero(
                                  tag: growDetail['banner']['url'],
                                  child: ClipRRect(
                                    child: ImageCacheRender(
                                      path: growDetail['banner']['url'],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        GetTimeAgo.parse(
                                          DateTime.parse(
                                              growDetail['due_date']),
                                        ),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.red),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        growDetail['title'],
                                        maxLines: 2,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder:
                                                      (context) => SizedBox(
                                                            height: 250,
                                                            child: Column(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    showModalBottomSheet(
                                                                        context:
                                                                            context,
                                                                        builder: (context) =>
                                                                            SizedBox(
                                                                              height: 300,
                                                                              child: Column(
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      IconButton(
                                                                                        icon: const Icon(Icons.close),
                                                                                        onPressed: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                      ),
                                                                                      const Text('Ủng hộ'),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ));
                                                                  },
                                                                  child:
                                                                      const ListTile(
                                                                    title: Text(
                                                                        'Ủng hộ'),
                                                                    subtitle: Text(
                                                                        'Tặng quà để giúp phát triển dự án'),
                                                                  ),
                                                                ),
                                                                const ListTile(
                                                                  title: Text(
                                                                      'Đầu tư'),
                                                                  subtitle: Text(
                                                                      'Đầu tư cho dự án để hưởng ưu đãi và lợi nhuận đã được cam kết'),
                                                                ),
                                                                const ListTile(
                                                                  title: Text(
                                                                      'Nhắn tin'),
                                                                  subtitle: Text(
                                                                      'Chúng tôi không chịu trách nhiệm khi nhà đầu tư liên hệ trực tiếp và đầu tư không thông qua nền tảng EMSO'),
                                                                )
                                                              ],
                                                            ),
                                                          ));
                                            },
                                            child: Container(
                                                height: 30,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                decoration: BoxDecoration(
                                                    color: secondaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    border: Border.all(
                                                        width: 0.2,
                                                        color: greyColor)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(
                                                        FontAwesomeIcons
                                                            .circleDollarToSlot,
                                                        color: Colors.white,
                                                        size: 14),
                                                    SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Text(
                                                      'Ủng hộ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          const SizedBox(width: 5),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                                height: 30,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.36,
                                                decoration: BoxDecoration(
                                                    color: growDetail['project_relationship']
                                                                [
                                                                'follow_project'] ==
                                                            true
                                                        ? secondaryColor
                                                            .withOpacity(0.45)
                                                        : const Color.fromARGB(
                                                            189, 202, 202, 202),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
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
                                                        color: growDetail[
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
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: growDetail[
                                                                        'project_relationship']
                                                                    [
                                                                    'follow_project'] ==
                                                                true
                                                            ? secondaryColor
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          const SizedBox(width: 5),
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) => Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 8.0, top: 15.0),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.3 +
                                                      30,
                                                  child: Column(
                                                    children: [
                                                      ListView.builder(
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            iconActionEllipsis
                                                                .length,
                                                        itemBuilder:
                                                            ((context, index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom:
                                                                        10.0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                showModalBottomSheet(
                                                                    context:
                                                                        context,
                                                                    isScrollControlled:
                                                                        true,
                                                                    barrierColor:
                                                                        Colors
                                                                            .transparent,
                                                                    clipBehavior: Clip
                                                                        .antiAliasWithSaveLayer,
                                                                    shape: const RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.vertical(
                                                                            top: Radius.circular(
                                                                                10))),
                                                                    builder:
                                                                        (context) =>
                                                                            SizedBox(
                                                                              height: MediaQuery.of(context).size.height * 0.9,
                                                                              width: MediaQuery.of(context).size.width,
                                                                              child: ActionEllipsis(menuSelected: iconActionEllipsis[index]),
                                                                            ));
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  CircleAvatar(
                                                                    radius:
                                                                        18.0,
                                                                    backgroundColor:
                                                                        greyColor[
                                                                            350],
                                                                    child: Icon(
                                                                      iconActionEllipsis[
                                                                              index]
                                                                          [
                                                                          "icon"],
                                                                      size:
                                                                          18.0,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10.0),
                                                                    child: Text(
                                                                        iconActionEllipsis[index]
                                                                            [
                                                                            "label"],
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                14.0,
                                                                            fontWeight:
                                                                                FontWeight.w500)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 30,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      189, 202, 202, 202),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  border: Border.all(
                                                      width: 0.2,
                                                      color: greyColor)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(
                                                      FontAwesomeIcons.ellipsis,
                                                      color: Colors.black,
                                                      size: 14),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                    FontAwesomeIcons.stopwatch,
                                                    color: Colors.black,
                                                    size: 20),
                                                const SizedBox(
                                                  width: 9.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4.0),
                                                  child: Text(
                                                    GetTimeAgo.parse(
                                                      DateTime.parse(growDetail[
                                                          'due_date']),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                    FontAwesomeIcons.solidUser,
                                                    color: Colors.black,
                                                    size: 20),
                                                const SizedBox(
                                                  width: 9.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4.0),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: 'Dự án của ',
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: growDetail[
                                                                    'account'][
                                                                'display_name'],
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                    FontAwesomeIcons
                                                        .clipboardCheck,
                                                    color: Colors.black,
                                                    size: 20),
                                                const SizedBox(
                                                  width: 9.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4.0),
                                                  child: Text(
                                                    '${growDetail['followers_count'].toString()} người quan tâm · ${growDetail['backers_count'].toString()} người ủng hộ',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: const [
                                              Icon(
                                                  FontAwesomeIcons
                                                      .earthAmericas,
                                                  color: Colors.black,
                                                  size: 20),
                                              SizedBox(
                                                width: 9.0,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 4.0),
                                                child: Text(
                                                  'Công khai · Tất cả mọi người trong hoặc ngoài EMSO',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ])),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 16, 0),
                            child: Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        growStatus = true;
                                      });
                                    },
                                    child: Container(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width *
                                          0.44,
                                      decoration: BoxDecoration(
                                          color: growStatus
                                              ? secondaryColor.withOpacity(0.4)
                                              : const Color.fromARGB(
                                                  189, 202, 202, 202),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              width: 0.2, color: greyColor)),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Giới thiệu',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: growStatus
                                                    ? secondaryColor
                                                    : Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ]),
                                    )),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      growStatus = false;
                                    });
                                  },
                                  child: Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width *
                                        0.44,
                                    decoration: BoxDecoration(
                                        color: !growStatus
                                            ? secondaryColor.withOpacity(0.4)
                                            : const Color.fromARGB(
                                                189, 202, 202, 202),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            width: 0.2, color: greyColor)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Cuộc thảo luận',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: !growStatus
                                                ? secondaryColor
                                                : Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                          growStatus
                              ? GrowIntro(data: growDetail)
                              : GrowDiscuss(data: growDetail),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
