import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/data/event.dart';
import 'package:social_network_app_mobile/providers/event_provider.dart';
import 'package:social_network_app_mobile/screen/Event/event_discuss.dart';
import 'package:social_network_app_mobile/screen/Event/event_intro.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/icon_action_ellipsis.dart';
import 'package:social_network_app_mobile/widget/modal_invite_friend.dart';

class EventDetail extends ConsumerStatefulWidget {
  final dynamic eventDetail;
  const EventDetail({Key? key, this.eventDetail}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends ConsumerState<EventDetail> {
  final ScrollController _scrollController = ScrollController();
  bool _isVisible = false;
  bool eventAction = true;
  late double width;
  late double height;
  var paramsConfig = {"limit": 4};
  dynamic eventDetail = {};

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    loadData();
    _scrollController.addListener(() {
      if (_scrollController.offset > 200) {
        setState(() {
          _isVisible = true;
        });
      } else {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  void loadData() async {
    await ref
        .read(eventControllerProvider.notifier)
        .getDetailEvent(widget.eventDetail['id'])
        .then((value) {
      setState(() {
        eventDetail = ref.read(eventControllerProvider).eventDetail;
      });
    });
    await ref
        .read(eventControllerProvider.notifier)
        .getListEventSuggested(paramsConfig);
    await ref
        .read(eventControllerProvider.notifier)
        .getEventHosts(widget.eventDetail['id']);
    await ref
        .read(eventControllerProvider.notifier)
        .getListGroupSuggested({"tab": 'featured'});
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    final theme = pv.Provider.of<ThemeManager>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pop(context);
          },
          child: eventDetail['title'] != null
              ? Container(
                  height: 26,
                  width: 26,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(width: 0.2, color: greyColor)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(FontAwesomeIcons.angleLeft,
                          color: Colors.white, size: 16),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
        elevation: 0.0,
      ),
      body: eventDetail.isNotEmpty
          ? Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(eventControllerProvider.notifier)
                        .getDetailEvent(widget.eventDetail['id']);
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height * 0.3,
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
                              child: ClipRRect(
                                child: ExtendedImage.network(
                                        eventDetail['banner']!= null
                                            ? eventDetail['banner']['url']
                                            : linkBannerDefault,
                                        fit: BoxFit.cover,
                                      )
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GetTimeAgo.parse(
                                    DateTime.parse(eventDetail['start_time']),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    eventDetail['title'],
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    '${eventDetail['users_interested_count'].toString()} người quan tâm · ${eventDetail['users_going_count'].toString()} người tham gia ',
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: greyColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 16.0),
                                  child: Row(children: [
                                    InkWell(
                                        onTap: () {
                                          if (eventDetail['event_relationship']
                                                  ['status'] !=
                                              'interested') {
                                            ref
                                                .read(eventControllerProvider
                                                    .notifier)
                                                .updateStatusEventDetail(
                                                    eventDetail['id'],
                                                    {'status': 'interested'});
                                          } else {
                                            ref
                                                .read(eventControllerProvider
                                                    .notifier)
                                                .updateStatusEventDetail(
                                                    eventDetail['id'],
                                                    {'status': ''});
                                          }
                                          setState(() {});
                                        },
                                        child: Row(
                                          children: !eventDetail[
                                                      'event_relationship']
                                                  ['host_event']
                                              ? [
                                                  Container(
                                                      height: 32,
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.47,
                                                      decoration: BoxDecoration(
                                                          color: eventDetail['event_relationship']
                                                                      [
                                                                      'status'] !=
                                                                  'interested'
                                                              ? const Color.fromARGB(
                                                                  189,
                                                                  202,
                                                                  202,
                                                                  202)
                                                              : secondaryColor,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  4),
                                                          border: Border.all(
                                                              width: 0.2,
                                                              color: greyColor)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Icon(
                                                              FontAwesomeIcons
                                                                  .solidStar,
                                                              size: 14),
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
                                                        ],
                                                      )),
                                                  const SizedBox(width: 10),
                                                  InkWell(
                                                      onTap: () {
                                                        if (eventDetail[
                                                                    'event_relationship']
                                                                ['status'] !=
                                                            'going') {
                                                          ref
                                                              .read(
                                                                  eventControllerProvider
                                                                      .notifier)
                                                              .updateStatusEventDetail(
                                                                  eventDetail[
                                                                      'id'],
                                                                  {
                                                                'status':
                                                                    'going'
                                                              });
                                                        } else {
                                                          ref
                                                              .read(
                                                                  eventControllerProvider
                                                                      .notifier)
                                                              .updateStatusEventDetail(
                                                                  eventDetail[
                                                                      'id'],
                                                                  {
                                                                'status': ''
                                                              });
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 32,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                        decoration: BoxDecoration(
                                                            color: eventDetail['event_relationship']
                                                                        [
                                                                        'status'] !=
                                                                    'going'
                                                                ? const Color
                                                                        .fromARGB(
                                                                    189,
                                                                    202,
                                                                    202,
                                                                    202)
                                                                : secondaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            border: Border.all(
                                                                width: 0.2,
                                                                color:
                                                                    greyColor)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                                eventDetail['event_relationship']
                                                                            [
                                                                            'status'] !=
                                                                        'going'
                                                                    ? FontAwesomeIcons
                                                                        .clipboardQuestion
                                                                    : FontAwesomeIcons
                                                                        .circleCheck,
                                                                size: 14),
                                                            const SizedBox(
                                                              width: 3.0,
                                                            ),
                                                            const Text(
                                                              'Sẽ tham gia',
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
                                                          ],
                                                        ),
                                                      )),
                                                ]
                                              : [
                                                  InkWell(
                                                    onTap: () {
                                                      showBarModalBottomSheet(
                                                          context: context,
                                                          backgroundColor: theme
                                                                  .isDarkMode
                                                              ? Colors.black
                                                              : Colors.white,
                                                          builder: (context) =>
                                                              const InviteFriend());
                                                    },
                                                    child: Container(
                                                        height: 32,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        decoration: BoxDecoration(
                                                            color: const Color
                                                                    .fromARGB(
                                                                189,
                                                                202,
                                                                202,
                                                                202),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            border: Border.all(
                                                                width: 0.2,
                                                                color:
                                                                    greyColor)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Icon(
                                                                FontAwesomeIcons
                                                                    .envelope,
                                                                size: 14),
                                                            SizedBox(
                                                              width: 5.0,
                                                            ),
                                                            Text(
                                                              'Mời',
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
                                                          ],
                                                        )),
                                                  )
                                                ],
                                        )),
                                    const SizedBox(width: 10),
                                    InkWell(
                                        onTap: () {
                                          showBarModalBottomSheet(
                                            backgroundColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            context: context,
                                            builder: (context) => Container(
                                              margin: const EdgeInsets.only(
                                                  left: 8.0, top: 15.0),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 250,
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
                                                                bottom: 10.0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            if (index != 1 &&
                                                                index != 2) {
                                                              showBarModalBottomSheet(
                                                                  backgroundColor:
                                                                      Theme.of(
                                                                              context)
                                                                          .scaffoldBackgroundColor,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          SizedBox(
                                                                            height:
                                                                                height * 0.9,
                                                                            width:
                                                                                width,
                                                                            child:
                                                                                ActionEllipsis(menuSelected: iconActionEllipsis[index]),
                                                                          ));
                                                            } else if (index ==
                                                                2) {
                                                              Clipboard.setData(
                                                                  ClipboardData(
                                                                      text: eventAction
                                                                          ? 'https://sn.emso.vn/event/${eventDetail['id']}/about'
                                                                          : 'https://sn.emso.vn/event/${eventDetail['id']}/discussion'));
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                content: Text(
                                                                    'Sao chép thành công'),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            3),
                                                                backgroundColor:
                                                                    secondaryColor,
                                                              ));
                                                            } else {
                                                              const SizedBox();
                                                            }
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 4.0,
                                                                    bottom:
                                                                        4.0),
                                                            child: Row(
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 18.0,
                                                                  backgroundColor:
                                                                      greyColor[
                                                                          350],
                                                                  child: Icon(
                                                                    iconActionEllipsis[
                                                                            index]
                                                                        [
                                                                        "icon"],
                                                                    size: 18.0,
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
                                                                      iconActionEllipsis[
                                                                              index]
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
                                                        ),
                                                      );
                                                    }),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 32,
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
                                              Icon(FontAwesomeIcons.ellipsis,
                                                  size: 14),
                                            ],
                                          ),
                                        ))
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                  FontAwesomeIcons.stopwatch,
                                                  size: 20),
                                              const SizedBox(
                                                width: 9.0,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0),
                                                child: Text(
                                                  GetTimeAgo.parse(
                                                    DateTime.parse(eventDetail[
                                                        'start_time']),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                    FontAwesomeIcons.solidUser,
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
                                                      text: 'Sự kiện của ',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: colorWord(
                                                              context)),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: eventDetail[
                                                                    'account'][
                                                                'display_name'],
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: colorWord(
                                                                    context))),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                    FontAwesomeIcons
                                                        .clipboardCheck,
                                                    size: 20),
                                                const SizedBox(
                                                  width: 9.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4.0),
                                                  child: Text(
                                                    '${eventDetail['users_interested_count'].toString()} người quan tâm · ${eventDetail['users_going_count'].toString()} người tham gia ',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                    FontAwesomeIcons
                                                        .earthAmericas,
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: Row(
                                          children: [
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    eventAction = true;
                                                  });
                                                },
                                                child: Container(
                                                  height: 35,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.44,
                                                  decoration: BoxDecoration(
                                                      color: eventAction
                                                          ? secondaryColor
                                                          : const Color
                                                                  .fromARGB(189,
                                                              202, 202, 202),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      border: Border.all(
                                                          width: 0.2,
                                                          color: greyColor)),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Giới thiệu',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                            color: eventAction
                                                                ? Colors.white
                                                                : colorWord(
                                                                    context),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ]),
                                                )),
                                            const SizedBox(width: 16),
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    eventAction = false;
                                                  });
                                                },
                                                child: Container(
                                                  height: 35,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.44,
                                                  decoration: BoxDecoration(
                                                      color: !eventAction
                                                          ? secondaryColor
                                                          : const Color
                                                                  .fromARGB(189,
                                                              202, 202, 202),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      border: Border.all(
                                                          width: 0.2,
                                                          color: greyColor)),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Cuộc thảo luận',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: !eventAction
                                                              ? Colors.white
                                                              : colorWord(
                                                                  context),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        height: 20,
                                        thickness: 1,
                                      ),
                                      eventAction
                                          ? EventIntro(
                                              eventDetail: eventDetail,
                                            )
                                          : EventDiscuss(
                                              eventDetail: eventDetail)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                !eventDetail['event_relationship']['host_event']
                    ? Visibility(
                        visible: _isVisible,
                        child: Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 60,
                            color:
                                theme.isDarkMode ? Colors.black : Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: InkWell(
                                      onTap: () {
                                        if (eventDetail['event_relationship']
                                                ['status'] !=
                                            'interested') {
                                          ref
                                              .read(eventControllerProvider
                                                  .notifier)
                                              .updateStatusEventDetail(
                                                  eventDetail['id'],
                                                  {'status': 'interested'});
                                        } else {
                                          ref
                                              .read(eventControllerProvider
                                                  .notifier)
                                              .updateStatusEventDetail(
                                                  eventDetail['id'],
                                                  {'status': ''});
                                        }
                                        setState(() {});
                                      },
                                      child: Container(
                                          height: 32,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          decoration: BoxDecoration(
                                              color:
                                                  eventDetail['event_relationship']
                                                              ['status'] !=
                                                          'interested'
                                                      ? const Color.fromARGB(
                                                          189, 202, 202, 202)
                                                      : secondaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                  width: 0.2,
                                                  color: greyColor)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(FontAwesomeIcons.solidStar,
                                                  size: 14),
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              Text(
                                                'Quan tâm',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ))),
                                ),
                                InkWell(
                                    onTap: () {
                                      if (eventDetail['event_relationship']
                                              ['status'] !=
                                          'going') {
                                        ref
                                            .read(eventControllerProvider
                                                .notifier)
                                            .updateStatusEventDetail(
                                                eventDetail['id'],
                                                {'status': 'going'});
                                      } else {
                                        ref
                                            .read(eventControllerProvider
                                                .notifier)
                                            .updateStatusEventDetail(
                                                eventDetail['id'],
                                                {'status': ''});
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 32,
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      decoration: BoxDecoration(
                                          color:
                                              eventDetail['event_relationship']
                                                          ['status'] !=
                                                      'going'
                                                  ? const Color.fromARGB(
                                                      189, 202, 202, 202)
                                                  : secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              width: 0.2, color: greyColor)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                              eventDetail['event_relationship']
                                                          ['status'] !=
                                                      'going'
                                                  ? FontAwesomeIcons
                                                      .clipboardQuestion
                                                  : FontAwesomeIcons
                                                      .circleCheck,
                                              size: 14),
                                          const SizedBox(
                                            width: 3.0,
                                          ),
                                          const Text(
                                            'Sẽ tham gia',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: InkWell(
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
                                                      iconActionEllipsis.length,
                                                  itemBuilder:
                                                      ((context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                              context: context,
                                                              isScrollControlled:
                                                                  true,
                                                              barrierColor: Colors
                                                                  .transparent,
                                                              clipBehavior: Clip
                                                                  .antiAliasWithSaveLayer,
                                                              shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.vertical(
                                                                          top: Radius.circular(
                                                                              10))),
                                                              builder:
                                                                  (context) =>
                                                                      SizedBox(
                                                                        height: height *
                                                                            0.9,
                                                                        width:
                                                                            width,
                                                                        child: ActionEllipsis(
                                                                            menuSelected:
                                                                                iconActionEllipsis[index]),
                                                                      ));
                                                        },
                                                        child: Row(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 18.0,
                                                              backgroundColor:
                                                                  greyColor[
                                                                      350],
                                                              child: Icon(
                                                                iconActionEllipsis[
                                                                        index]
                                                                    ["icon"],
                                                                size: 18.0,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          10.0),
                                                              child: Text(
                                                                  iconActionEllipsis[
                                                                          index]
                                                                      ["label"],
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 32,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                189, 202, 202, 202),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                                width: 0.2, color: greyColor)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(FontAwesomeIcons.ellipsis,
                                                size: 14),
                                          ],
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            )
          : const Center(
              child: CupertinoActivityIndicator(),
            ),
    );
  }
}
