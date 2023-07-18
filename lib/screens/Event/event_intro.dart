import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/data/event.dart';
import 'package:social_network_app_mobile/providers/event_provider.dart';
import 'package:social_network_app_mobile/screens/Event/event_detail.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/Map/map.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/share_modal_bottom.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Page/PageDetail/page_detail.dart';

class EventIntro extends ConsumerStatefulWidget {
  final dynamic eventDetail;
  const EventIntro({Key? key, this.eventDetail}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<EventIntro> createState() => _EventIntroState();
}

class _EventIntroState extends ConsumerState<EventIntro> {
  String firstHalf = '';
  String secondHalf = '';
  late double width;
  late double height;
  bool flag = true;
  var eventDetail = {};
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
    eventDetail = widget.eventDetail;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _launchMapsApp() async {
    final latitude = widget.eventDetail['location']['lat'];
    final longitude = widget.eventDetail['location']['lng'];

    String url;
    if (Platform.isIOS) {
      url = 'comgooglemaps://?q=$latitude,$longitude&zoom=13';
    } else {
      url =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    }
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    List hosts = ref.watch(eventControllerProvider).hosts;
    List eventsSuggested = ref.watch(eventControllerProvider).eventsSuggested;
    List groupSuggest = ref.watch(eventControllerProvider).groupSuggest;
    final theme = pv.Provider.of<ThemeManager>(context);

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
                          style: TextStyle(
                            fontSize: 12.0,
                            color: colorWord(context),
                          ),
                          children: <InlineSpan>[
                            flag
                                ? TextSpan(
                                    text: ' Đọc thêm',
                                    style: TextStyle(
                                        color: colorWord(context),
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
        const Divider(
          height: 20,
          thickness: 1,
        ),
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
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(
                height: 340,
                child: ListView.builder(
                    itemCount: hosts.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        width: hosts.length > 1
                            ? MediaQuery.of(context).size.width * 0.61
                            : MediaQuery.of(context).size.width * 0.91,
                        margin: const EdgeInsets.only(top: 10),
                        child: CardComponents(
                          onTap: () {
                            hosts[index]['account']['group']
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PageDetail(),
                                      settings: RouteSettings(
                                          arguments: hosts[index]['account']
                                                  ['id']
                                              .toString()),
                                    ))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UserPageHome(),
                                      settings: RouteSettings(
                                        arguments: {
                                          'id': hosts[index]['account']['id']
                                        },
                                      ),
                                    ));
                          },
                          imageCard: Column(
                            children: [
                              hosts[index]['account']['group']
                                  ? ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                      child: ExtendedImage.network(
                                        hosts[index]['account']
                                                    ['avatar_media'] !=
                                                null
                                            ? hosts[index]['account']
                                                ['avatar_media']['url']
                                            : hosts[index]['account']
                                                ['avatar_static'],
                                        fit: BoxFit.cover,
                                        width: hosts.length > 1
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.61
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.91,
                                        height: 180.0,
                                      ))
                                  : Center(
                                      child: ClipOval(
                                          child: ExtendedImage.network(
                                        hosts[index]['account']
                                                    ['avatar_media'] !=
                                                null
                                            ? hosts[index]['account']
                                                ['avatar_media']['url']
                                            : hosts[index]['account']
                                                ['avatar_static'],
                                        fit: BoxFit.cover,
                                        width: 180.0,
                                        height: 180.0,
                                      )),
                                    ),
                            ],
                          ),
                          textCard: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 8.0,
                                    left: 8.0,
                                    right: 8.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    hosts[index]['account']['display_name'] ??
                                        "",
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${hosts[index]['account']['followers_count'].toString()} người quan tâm · ${hosts[index]['account']['following_count'].toString()} người theo dõi',
                                    style: const TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(
                                thickness: 1,
                                height: 20,
                              ),
                            ],
                          ),
                          buttonCard: Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Column(
                              children: [
                                Text(
                                  hosts[index]['account']['description'] ?? "",
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: InkWell(
                                    onTap: () {
                                      hosts[index]['account']['group']
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const PageDetail(),
                                                settings: RouteSettings(
                                                    arguments: hosts[index]
                                                            ['account']['id']
                                                        .toString()),
                                              ))
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const UserPageHome(),
                                                settings: RouteSettings(
                                                  arguments: {
                                                    'id': hosts[index]
                                                        ['account']['id']
                                                  },
                                                ),
                                              ));
                                    },
                                    child: Container(
                                      height: 35,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
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
                                          Icon(FontAwesomeIcons.user, size: 14),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            'Xem',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3.0,
                                          ),
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
                    }),
              ),
            ],
          ),
        ),
        widget.eventDetail['location'] != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    height: 20,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 4.0, bottom: 8.0, right: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Thông tin về địa điểm',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 180,
                    child: Column(
                      children: [
                        SizedBox(
                            height: 180,
                            child: MapWidget(
                                type: 'custom_map',
                                checkin: widget.eventDetail,
                                zoom: 10.0,
                                interactiveFlags: InteractiveFlag.none)),
                      ],
                    ),
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 0.0,
                    ),
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: 0,
                    ),
                    leading:
                        const Icon(FontAwesomeIcons.diamondTurnRight, size: 20),
                    title: Text(eventDetail['address'] ?? "",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700)),
                    trailing: TextButton(
                        onPressed: () {
                          _launchMapsApp();
                        },
                        child: const Text('Xem đường đi')),
                  )
                ],
              )
            : const SizedBox(),
        eventsSuggested.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    height: 20,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 4.0, bottom: 8.0, right: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Sự kiện gợi ý',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 380,
                    child: ListView.builder(
                        itemCount: eventsSuggested.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, indexSuggest) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            margin: const EdgeInsets.only(top: 10),
                            child: CardComponents(
                              imageCard: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                      child: ExtendedImage.network(
                                        eventsSuggested[indexSuggest]
                                                    ['banner'] !=
                                                null
                                            ? eventsSuggested[indexSuggest]
                                                ['banner']['url']
                                            : linkBannerDefault,
                                        height: 180.0,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        fit: BoxFit.cover,
                                      )),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => EventDetail(
                                            eventDetail: eventsSuggested[
                                                indexSuggest])));
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
                                    SizedBox(
                                      height: 30,
                                      child: Text(
                                        GetTimeAgo.parse(
                                          DateTime.parse(
                                              eventsSuggested[indexSuggest]
                                                  ['start_time']),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: Text(
                                        eventsSuggested[indexSuggest]['title'],
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: greyColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: Text(
                                        '${eventsSuggested[indexSuggest]['users_interested_count'].toString()} người quan tâm · ${eventsSuggested[indexSuggest]['users_going_count'].toString()} người tham gia ',
                                        maxLines: 2,
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
                              buttonCard: Padding(
                                padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                ),
                                child: Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: InkWell(
                                        onTap: () {
                                          String key =
                                              eventsSuggested[indexSuggest]
                                                          ['event_relationship']
                                                      ['status'] ??
                                                  '';
                                          if (key != '') {
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
                                                                InkWell(
                                                                  onTap: () {
                                                                    ref
                                                                        .read(eventControllerProvider
                                                                            .notifier)
                                                                        .updateStatusEventSuggested(
                                                                            eventsSuggested[indexSuggest]['id'],
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
                                                                        groupValue: eventsSuggested[indexSuggest]['event_relationship']['status'],
                                                                        value: iconEventCare[indexGes]['key'],
                                                                        onChanged: (value) {
                                                                          ref.read(eventControllerProvider.notifier).updateStatusEventSuggested(
                                                                              eventsSuggested[indexSuggest]['id'],
                                                                              {
                                                                                'status': value
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
                                          if (eventsSuggested[indexSuggest]
                                                      ['event_relationship']
                                                  ['status'] ==
                                              '') {
                                            ref
                                                .read(eventControllerProvider
                                                    .notifier)
                                                .updateStatusEventSuggested(
                                                    eventsSuggested[
                                                        indexSuggest]['id'],
                                                    {'status': 'interested'});
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          height: 33,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.37,
                                          decoration: BoxDecoration(
                                              color: eventsSuggested[
                                                                  indexSuggest]
                                                              [
                                                              'event_relationship']
                                                          ['status'] !=
                                                      ''
                                                  ? secondaryColor
                                                  : const Color.fromARGB(
                                                      189, 202, 202, 202),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  width: 0.2,
                                                  color: greyColor)),
                                          child: eventsSuggested[indexSuggest]
                                                          ['event_relationship']
                                                      ['status'] ==
                                                  'interested'
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
                                                      ),
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
                                              : eventsSuggested[indexSuggest][
                                                              'event_relationship']
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
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 3.0,
                                                        ),
                                                      ],
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
                                                      data: eventsSuggested[
                                                          indexSuggest]));
                                        },
                                        child: Container(
                                          height: 33,
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1 -
                                              2.3,
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
                        }),
                  ),
                ],
              )
            : const SizedBox.shrink(),
        groupSuggest.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    height: 20,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 4.0, bottom: 8.0, right: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Nhóm liên quan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 380,
                    child: ListView.builder(
                        itemCount: groupSuggest.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, indexGroup) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            margin: const EdgeInsets.only(top: 10),
                            child: CardComponents(
                              imageCard: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                      child: ExtendedImage.network(
                                        groupSuggest[indexGroup]['banner'] !=
                                                null
                                            ? groupSuggest[indexGroup]['banner']
                                                ['url']
                                            : linkBannerDefault,
                                        height: 180.0,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        fit: BoxFit.cover,
                                      )),
                                ],
                              ),
                              onTap: () {
                                // join group detail
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
                                    SizedBox(
                                      height: 30,
                                      child: Text(
                                        groupSuggest[indexGroup]['title'],
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: Text(
                                        groupSuggest[indexGroup]['description'],
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: Row(
                                        children: [
                                          const Icon(FontAwesomeIcons.userGroup,
                                              size: 12),
                                          const SizedBox(width: 15),
                                          Text(
                                            '${(groupSuggest[indexGroup]['member_count'] ?? 0).toString()} thành viên',
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w700,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              buttonCard: Padding(
                                padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                ),
                                child: Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: InkWell(
                                        onTap: () {},
                                        child: Container(
                                          height: 33,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.475,
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
                                                    bottom: 3.0),
                                                child: Icon(
                                                    FontAwesomeIcons.userGroup,
                                                    size: 12),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(
                                                'Tham gia nhóm',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 3.0,
                                              ),
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
                        }),
                  ),
                ],
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 50),
      ],
    );
  }
}
