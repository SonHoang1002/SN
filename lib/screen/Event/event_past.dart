import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/providers/event_provider.dart';
import 'package:social_network_app_mobile/screen/Event/event_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/card_components.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/modal_invite_friend.dart';
import 'package:social_network_app_mobile/widget/share_modal_bottom.dart';
import 'package:provider/provider.dart' as pv;

class EventPast extends ConsumerStatefulWidget {
  final dynamic event;
  const EventPast({Key? key, this.event}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<EventPast> createState() => _EventPastState();
}

class _EventPastState extends ConsumerState<EventPast> {
  late double width;
  late double height;
  var paramsConfigPast = {"limit": 10,  "time": "past"};
  final scrollController = ScrollController();


  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(
        Duration.zero,
            () => ref
            .read(eventControllerProvider.notifier)
            .getListEventHosts(paramsConfigPast));
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        String maxId = ref.read(eventControllerProvider).eventHosts.last['id'];
        ref
            .read(eventControllerProvider.notifier)
            .getListEventHosts({"max_id": maxId, ...paramsConfigPast});
      }
    });
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List events = ref.watch(eventControllerProvider).eventHosts;
    bool isMore = ref.watch(eventControllerProvider).isMore;
    final theme = pv.Provider.of<ThemeManager>(context);

    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding:
              EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Text(
                'Sự kiện đã qua của bạn',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            events.isNotEmpty ?
            SizedBox(
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
                              path: events[indexInteresting]['banner']
                              ['url'],
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
                          textCard: Column(
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
                          // buttonCard: Container(
                          //   padding: const EdgeInsets.only(bottom: 5.0),
                          //   child: Row(
                          //     children: [
                          //       Align(
                          //         alignment: Alignment.bottomLeft,
                          //         child: InkWell(
                          //           onTap: () {
                          //             showBarModalBottomSheet(
                          //                 context: context,
                          //                 backgroundColor: theme.isDarkMode ? Colors.black : Colors.white,
                          //                 builder: (context) => const InviteFriend());
                          //           },
                          //           child: Padding(
                          //             padding:
                          //             const EdgeInsets.only(left: 3.0),
                          //             child: Container(
                          //               height: 32,
                          //               width: width * 0.7,
                          //               decoration: BoxDecoration(
                          //                   color: const Color.fromARGB(
                          //                       189, 202, 202, 202),
                          //                   borderRadius:
                          //                   BorderRadius.circular(6),
                          //                   border: Border.all(
                          //                       width: 0.2,
                          //                       color: greyColor)),
                          //               child: Row(
                          //                 mainAxisAlignment:
                          //                 MainAxisAlignment
                          //                     .center,
                          //                 children: const [
                          //                   Padding(
                          //                     padding:
                          //                     EdgeInsets.only(
                          //                         bottom:
                          //                         1.0),
                          //                     child: Icon(
                          //                         FontAwesomeIcons
                          //                             .envelope,
                          //                         color: Colors
                          //                             .black,
                          //                         size: 14),
                          //                   ),
                          //                   SizedBox(
                          //                     width: 5.0,
                          //                   ),
                          //                   Text(
                          //                     'Mời',
                          //                     textAlign: TextAlign
                          //                         .center,
                          //                     style: TextStyle(
                          //                         fontSize: 12.0,
                          //                         fontWeight:
                          //                         FontWeight
                          //                             .w700,
                          //                         color: Colors.black
                          //                     ),
                          //                   ),
                          //                   SizedBox(
                          //                     width: 3.0,
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //       const SizedBox(
                          //         width: 11.0,
                          //       ),
                          //       Align(
                          //         alignment: Alignment.bottomRight,
                          //         child: InkWell(
                          //           onTap: () {
                          //             showModalBottomSheet(
                          //                 shape:
                          //                 const RoundedRectangleBorder(
                          //                   borderRadius:
                          //                   BorderRadius.vertical(
                          //                     top: Radius.circular(10),
                          //                   ),
                          //                 ),
                          //                 context: context,
                          //                 builder: (context) =>
                          //                 const ShareModalBottom());
                          //           },
                          //           child: Container(
                          //             height: 32,
                          //             width: width * 0.12,
                          //             decoration: BoxDecoration(
                          //                 color: const Color.fromARGB(
                          //                     189, 202, 202, 202),
                          //                 borderRadius:
                          //                 BorderRadius.circular(6),
                          //                 border: Border.all(
                          //                     width: 0.2,
                          //                     color: greyColor)),
                          //             child: Row(
                          //               mainAxisAlignment:
                          //               MainAxisAlignment.center,
                          //               children: const [
                          //                 Icon(FontAwesomeIcons.share,
                          //                     color: Colors.black,
                          //                     size: 14),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ),
                      );
                    } else {
                      isMore == true
                          ? const Center(
                          child: CupertinoActivityIndicator())
                          : const SizedBox();
                    }
                  },
                )) : const SizedBox(),
            isMore == true
                ? const Center(child: CupertinoActivityIndicator())
                : const SizedBox()
          ],
        )
        ,
      ),
    );
  }
}
