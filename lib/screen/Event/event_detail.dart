import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:social_network_app_mobile/data/event.dart';
import 'package:social_network_app_mobile/providers/event_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/icon_action_ellipsis.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/share_modal_bottom.dart';

class EventDetail extends ConsumerStatefulWidget {
  final dynamic eventDetail;
  const EventDetail({Key? key, this.eventDetail}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<EventDetail> createState() => _EventDetailState();
}

bool eventAction = true;

class _EventDetailState extends ConsumerState<EventDetail> {
  @override
  final _scrollController = ScrollController();
  bool _isVisible = false;
  late double width;
  late double height;
  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(
        Duration.zero,
        () => ref
            .read(eventControllerProvider.notifier)
            .getEventHosts(widget.eventDetail['id']));
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

  @override
  Widget build(BuildContext context) {
    ref.watch(eventControllerProvider);
    var eventDetail = widget.eventDetail;
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                      child: Hero(
                        tag: eventDetail['banner']['url'],
                        child: ClipRRect(
                          child: ImageCacheRender(
                            path: eventDetail['banner']['url'],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          GetTimeAgo.parse(
                            DateTime.parse(eventDetail['start_time']),
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
                          eventDetail['title'],
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          // eventDetail['location'],
                          'HÀ NỘI · Hà Nội',
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
                          '${eventDetail['users_interested_count'].toString()} người quan tâm · ${eventDetail['users_going_count'].toString()} người tham gia ',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: () {
                              if (eventDetail['event_relationship']['status'] !=
                                  'interested') {
                                ref
                                    .read(eventControllerProvider.notifier)
                                    .updateStatusEvent(eventDetail['id'],
                                        {'status': 'interested'});
                              } else {
                                ref
                                    .read(eventControllerProvider.notifier)
                                    .updateStatusEvent(
                                        eventDetail['id'], {'status': ''});
                              }
                              setState(() {});
                            },
                            child: Container(
                                height: 30,
                                width: MediaQuery.of(context).size.width * 0.5,
                                margin: const EdgeInsets.fromLTRB(10, 0, 6, 10),
                                decoration: BoxDecoration(
                                    color: eventDetail['event_relationship']
                                                ['status'] !=
                                            'interested'
                                        ? secondaryColor
                                        : secondaryColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        width: 0.2, color: greyColor)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FontAwesomeIcons.solidStar,
                                        color: eventDetail['event_relationship']
                                                    ['status'] !=
                                                'interested'
                                            ? Colors.white
                                            : secondaryColor,
                                        size: 14),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      'Quan tâm',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: eventDetail['event_relationship']
                                                    ['status'] !=
                                                'interested'
                                            ? Colors.white
                                            : secondaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ))),
                        InkWell(
                            onTap: () {
                              if (eventDetail['event_relationship']['status'] !=
                                  'going') {
                                ref
                                    .read(eventControllerProvider.notifier)
                                    .updateStatusEvent(
                                        eventDetail['id'], {'status': 'going'});
                              } else {
                                ref
                                    .read(eventControllerProvider.notifier)
                                    .updateStatusEvent(
                                        eventDetail['id'], {'status': ''});
                              }
                              setState(() {});
                            },
                            child: Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.3,
                              margin: const EdgeInsets.fromLTRB(2, 0, 6, 10),
                              decoration: BoxDecoration(
                                  color: eventDetail['event_relationship']
                                              ['status'] !=
                                          'going'
                                      ? const Color.fromARGB(189, 202, 202, 202)
                                      : secondaryColor.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      Border.all(width: 0.2, color: greyColor)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                      eventDetail['event_relationship']
                                                  ['status'] !=
                                              'going'
                                          ? FontAwesomeIcons.clipboardQuestion
                                          : FontAwesomeIcons.circleCheck,
                                      color: Colors.black,
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
                        GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  margin: const EdgeInsets.only(
                                      left: 8.0, top: 15.0),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3 +
                                          30,
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: iconActionEllipsis.length,
                                        itemBuilder: ((context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    barrierColor:
                                                        Colors.transparent,
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        10))),
                                                    builder: (context) =>
                                                        SizedBox(
                                                          height: height * 0.9,
                                                          width: width,
                                                          child: ActionEllipsis(
                                                              menuSelected:
                                                                  iconActionEllipsis[
                                                                      index]),
                                                        ));
                                              },
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 18.0,
                                                    backgroundColor:
                                                        greyColor[350],
                                                    child: Icon(
                                                      iconActionEllipsis[index]
                                                          ["icon"],
                                                      size: 18.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Text(
                                                        iconActionEllipsis[
                                                            index]["label"],
                                                        style: const TextStyle(
                                                            fontSize: 14.0,
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
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.1,
                              margin: const EdgeInsets.fromLTRB(2, 0, 0, 10),
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(189, 202, 202, 202),
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      Border.all(width: 0.2, color: greyColor)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(FontAwesomeIcons.ellipsis,
                                      color: Colors.black, size: 14),
                                ],
                              ),
                            ))
                      ],
                    ),
                  )
                ]),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 4, 4, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(FontAwesomeIcons.stopwatch,
                                    color: Colors.black, size: 20),
                                SizedBox(
                                  width: 9.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    '43 Ngày',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(FontAwesomeIcons.solidUser,
                                      color: Colors.black, size: 20),
                                  SizedBox(
                                    width: 9.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      'Sự kiện của ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(FontAwesomeIcons.locationDot,
                                    color: Colors.black, size: 20),
                                const SizedBox(
                                  width: 9.0,
                                ),
                                Column(
                                  children: const [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 4),
                                      child: Text('Sự kiện của ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ),
                                    Text('Sự kiện của ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: greyColor,
                                          fontWeight: FontWeight.normal,
                                        )),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(FontAwesomeIcons.clipboardCheck,
                                      color: Colors.black, size: 20),
                                  SizedBox(
                                    width: 9.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      'Sự kiện của ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(FontAwesomeIcons.earthAmericas,
                                      color: Colors.black, size: 20),
                                  SizedBox(
                                    width: 9.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.0),
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
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    eventAction = true;
                                  });
                                },
                                child: Container(
                                  height: 30,
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 8, 10, 8),
                                  decoration: BoxDecoration(
                                      color: secondaryColor.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          width: 0.2, color: greyColor)),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'Giới thiệu',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: secondaryColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ]),
                                )),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    eventAction = false;
                                  });
                                },
                                child: Container(
                                  height: 30,
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  margin: const EdgeInsets.fromLTRB(2, 8, 0, 8),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          189, 202, 202, 202),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          width: 0.2, color: greyColor)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Cuộc thảo luận',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const CrossBar(),
                      eventAction
                          ? EventIntro(
                              eventDetail: eventDetail,
                            )
                          : EventDiscuss(eventDetail: eventDetail)
                    ],
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: _isVisible,
            child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: InkWell(
                          onTap: () {
                            if (eventDetail['event_relationship']['status'] !=
                                'interested') {
                              ref
                                  .read(eventControllerProvider.notifier)
                                  .updateStatusEvent(eventDetail['id'],
                                      {'status': 'interested'});
                            } else {
                              ref
                                  .read(eventControllerProvider.notifier)
                                  .updateStatusEvent(
                                      eventDetail['id'], {'status': ''});
                            }
                            setState(() {});
                          },
                          child: Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                  color: eventDetail['event_relationship']
                                              ['status'] !=
                                          'interested'
                                      ? secondaryColor
                                      : secondaryColor.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      Border.all(width: 0.2, color: greyColor)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(FontAwesomeIcons.solidStar,
                                      color: eventDetail['event_relationship']
                                                  ['status'] !=
                                              'interested'
                                          ? Colors.white
                                          : secondaryColor,
                                      size: 14),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    'Quan tâm',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: eventDetail['event_relationship']
                                                  ['status'] !=
                                              'interested'
                                          ? Colors.white
                                          : secondaryColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ))),
                    ),
                    InkWell(
                        onTap: () {
                          if (eventDetail['event_relationship']['status'] !=
                              'going') {
                            ref
                                .read(eventControllerProvider.notifier)
                                .updateStatusEvent(
                                    eventDetail['id'], {'status': 'going'});
                          } else {
                            ref
                                .read(eventControllerProvider.notifier)
                                .updateStatusEvent(
                                    eventDetail['id'], {'status': ''});
                          }
                          setState(() {});
                        },
                        child: Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.35,
                          decoration: BoxDecoration(
                              color: eventDetail['event_relationship']
                                          ['status'] !=
                                      'going'
                                  ? const Color.fromARGB(189, 202, 202, 202)
                                  : secondaryColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(width: 0.2, color: greyColor)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                  eventDetail['event_relationship']['status'] !=
                                          'going'
                                      ? FontAwesomeIcons.clipboardQuestion
                                      : FontAwesomeIcons.circleCheck,
                                  color: Colors.black,
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
                          onTap: () {},
                          child: Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.1,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(189, 202, 202, 202),
                                borderRadius: BorderRadius.circular(4),
                                border:
                                    Border.all(width: 0.2, color: greyColor)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(FontAwesomeIcons.ellipsis,
                                    color: Colors.black, size: 14),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventIntro extends ConsumerStatefulWidget {
  final dynamic eventDetail;
  const EventIntro({Key? key, this.eventDetail}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<EventIntro> createState() => _EventIntroState();
}

List hosts = [];

class _EventIntroState extends ConsumerState<EventIntro> {
  String firstHalf = '';
  String secondHalf = '';
  late double width;
  late double height;
  bool flag = true;
  var paramsConfig = {"limit": 4};

  @override
  void initState() {
    super.initState();
    if (widget.eventDetail['description'].length > 100) {
      firstHalf = widget.eventDetail['description'].substring(0, 100);
      secondHalf = widget.eventDetail['description']
          .substring(100, widget.eventDetail['description'].length);
    } else {
      firstHalf = widget.eventDetail['description'];
      secondHalf = "";
    }
    Future.delayed(
        Duration.zero,
        () => ref
            .read(eventControllerProvider.notifier)
            .getListEventSuggested(paramsConfig));
  }

  @override
  Widget build(BuildContext context) {
    List hosts = ref.watch(eventControllerProvider).hosts;
    List eventsSuggested = ref.watch(eventControllerProvider).eventsSuggested;
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Text(
            'Chi tiết sự kiện',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8.0, left: 6, bottom: 8.0),
          child: secondHalf.isEmpty
              ? Text(firstHalf)
              : Column(
                  children: [
                    RichText(
                      text: TextSpan(
                          text: flag
                              ? ("$firstHalf...")
                              : (firstHalf + secondHalf),
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Color(0xFF212121),
                          ),
                          children: <InlineSpan>[
                            flag
                                ? TextSpan(
                                    text: ' Đọc thêm',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        setState(() {
                                          flag = !flag;
                                        });
                                      })
                                : const TextSpan()
                          ]),
                    ),
                  ],
                ),
        ),
        const CrossBar(),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
                child: Text(
                  'Gặp gỡ người tổ chức',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: hosts.length <= 1 ? 240 : 260,
                    width: hosts.length <= 1 ? 400 : width,
                    child: ListView.builder(
                        itemCount: hosts.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width:
                                hosts.length <= 1 ? width * 0.95 : width * 0.6,
                            child: Card(
                              elevation: 0,
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 0.5,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: hosts.length <= 1
                                            ? width * 0.95
                                            : width * 0.6,
                                        height: hosts[index]['account']['group']
                                            ? hosts.length <= 1
                                                ? height * 0.125
                                                : height * 0.13
                                            : height * 0.12,
                                        child: hosts[index]['account']['group']
                                            ? ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(8),
                                                        topRight:
                                                            Radius.circular(8)),
                                                child: ImageCacheRender(
                                                  path: hosts[index]['account']
                                                      ['avatar_media']['url'],
                                                ),
                                              )
                                            : Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2.0),
                                                  child: ClipOval(
                                                    child: SizedBox.fromSize(
                                                      size: const Size
                                                              .fromRadius(
                                                          48), // Image radius
                                                      child: ImageCacheRender(
                                                        path: hosts[index]
                                                                    ['account']
                                                                ['avatar_media']
                                                            ['url'],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Gặp gỡ người tổ chức',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        '14 sự kiện đã qua · 4.5K lượt thích',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black.withOpacity(0.8),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      SizedBox(
                                        width: hosts.length < 2
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.87
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.48,
                                        child: Text(
                                          'Vietnam Gender Equality Movement (VGEM) là chuỗi hoạt động thúc đẩy quyền bình đẳng giới tại Việt Nam.',
                                          maxLines: 3,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontWeight: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            height: 30,
                                            width: hosts.length < 2
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.87
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
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
                                                        .solidThumbsUp,
                                                    color: Colors.black,
                                                    size: 14),
                                                SizedBox(
                                                  width: 7.0,
                                                ),
                                                Text(
                                                  'Xem',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
        const CrossBar(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 4.0, bottom: 8.0, right: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Sự kiện gợi ý',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Xem tất cả',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 260,
                  width: width,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: eventsSuggested.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Card(
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 0.5,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: height * 0.15,
                                      width: width * 0.6,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8)),
                                        child: ImageCacheRender(
                                          path: eventsSuggested[index]
                                                  ['account']['avatar_media']
                                              ['url'],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                        left: 8.0,
                                        top: 8.0,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              GetTimeAgo.parse(
                                                DateTime.parse(
                                                    eventsSuggested[index]
                                                        ['start_time']),
                                              ),
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.55,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                eventsSuggested[index]['title'],
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w700,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
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
                                              '${eventsSuggested[index]['users_interested_count'].toString()} người quan tâm · ${eventsSuggested[index]['users_going_count'].toString()} người tham gia ',
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: greyColor,
                                                fontWeight: FontWeight.w700,
                                              ),
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
                                                        String key = eventsSuggested[
                                                                        index][
                                                                    'event_relationship']
                                                                ['status'] ??
                                                            '';
                                                        if (key != '') {
                                                          showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            shape:
                                                                const RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        10),
                                                              ),
                                                            ),
                                                            context: context,
                                                            builder: (context) =>
                                                                StatefulBuilder(
                                                                    builder:
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
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    const Text(
                                                                      'Phản hồi của bạn',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                    const CrossBar(),
                                                                    Column(
                                                                      children: List.generate(
                                                                          iconEventCare.length,
                                                                          (indexGes) => GestureDetector(
                                                                                onTap: () {
                                                                                  ref.read(eventControllerProvider.notifier).updateStatusEvent(eventsSuggested[index]['id'], {
                                                                                    'status': iconEventCare[indexGes]['key']
                                                                                  });
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: ListTile(
                                                                                  dense: true,
                                                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                                                                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -1),
                                                                                  leading: Icon(iconEventCare[indexGes]['icon'], color: Colors.black),
                                                                                  title: Text(iconEventCare[indexGes]['label'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                                                                  trailing: Radio(
                                                                                      groupValue: eventsSuggested[index]['event_relationship']['status'],
                                                                                      value: iconEventCare[indexGes]['key'],
                                                                                      onChanged: (value) {
                                                                                        ref.read(eventControllerProvider.notifier).updateStatusEvent(eventsSuggested[index]['id'], {
                                                                                          'status': value
                                                                                        });
                                                                                        Navigator.pop(context);
                                                                                      }),
                                                                                ),
                                                                              )),
                                                                    ),
                                                                    const CrossBar(),
                                                                    const ListTile(
                                                                      dense:
                                                                          true,
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8.0,
                                                                          vertical:
                                                                              0.0),
                                                                      visualDensity: VisualDensity(
                                                                          horizontal:
                                                                              -4,
                                                                          vertical:
                                                                              -4),
                                                                      leading:
                                                                          Icon(
                                                                        FontAwesomeIcons
                                                                            .userGroup,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                      title: Text
                                                                          .rich(
                                                                        TextSpan(
                                                                          text:
                                                                              'Hiển thị với người tổ chức và',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w700),
                                                                          children: <
                                                                              InlineSpan>[
                                                                            TextSpan(
                                                                              text: ' Bạn bè',
                                                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      trailing:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(right: 15.0),
                                                                        child:
                                                                            Icon(
                                                                          FontAwesomeIcons
                                                                              .chevronRight,
                                                                          color:
                                                                              Colors.black,
                                                                          size:
                                                                              20,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }),
                                                          );
                                                        }
                                                        if (eventsSuggested[
                                                                        index][
                                                                    'event_relationship']
                                                                ['status'] ==
                                                            '') {
                                                          ref
                                                              .read(
                                                                  eventControllerProvider
                                                                      .notifier)
                                                              .updateStatusEvent(
                                                                  eventsSuggested[
                                                                      index]['id'],
                                                                  {
                                                                'status':
                                                                    'interested'
                                                              });
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 24,
                                                        width: width * 0.45,
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 10.0,
                                                            right: 8.0),
                                                        decoration: BoxDecoration(
                                                            color: eventsSuggested[index]
                                                                            ['event_relationship']
                                                                        [
                                                                        'status'] !=
                                                                    ''
                                                                ? secondaryColor
                                                                : const Color.fromARGB(
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
                                                        child: eventsSuggested[
                                                                            index]
                                                                        [
                                                                        'event_relationship']
                                                                    [
                                                                    'status'] ==
                                                                'interested'
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: const [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        bottom:
                                                                            3.0),
                                                                    child: Icon(
                                                                        FontAwesomeIcons
                                                                            .solidStar,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            14),
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
                                                                    width: 5.0,
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        bottom:
                                                                            5.0),
                                                                    child: Icon(
                                                                        FontAwesomeIcons
                                                                            .sortDown,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            14),
                                                                  ),
                                                                ],
                                                              )
                                                            : eventsSuggested[index]
                                                                            [
                                                                            'event_relationship']
                                                                        [
                                                                        'status'] ==
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
                                                                          size:
                                                                              14),
                                                                      SizedBox(
                                                                        width:
                                                                            5.0,
                                                                      ),
                                                                      Text(
                                                                        'Sẽ tham gia',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5.0,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: 4.0),
                                                                        child: Icon(
                                                                            FontAwesomeIcons
                                                                                .sortDown,
                                                                            color:
                                                                                Colors.black,
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
                                                                            EdgeInsets.only(bottom: 3.0),
                                                                        child: Icon(
                                                                            FontAwesomeIcons
                                                                                .solidStar,
                                                                            color:
                                                                                Colors.black,
                                                                            size: 14),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5.0,
                                                                      ),
                                                                      Text(
                                                                        'Quan tâm',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            3.0,
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
                                                                  BorderRadius
                                                                      .vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        10),
                                                              ),
                                                            ),
                                                            context: context,
                                                            builder: (context) =>
                                                                const ShareModalBottom());
                                                      },
                                                      child: Container(
                                                        height: 24,
                                                        width: width * 0.1,
                                                        margin: const EdgeInsets
                                                            .only(top: 10),
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
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Icon(
                                                                FontAwesomeIcons
                                                                    .share,
                                                                color: Colors
                                                                    .black,
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
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ],
        ),
        const CrossBar(),
        const SizedBox(height: 50),
      ],
    );
  }
}

class EventDiscuss extends ConsumerWidget {
  final dynamic eventDetail;
  const EventDiscuss({Key? key, this.eventDetail}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
