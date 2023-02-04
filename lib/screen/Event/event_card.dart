import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/data/event.dart';
import 'package:social_network_app_mobile/screen/Event/event_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/share_modal_bottom.dart';

import 'event_detail.dart';

class EventCard extends StatefulWidget {
  final dynamic event;
  const EventCard({Key? key, this.event}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _EventCartState createState() => _EventCartState();
}

class _EventCartState extends State<EventCard> {
  late double width;
  late double height;

  @override
  void initState() {
    GetTimeAgo.setDefaultLocale('vi');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isCare = Provider.of<EventProvider>(context).getEventProvider;
    print(isCare);
    List iconEventCare = [
      {
        "key": "event-care",
        "label": "Quan tâm",
        "icon": FontAwesomeIcons.solidStar
      },
      {
        "key": "event-join",
        "label": "Sẽ tham gia",
        "icon": FontAwesomeIcons.circleCheck
      },
      {
        "key": "event-not-join",
        "label": "Không tham gia",
        "icon": FontAwesomeIcons.circleXmark
      },
    ];
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Expanded(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: eventData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 6),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => EventDetail(
                                        eventDetail: eventData[index],
                                      )));
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 8.0,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Stack(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  child: ImageCacheRender(
                                    path: eventData[index]['banner']
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
                                                eventData[index]['start_time']),
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
                                          eventData[index]['title'],
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: Text(
                                          // eventData[index]['location'],
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
                                          '${eventData[index]['users_interested_count'].toString()} người quan tâm · ${eventData[index]['users_going_count'].toString()} người tham gia ',
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
                                              context
                                                  .read<EventProvider>()
                                                  .setEVentProvider(
                                                      index, 'interested');
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
                                                    StatefulBuilder(builder:
                                                        (context, setStateful) {
                                                  return Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.28,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: Column(
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
                                                          children:
                                                              List.generate(
                                                            iconEventCare
                                                                .length,
                                                            (indexGes) =>
                                                                GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                                if (iconEventCare[
                                                                            indexGes]
                                                                        [
                                                                        'key'] ==
                                                                    'event-join') {
                                                                  // context
                                                                  //     .read<
                                                                  //         EventProvider>()
                                                                  //     .remove(
                                                                  //         index);
                                                                }
                                                              },
                                                              child: Container(
                                                                color: Colors
                                                                    .transparent,
                                                                child: Row(
                                                                  children: [
                                                                    const SizedBox(
                                                                        width:
                                                                            10),
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      constraints:
                                                                          BoxConstraints(
                                                                              minWidth: MediaQuery.of(context).size.width * 0.1),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Icon(
                                                                          iconEventCare[indexGes]
                                                                              [
                                                                              'icon'],
                                                                          size:
                                                                              24,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      constraints:
                                                                          BoxConstraints(
                                                                              minWidth: MediaQuery.of(context).size.width * 0.4 - 10),
                                                                      child:
                                                                          Text(
                                                                        iconEventCare[indexGes]
                                                                            [
                                                                            'label'],
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      constraints:
                                                                          BoxConstraints(
                                                                              minWidth: MediaQuery.of(context).size.width * 0.5),
                                                                      child:
                                                                          Radio(
                                                                        value:
                                                                            "",
                                                                        groupValue:
                                                                            '',
                                                                        onChanged:
                                                                            (value) {},
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const CrossBar(),
                                                        GestureDetector(
                                                          onTap: () {},
                                                          child: Row(
                                                            children: [
                                                              const SizedBox(
                                                                  width: 8),
                                                              Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                constraints: BoxConstraints(
                                                                    minWidth: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.1),
                                                                child:
                                                                    const Icon(
                                                                  FontAwesomeIcons
                                                                      .userGroup,
                                                                  size: 20,
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                constraints: BoxConstraints(
                                                                    minWidth:
                                                                        MediaQuery.of(context).size.width *
                                                                                0.4 -
                                                                            10),
                                                                child: const Text.rich(TextSpan(
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
                                                                    ])),
                                                              ),
                                                              Container(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                constraints: BoxConstraints(
                                                                    minWidth:
                                                                        MediaQuery.of(context).size.width *
                                                                                0.44 -
                                                                            38),
                                                                child:
                                                                    const Icon(
                                                                  FontAwesomeIcons
                                                                      .chevronRight,
                                                                  size: 20,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              );
                                            },
                                            child: Container(
                                              height: 24,
                                              width: width * 0.8,
                                              margin: const EdgeInsets.fromLTRB(
                                                  10, 0, 3, 10),
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      189, 202, 202, 202),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  border: Border.all(
                                                      width: 0.2,
                                                      color: greyColor)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(
                                                      FontAwesomeIcons
                                                          .solidStar,
                                                      color: Colors.black,
                                                      size: 14),
                                                  SizedBox(
                                                    width: 3.0,
                                                  ),
                                                  Text(
                                                    'Quan tâm',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 3.0,
                                                  ),
                                                  // Icon(
                                                  //     (isCare.length > 0
                                                  //         ? (isCare.contains(
                                                  //                 index))
                                                  //             ? FontAwesomeIcons
                                                  //                 .solidStar
                                                  //             : null
                                                  //         : null),
                                                  //     color: Colors.black,
                                                  //     size: 14),
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
                                                      top: Radius.circular(10),
                                                    ),
                                                  ),
                                                  context: context,
                                                  builder: (context) =>
                                                      const ShareModalBottom());
                                            },
                                            child: Container(
                                              height: 24,
                                              width: width * 0.1,
                                              margin: const EdgeInsets.fromLTRB(
                                                  2, 0, 0, 10),
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
                                                      MainAxisAlignment.center,
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
                                                margin: const EdgeInsets.all(8),
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
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(FontAwesomeIcons.xmark,
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
    ));
  }
}
