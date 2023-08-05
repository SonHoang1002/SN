import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/data/event.dart';
import 'package:social_network_app_mobile/providers/event_provider.dart';
import 'package:social_network_app_mobile/screens/Event/event_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';
import 'package:social_network_app_mobile/widgets/share_modal_bottom.dart';

class EventInvite extends ConsumerStatefulWidget {
  final dynamic event;
  const EventInvite({Key? key, this.event}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<EventInvite> createState() => _EventInviteState();
}

class _EventInviteState extends ConsumerState<EventInvite> {
  late double width;
  late double height;
  bool eventAction = true;
  var paramsConfig = {"limit": 10};
  bool isLoading = false;
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
      isLoading = true;
    });
    await ref
        .read(eventControllerProvider.notifier)
        .getListInvite(paramsConfig);
    setState(() {
      isLoading = false;
    });
  }

  void _fetchGetListInviteHost() async {
    setState(() {
      isLoading = true;
    });
    await ref.read(eventControllerProvider.notifier).getListInviteHost();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List events = ref.watch(eventControllerProvider).eventsInvite;
    List eventsInviteHost = ref.watch(eventControllerProvider).eventsInviteHost;
    final theme = pv.Provider.of<ThemeManager>(context);
    final size = MediaQuery.sizeOf(context);
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
                        width: MediaQuery.sizeOf(context).width * 0.43,
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
                        width: MediaQuery.sizeOf(context).width * 0.43,
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
                ? events.isNotEmpty
                    ? SizedBox(
                        child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: events.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, indexInteresting) {
                          String statusEvent = events[indexInteresting]['event']
                                  ['event_relationship']['status'] ??
                              '';

                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                            child: CardComponents(
                              // type: 'homeScreen',
                              imageCard: SizedBox(
                                height: 180,
                                width: width,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  child: ImageCacheRender(
                                    path: events[indexInteresting]['event']
                                                ['banner'] !=
                                            null
                                        ? events[indexInteresting]['event']
                                            ['banner']['url']
                                        : linkBannerDefault,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => EventDetail(
                                            eventDetail:
                                                events[indexInteresting]
                                                    ['event'])));
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
                                        GetTimeAgo.parse(DateTime.parse(
                                            events[indexInteresting]['event']
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
                                        events[indexInteresting]['event']
                                            ['title'],
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        '${events[indexInteresting]['event']['users_interested_count'].toString()} người quan tâm · ${events[indexInteresting]['event']['users_going_count'].toString()} người tham gia ',
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
                                          if (statusEvent != '') {
                                            showModalBottomSheet(
                                              isScrollControlled: true,
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
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2.9,
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
                                                            iconEventCare
                                                                .length,
                                                            (indexGes) =>
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    ref
                                                                        .read(eventControllerProvider
                                                                            .notifier)
                                                                        .updateStatusInvite(
                                                                            events[indexInteresting]['event']['id'],
                                                                            {
                                                                          'status':
                                                                              iconEventCare[indexGes]['key']
                                                                        });
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      ListTile(
                                                                    dense: true,
                                                                    contentPadding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8.0,
                                                                        vertical:
                                                                            0.0),
                                                                    visualDensity: const VisualDensity(
                                                                        horizontal:
                                                                            -4,
                                                                        vertical:
                                                                            -1),
                                                                    leading: Icon(
                                                                        iconEventCare[indexGes]
                                                                            [
                                                                            'icon'],
                                                                        color: Colors
                                                                            .black),
                                                                    title: Text(
                                                                        iconEventCare[indexGes]
                                                                            [
                                                                            'label'],
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w600)),
                                                                    trailing: Radio(
                                                                        groupValue: statusEvent,
                                                                        value: iconEventCare[indexGes]['key'],
                                                                        onChanged: (value) {
                                                                          ref.read(eventControllerProvider.notifier).updateStatusInvite(
                                                                              events[indexInteresting]['event']['id'],
                                                                              {
                                                                                'status': value
                                                                              });
                                                                          setState(
                                                                              () {
                                                                            statusEvent =
                                                                                value;
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                        }),
                                                                  ),
                                                                )),
                                                      ),
                                                      const CrossBar(),
                                                      const ListTile(
                                                        dense: true,
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical:
                                                                        0.0),
                                                        visualDensity:
                                                            VisualDensity(
                                                                horizontal: -4,
                                                                vertical: -4),
                                                        leading: Icon(
                                                          FontAwesomeIcons
                                                              .userGroup,
                                                          color: Colors.black,
                                                          size: 20,
                                                        ),
                                                        title: Text.rich(
                                                          TextSpan(
                                                            text:
                                                                'Hiển thị với người tổ chức và',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                            children: <InlineSpan>[
                                                              TextSpan(
                                                                text: ' Bạn bè',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        trailing: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 15.0),
                                                          child: Icon(
                                                            FontAwesomeIcons
                                                                .chevronRight,
                                                            color: Colors.black,
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
                                          if (statusEvent == '') {
                                            ref
                                                .read(eventControllerProvider
                                                    .notifier)
                                                .updateStatusEvent(
                                                    events[indexInteresting]
                                                        ['event']['id'],
                                                    {'status': 'interested'});
                                            setState(() {
                                              statusEvent = 'interested';
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
                                          child: Container(
                                            height: 32,
                                            width: width * 0.7,
                                            decoration: BoxDecoration(
                                                color: statusEvent != ""
                                                    ? secondaryColor
                                                    : const Color.fromARGB(
                                                        189, 202, 202, 202),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    width: 0.2,
                                                    color: greyColor)),
                                            child: statusEvent == 'interested'
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets
                                                                    .only(
                                                                bottom: 3.0),
                                                        child: Icon(
                                                            FontAwesomeIcons
                                                                .solidStar,
                                                            color: Colors.white,
                                                            size: 14),
                                                      ),
                                                      const SizedBox(
                                                        width: 5.0,
                                                      ),
                                                      const Text(
                                                        'Quan tâm',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Colors.white),
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
                                                : statusEvent == 'going'
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                              FontAwesomeIcons
                                                                  .circleCheck,
                                                              color:
                                                                  Colors.white,
                                                              size: 14),
                                                          const SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          const Text(
                                                            'Sẽ tham gia',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .white),
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
                                                    : const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
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
                                                  ShareModalBottom(
                                                      type: 'event',
                                                      data: events[
                                                          indexInteresting]));
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
                : eventsInviteHost.isNotEmpty
                    ? SizedBox(
                        child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: eventsInviteHost.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, indexHost) {
                          String statusHost =
                              eventsInviteHost[indexHost]['status'] ?? '';
                          if (indexHost < eventsInviteHost.length) {
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
                                    child: ImageCacheRender(
                                      path: eventsInviteHost[indexHost]['event']
                                                  ['banner'] !=
                                              null
                                          ? eventsInviteHost[indexHost]['event']
                                              ['banner']['url']
                                          : linkBannerDefault,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => EventDetail(
                                              eventDetail:
                                                  eventsInviteHost[indexHost]
                                                      ['event'])));
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
                                              eventsInviteHost[indexHost]
                                                  ['event']['start_time'])),
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
                                          eventsInviteHost[indexHost]['event']
                                              ['title'],
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                          '${eventsInviteHost[indexHost]['event']['users_interested_count'].toString()} người quan tâm · ${eventsInviteHost[indexHost]['event']['users_going_count'].toString()} người tham gia ',
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
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2.9,
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
                                                            iconEventHost
                                                                .length,
                                                            (indexGes) =>
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    ref
                                                                        .read(eventControllerProvider
                                                                            .notifier)
                                                                        .updateStatusInviteHost(
                                                                            eventsInviteHost[indexHost]['event']['id'],
                                                                            {
                                                                          'status':
                                                                              iconEventHost[indexGes]['key']
                                                                        });
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      ListTile(
                                                                    dense: true,
                                                                    contentPadding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8.0,
                                                                        vertical:
                                                                            0.0),
                                                                    visualDensity: const VisualDensity(
                                                                        horizontal:
                                                                            -4,
                                                                        vertical:
                                                                            -1),
                                                                    title: Text(
                                                                        iconEventHost[indexGes]
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
                                                                          ref.read(eventControllerProvider.notifier).updateStatusInviteHost(
                                                                              eventsInviteHost[indexHost]['event']['id'],
                                                                              {
                                                                                'status': value
                                                                              });
                                                                          setState(
                                                                              () {
                                                                            statusHost =
                                                                                value;
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                        }),
                                                                  ),
                                                                )),
                                                      ),
                                                      const CrossBar(),
                                                      const ListTile(
                                                        dense: true,
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical:
                                                                        0.0),
                                                        visualDensity:
                                                            VisualDensity(
                                                                horizontal: -4,
                                                                vertical: -4),
                                                        leading: Icon(
                                                          FontAwesomeIcons
                                                              .userGroup,
                                                          color: Colors.black,
                                                          size: 20,
                                                        ),
                                                        title: Text.rich(
                                                          TextSpan(
                                                            text:
                                                                'Hiển thị với người tổ chức và',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                            children: <InlineSpan>[
                                                              TextSpan(
                                                                text: ' Bạn bè',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        trailing: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 15.0),
                                                          child: Icon(
                                                            FontAwesomeIcons
                                                                .chevronRight,
                                                            color: Colors.black,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 3.0),
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
                                                                  FontWeight
                                                                      .w700,
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
                                                                    ? Colors
                                                                        .white
                                                                    : secondaryColor,
                                                                size: 14),
                                                            const SizedBox(
                                                              width: 5.0,
                                                            ),
                                                            Text(
                                                              'Từ chối',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.0,
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
                                                      : const Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
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
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.0,
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
                                                  ShareModalBottom(
                                                type: 'event',
                                                data:
                                                    eventsInviteHost[indexHost],
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
                          } else {
                            const SizedBox();
                          }
                          return null;
                        },
                      ))
                    : const SizedBox(),
            isLoading &&
                    (eventAction && events.isEmpty ||
                        !eventAction && eventsInviteHost.isEmpty)
                ? const Center(child: CupertinoActivityIndicator())
                : (eventAction && events.isEmpty ||
                        !eventAction && eventsInviteHost.isEmpty)
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
        )),
      ),
    );
  }
}
