import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/event_provider.dart';
import 'package:social_network_app_mobile/screen/Event/event_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/card_components.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/modal_invite_friend.dart';
import 'package:social_network_app_mobile/widget/share_modal_bottom.dart';

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
    Future.delayed(
        Duration.zero,
        () => ref
            .read(eventControllerProvider.notifier)
            .getListEventOwner(paramsConfigUpcoming));
    Future.delayed(
        Duration.zero,
        () => ref
            .read(eventControllerProvider.notifier)
            .getListEventHosts(paramsConfigPast));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List events = ref.watch(eventControllerProvider).eventsOwner;
    List eventPast = ref.watch(eventControllerProvider).eventHosts;
    bool isMore = ref.watch(eventControllerProvider).isMore;
    final theme = pv.Provider.of<ThemeManager>(context);

    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    return Expanded(
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
                        });
                      },
                      child: Container(
                        height: 38,
                        width: MediaQuery.of(context).size.width * 0.43,
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
                        });
                      },
                      child: Container(
                        height: 38,
                        width: MediaQuery.of(context).size.width * 0.43,
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
                          if (indexInteresting < events.length) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                              child: CardComponents(
                                imageCard: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  child: ImageCacheRender(
                                    path: events[indexInteresting]['banner'] !=
                                            null
                                        ? events[indexInteresting]['banner']
                                            ['url']
                                        : linkBannerDefault,
                                  ),
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
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
                          } else {
                            isMore == true
                                ? const Center(
                                    child: CupertinoActivityIndicator())
                                : const SizedBox();
                          }
                          return null;
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
                          if (indexPast < eventPast.length) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                              child: CardComponents(
                                imageCard: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  child: ImageCacheRender(
                                    path: eventPast[indexPast]['banner'] != null
                                        ? eventPast[indexPast]['banner']['url']
                                        : linkBannerDefault,
                                  ),
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
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
                          } else {
                            isMore == true
                                ? const Center(
                                    child: CupertinoActivityIndicator())
                                : const SizedBox();
                          }
                          return null;
                        },
                      ))
                    : const SizedBox(),
            isMore == true
                ? const Center(child: CupertinoActivityIndicator())
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
