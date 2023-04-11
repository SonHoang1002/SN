import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/data/event.dart';
import 'package:social_network_app_mobile/providers/event_provider.dart';
import 'package:social_network_app_mobile/screen/Event/event_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/card_components.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/share_modal_bottom.dart';

class EventInterested extends ConsumerStatefulWidget {
  final dynamic event;
  const EventInterested({Key? key, this.event}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<EventInterested> createState() => _EventInterestedState();
}

class _EventInterestedState extends ConsumerState<EventInterested> {
  late double width;
  late double height;
  var paramsConfigOwner = {"limit": 10, "event_account_status": "interested"};

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(
        Duration.zero,
        () => ref
            .read(eventControllerProvider.notifier)
            .getListEventOwner(paramsConfigOwner));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List events = ref.watch(eventControllerProvider).eventsOwner;
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
                'Sự kiện đã quan tâm',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            events.isNotEmpty
                ? SizedBox(
                    child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: events.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, indexInteresting) {
                      String statusEvent = events[indexInteresting]
                              ['event_relationship']['status'] ??
                          '';
                      if (indexInteresting < events.length) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                          child: CardComponents(
                            type: 'homeScreen',
                            imageCard: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              child: ImageCacheRender(
                                path: events[indexInteresting]['banner']['url'],
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  bottom: 16.0, left: 16, right: 16),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: InkWell(
                                      onTap: () {
                                        if (statusEvent != '') {
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
                                                          iconEventCare.length,
                                                          (indexGes) =>
                                                              GestureDetector(
                                                                onTap: () {
                                                                  ref
                                                                      .read(eventControllerProvider
                                                                          .notifier)
                                                                      .updateStatusEvents(
                                                                          events[indexInteresting]
                                                                              ['id'],
                                                                          {
                                                                        'status':
                                                                            iconEventCare[indexGes]['key']
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
                                                                  leading: Icon(
                                                                      iconEventCare[
                                                                              indexGes]
                                                                          [
                                                                          'icon'],
                                                                      color: Colors
                                                                          .black),
                                                                  title: Text(
                                                                      iconEventCare[
                                                                              indexGes]
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
                                                                        ref.read(eventControllerProvider.notifier).updateStatusEvents(
                                                                            events[indexInteresting]['id'],
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
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8.0,
                                                              vertical: 0.0),
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
                                                          children: <
                                                              InlineSpan>[
                                                            TextSpan(
                                                              text: ' Bạn bè',
                                                              style: TextStyle(
                                                                  fontSize: 12,
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
                                              .updateStatusEvents(
                                                  events[indexInteresting]
                                                      ['id'],
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
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 3.0),
                                                      child: Icon(
                                                          FontAwesomeIcons
                                                              .solidStar,
                                                          color: Colors.white,
                                                          size: 14),
                                                    ),
                                                    SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Text(
                                                      'Quan tâm',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white),
                                                    ),
                                                    SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 5.0),
                                                      child: Icon(
                                                          FontAwesomeIcons
                                                              .sortDown,
                                                          color: Colors.white,
                                                          size: 14),
                                                    ),
                                                  ],
                                                )
                                              : statusEvent == 'going'
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Icon(
                                                            FontAwesomeIcons
                                                                .circleCheck,
                                                            color: Colors.white,
                                                            size: 14),
                                                        SizedBox(
                                                          width: 5.0,
                                                        ),
                                                        Text(
                                                          'Sẽ tham gia',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        SizedBox(
                                                          width: 5.0,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 4.0),
                                                          child: Icon(
                                                              FontAwesomeIcons
                                                                  .sortDown,
                                                              color:
                                                                  Colors.white,
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
                                                                  bottom: 3.0),
                                                          child: Icon(
                                                              FontAwesomeIcons
                                                                  .solidStar,
                                                              color:
                                                                  Colors.black,
                                                              size: 14),
                                                        ),
                                                        SizedBox(
                                                          width: 5.0,
                                                        ),
                                                        Text(
                                                          'Quan tâm',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  Colors.black),
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
                                        height: 32,
                                        width: width * 0.12,
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
                          ),
                        );
                      } else {
                        isMore == true
                            ? const Center(child: CupertinoActivityIndicator())
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
