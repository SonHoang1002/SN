import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:social_network_app_mobile/data/event.dart';
import 'package:social_network_app_mobile/providers/event_provider.dart';
import 'package:social_network_app_mobile/screen/Event/event_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/share_modal_bottom.dart';

class EventCard extends ConsumerStatefulWidget {
  final dynamic event;
  const EventCard({Key? key, this.event}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<EventCard> createState() => _EventCardState();
}

String maxId = '';
List events = [];
bool isMore = true;
String hasEvents = '';

class _EventCardState extends ConsumerState<EventCard> {
  late double width;
  late double height;
  var paramsConfig = {"limit": 3};

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(
        Duration.zero,
        () => ref
            .read(eventControllerProvider.notifier)
            .getListEvent(paramsConfig));
  }

  @override
  Widget build(BuildContext context) {
    List events = ref.watch(eventControllerProvider).events;
    bool isMore = ref.watch(eventControllerProvider).isMore;

    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: events.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 6),
                        child: Card(
                          color: Colors.white,
                          elevation: 0,
                          clipBehavior: Clip.antiAlias,
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => EventDetail(
                                            eventDetail: events[index],
                                          )));
                            },
                            splashColor: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.12),
                            highlightColor: Colors.transparent,
                            child: Stack(children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                    child: ImageCacheRender(
                                      path: events[index]['banner']
                                          ['preview_url'],
                                      height: height * 0.15,
                                      width: width,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            GetTimeAgo.parse(
                                              DateTime.parse(
                                                  events[index]['start_time']),
                                            ),
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            events[index]['title'],
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child: Text(
                                            // isCare[index]['location'],
                                            'HÀ NỘI',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: greyColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            '${events[index]['users_interested_count'].toString()} người quan tâm · ${events[index]['users_going_count'].toString()} người tham gia ',
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
                                  Row(children: [
                                    SizedBox(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                String key = events[index][
                                                            'event_relationship']
                                                        ['status'] ??
                                                    '';
                                                if (key != '') {
                                                  showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        top:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    context: context,
                                                    builder: (context) =>
                                                        StatefulBuilder(builder:
                                                            (context,
                                                                setStateful) {
                                                      return Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            2.9,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        margin: const EdgeInsets
                                                            .only(top: 10),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Text(
                                                              'Phản hồi của bạn',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                            const CrossBar(),
                                                            Column(
                                                              children:
                                                                  List.generate(
                                                                      iconEventCare
                                                                          .length,
                                                                      (indexGes) =>
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              ref.read(eventControllerProvider.notifier).updateStatusEvent(events[index]['id'], {
                                                                                'status': iconEventCare[indexGes]['key']
                                                                              });
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                ListTile(
                                                                              dense: true,
                                                                              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                                                                              visualDensity: const VisualDensity(horizontal: -4, vertical: -1),
                                                                              leading: Icon(iconEventCare[indexGes]['icon'], color: Colors.black),
                                                                              title: Text(iconEventCare[indexGes]['label'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                                                              trailing: Radio(
                                                                                  groupValue: events[index]['event_relationship']['status'],
                                                                                  value: iconEventCare[indexGes]['key'],
                                                                                  onChanged: (value) {
                                                                                    ref.read(eventControllerProvider.notifier).updateStatusEvent(events[index]['id'], {
                                                                                      'status': value
                                                                                    });
                                                                                    Navigator.pop(context);
                                                                                  }),
                                                                            ),
                                                                          )),
                                                            ),
                                                            const CrossBar(),
                                                            const ListTile(
                                                              dense: true,
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          0.0),
                                                              visualDensity:
                                                                  VisualDensity(
                                                                      horizontal:
                                                                          -4,
                                                                      vertical:
                                                                          -4),
                                                              leading: Icon(
                                                                FontAwesomeIcons
                                                                    .userGroup,
                                                                color: Colors
                                                                    .black,
                                                                size: 20,
                                                              ),
                                                              title: Text.rich(
                                                                TextSpan(
                                                                  text:
                                                                      'Hiển thị với người tổ chức và',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                  children: <
                                                                      InlineSpan>[
                                                                    TextSpan(
                                                                      text:
                                                                          ' Bạn bè',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w900),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              trailing: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            15.0),
                                                                child: Icon(
                                                                  FontAwesomeIcons
                                                                      .chevronRight,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 20,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                                  );
                                                }
                                                if (events[index][
                                                            'event_relationship']
                                                        ['status'] ==
                                                    '') {
                                                  ref
                                                      .read(
                                                          eventControllerProvider
                                                              .notifier)
                                                      .updateStatusEvent(
                                                          events[index]['id'], {
                                                    'status': 'interested'
                                                  });
                                                }
                                              },
                                              child: Container(
                                                height: 24,
                                                width: width * 0.8,
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 5, 10),
                                                decoration: BoxDecoration(
                                                    color: events[index][
                                                                    'event_relationship']
                                                                ['status'] !=
                                                            ''
                                                        ? secondaryColor
                                                        : const Color.fromARGB(
                                                            189, 202, 202, 202),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    border: Border.all(
                                                        width: 0.2,
                                                        color: greyColor)),
                                                child: events[index][
                                                                'event_relationship']
                                                            ['status'] ==
                                                        'interested'
                                                    ? Row(
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
                                                                    .solidStar,
                                                                color: Colors
                                                                    .black,
                                                                size: 14),
                                                          ),
                                                          SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          Text(
                                                            'Quan tâm',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        5.0),
                                                            child: Icon(
                                                                FontAwesomeIcons
                                                                    .sortDown,
                                                                color: Colors
                                                                    .black,
                                                                size: 14),
                                                          ),
                                                        ],
                                                      )
                                                    : events[index]['event_relationship']
                                                                ['status'] ==
                                                            'going'
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: const [
                                                              Icon(
                                                                  FontAwesomeIcons
                                                                      .circleCheck,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 14),
                                                              SizedBox(
                                                                width: 5.0,
                                                              ),
                                                              Text(
                                                                'Sẽ tham gia',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5.0,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            4.0),
                                                                child: Icon(
                                                                    FontAwesomeIcons
                                                                        .sortDown,
                                                                    color: Colors
                                                                        .black,
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
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            3.0),
                                                                child: Icon(
                                                                    FontAwesomeIcons
                                                                        .solidStar,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 14),
                                                              ),
                                                              SizedBox(
                                                                width: 5.0,
                                                              ),
                                                              Text(
                                                                'Quan tâm',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 3.0,
                                                              ),
                                                            ],
                                                          ),
                                              )),
                                          GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        top:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    context: context,
                                                    builder: (context) =>
                                                        const ShareModalBottom());
                                              },
                                              child: Container(
                                                height: 24,
                                                width: width * 0.085,
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        2, 0, 0, 10),
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        189, 202, 202, 202),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    border: Border.all(
                                                        width: 0.2,
                                                        color: greyColor)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(FontAwesomeIcons.share,
                                                        color: Colors.black,
                                                        size: 14),
                                                  ],
                                                ),
                                              ))
                                        ],
                                      ),
                                    )
                                  ]),
                                ],
                              ),
                              SizedBox(
                                width: width,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  height: 24,
                                                  width: 24,
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          34, 8, 0, 8),
                                                  decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      border: Border.all(
                                                          width: 0.2,
                                                          color: greyColor)),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Icon(
                                                          FontAwesomeIcons
                                                              .ellipsis,
                                                          color: Colors.white,
                                                          size: 16),
                                                    ],
                                                  ),
                                                )),
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  height: 24,
                                                  width: 24,
                                                  margin:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      border: Border.all(
                                                          width: 0.2,
                                                          color: greyColor)),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Icon(
                                                          FontAwesomeIcons
                                                              .xmark,
                                                          color: Colors.white,
                                                          size: 16),
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                            ]),
                          ),
                        ),
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
