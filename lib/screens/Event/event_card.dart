import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/data/event.dart';
import 'package:social_network_app_mobile/providers/event_provider.dart';
import 'package:social_network_app_mobile/screens/Event/event_detail.dart';
import 'package:social_network_app_mobile/screens/Event/get_event_later.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/share_modal_bottom.dart';

import '../../widgets/skeleton.dart';

class EventCard extends ConsumerStatefulWidget {
  final dynamic event;
  const EventCard({Key? key, this.event}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<EventCard> createState() => _EventCardState();
}

class _EventCardState extends ConsumerState<EventCard> {
  late double width;
  late double height;
  var paramsConfig = {"limit": 10};
  final scrollController = ScrollController();

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(
        Duration.zero,
        () => ref
            .read(eventControllerProvider.notifier)
            .getListEvent(paramsConfig));
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        String offset =
            ref.read(eventControllerProvider).events.length.toString();
        ref
            .read(eventControllerProvider.notifier)
            .getListEvent({"offset": offset, ...paramsConfig});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List events = ref.watch(eventControllerProvider).events;
    bool isMore = ref.watch(eventControllerProvider).isMore;
    // final theme = pv.Provider.of<ThemeManager>(context);

    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.read(eventControllerProvider.notifier).getListEvent(paramsConfig);
        },
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                child: Text(
                  'Khám phá sự kiện',
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
                                child: ExtendedImage.network(
                                  events[indexInteresting]['banner'] != null
                                      ? events[indexInteresting]['banner']
                                          ['url']
                                      : linkBannerDefault,
                                  fit: BoxFit.cover,
                                ),
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
                                      eventDate(events[indexInteresting]
                                          ['start_time']),
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
                                bottom: 16.0,
                                right: 15.5,
                                left: 15.5,
                              ),
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
                                                                      .updateStatusEvent(
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
                                                                        ref.read(eventControllerProvider.notifier).updateStatusEvent(
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
                                                          children: <InlineSpan>[
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
                                              .updateStatusEvent(
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
                                              ? const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
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
                                                  ? const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
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
                                                  : const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
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
                                        showBarModalBottomSheet(
                                            context: context,
                                            backgroundColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            builder: (context) =>
                                                SingleChildScrollView(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                    context)
                                                                .viewInsets
                                                                .bottom *
                                                            0.35),
                                                    child: ShareModalBottom(
                                                        data: events[
                                                            indexInteresting],
                                                        type: 'event')));
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
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
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
                      },
                    ))
                  : const SizedBox(),
              isMore == true
                  ? Center(child: SkeletonCustom().eventSkeleton(context))
                  : events.isEmpty
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
