import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/event_provider.dart';
import 'package:social_network_app_mobile/screens/Event/event_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';
import 'package:social_network_app_mobile/widgets/modal_invite_friend.dart';
import 'package:social_network_app_mobile/widgets/share_modal_bottom.dart';

import '../../widgets/skeleton.dart';

class EventHost extends ConsumerStatefulWidget {
  final dynamic event;
  const EventHost({Key? key, this.event}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<EventHost> createState() => _EventHostState();
}

class _EventHostState extends ConsumerState<EventHost> {
  late double width;
  late double height;
  bool eventHost = true;
  bool isLoading = false;
  var paramsConfigUpcoming = {
    "limit": 10,
    "event_account_status": "hosting",
    "time": "upcoming"
  };
  var paramsConfigPast = {
    "limit": 10,
    "event_account_status": "hosting",
    "time": "past"
  };

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(Duration.zero, () => _fetchEventsHostsUpcoming());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fetchEventsHostsUpcoming() async {
    setState(() {
      isLoading = true;
    });
    await ref
        .read(eventControllerProvider.notifier)
        .getListEventsHostsUpcoming(paramsConfigUpcoming);
    setState(() {
      isLoading = false;
    });
  }

  void _fetchEventHostsBefore() async {
    setState(() {
      isLoading = true;
    });
    await ref
        .read(eventControllerProvider.notifier)
        .getListEventHosts(paramsConfigPast);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List events = ref.watch(eventControllerProvider).eventsHostsUpcoming;
    List eventPast = ref.watch(eventControllerProvider).eventHosts;
    bool isMore = ref.watch(eventControllerProvider).isMore;
    final theme = pv.Provider.of<ThemeManager>(context);
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          eventHost ? _fetchEventsHostsUpcoming() : _fetchEventHostsBefore();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                child: Text(
                  'Sự kiện bạn tổ chức',
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
                            eventHost = true;
                            _fetchEventsHostsUpcoming();
                          });
                        },
                        child: Container(
                          height: 38,
                          width: MediaQuery.sizeOf(context).width * 0.43,
                          decoration: BoxDecoration(
                              color: eventHost
                                  ? secondaryColor
                                  : const Color.fromARGB(189, 202, 202, 202),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(width: 0.2, color: greyColor)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sắp diễn ra',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: eventHost
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
                            eventHost = false;
                            _fetchEventHostsBefore();
                          });
                        },
                        child: Container(
                          height: 38,
                          width: MediaQuery.sizeOf(context).width * 0.43,
                          decoration: BoxDecoration(
                              color: !eventHost
                                  ? secondaryColor
                                  : const Color.fromARGB(189, 202, 202, 202),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(width: 0.2, color: greyColor)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Trước đây',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w700,
                                  color: !eventHost
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
              eventHost
                  ? events.isNotEmpty
                      ? SizedBox(
                          child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: events.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, indexInteresting) {
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
                                        events[indexInteresting]['banner'] !=
                                                null
                                            ? events[indexInteresting]['banner']
                                                ['url']
                                            : linkBannerDefault,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => EventDetail(
                                              eventDetail:
                                                  events[indexInteresting])));
                                },
                                textCard: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                      right: 16.0,
                                      left: 16.0,
                                      top: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          GetTimeAgo.parse(DateTime.parse(
                                              events[indexInteresting]
                                                  ['start_time'])),
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
                                          events[indexInteresting]['title'],
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          '${events[indexInteresting]['users_interested_count'].toString()} người quan tâm · ${events[indexInteresting]['users_going_count'].toString()} người tham gia ',
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
                                            showBarModalBottomSheet(
                                                context: context,
                                                backgroundColor:
                                                    theme.isDarkMode
                                                        ? Colors.black
                                                        : Colors.white,
                                                builder: (context) =>
                                                    const InviteFriend());
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3.0),
                                            child: Container(
                                              height: 32,
                                              width: width * 0.7,
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
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 1.0),
                                                    child: Icon(
                                                        FontAwesomeIcons
                                                            .envelope,
                                                        color: Colors.black,
                                                        size: 14),
                                                  ),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                    'Mời',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black),
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
                                                  ShareModalBottom(
                                                type: 'event',
                                                data: events[indexInteresting],
                                              ),
                                            );
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
                          },
                        ))
                      : const SizedBox()
                  : eventPast.isNotEmpty
                      ? SizedBox(
                          child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: eventPast.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, indexPast) {
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
                                        eventPast[indexPast]['banner'] != null
                                            ? eventPast[indexPast]['banner']
                                                ['url']
                                            : linkBannerDefault,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => EventDetail(
                                              eventDetail:
                                                  eventPast[indexPast])));
                                },
                                textCard: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                      right: 16.0,
                                      left: 16.0,
                                      top: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          GetTimeAgo.parse(DateTime.parse(
                                              eventPast[indexPast]
                                                  ['start_time'])),
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
                                          eventPast[indexPast]['title'],
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          '${eventPast[indexPast]['users_interested_count'].toString()} người quan tâm · ${eventPast[indexPast]['users_going_count'].toString()} người tham gia ',
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
                                            showBarModalBottomSheet(
                                                context: context,
                                                backgroundColor:
                                                    theme.isDarkMode
                                                        ? Colors.black
                                                        : Colors.white,
                                                builder: (context) =>
                                                    const InviteFriend());
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3.0),
                                            child: Container(
                                              height: 32,
                                              width: width * 0.7,
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
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 1.0),
                                                    child: Icon(
                                                        FontAwesomeIcons
                                                            .envelope,
                                                        color: Colors.black,
                                                        size: 14),
                                                  ),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                    'Mời',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black),
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
                                                  ShareModalBottom(
                                                type: 'event',
                                                data: eventPast[indexPast],
                                              ),
                                            );
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
                          },
                        ))
                      : const SizedBox(),
              isLoading &&
                          (eventHost && events.isEmpty ||
                              !eventHost && eventPast.isEmpty) ||
                      isMore == true
                  ? Center(child: SkeletonCustom().eventSkeleton(context))
                  : (eventHost && events.isEmpty ||
                          !eventHost && eventPast.isEmpty)
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
                      : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
