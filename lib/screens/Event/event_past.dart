import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/event_provider.dart';
import 'package:social_network_app_mobile/screens/Event/event_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/card_components.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';

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
  var paramsConfigPast = {"limit": 10, "time": "past"};
  final scrollController = ScrollController();
  bool isLoading = true;
  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Future.delayed(Duration.zero, () => fetchData(paramsConfigPast));
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        String maxId = ref.read(eventControllerProvider).eventHosts.last['id'];
        fetchData({"max_id": maxId, ...paramsConfigPast});
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void fetchData(params) async {
    await ref.read(eventControllerProvider.notifier).getListEventPast(params);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List events = ref.watch(eventControllerProvider).eventsPast;
    bool isMore = ref.watch(eventControllerProvider).isMore;
    final theme = pv.Provider.of<ThemeManager>(context);
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          ref
              .read(eventControllerProvider.notifier)
              .getListEventPast(paramsConfigPast);
        },
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                child: Text(
                  'Sự kiện đã qua của bạn',
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
                        if (indexInteresting < events.length) {
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
                                  child: ImageCacheRender(
                                    path: events[indexInteresting]['banner'] !=
                                            null
                                        ? events[indexInteresting]['banner']
                                            ['url']
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
              isLoading && events.isEmpty || isMore == true
                  ? const Center(child: CupertinoActivityIndicator())
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
