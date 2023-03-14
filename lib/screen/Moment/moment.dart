import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/screen/Moment/moment_video.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import 'drawer_moment.dart';
import 'video_description.dart';

class Moment extends ConsumerStatefulWidget {
  final bool? isBack;
  const Moment({Key? key, this.isBack}) : super(key: key);

  @override
  ConsumerState<Moment> createState() => _MomentState();
}

class _MomentState extends ConsumerState<Moment> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    if (!mounted) return;

    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);

    Future.delayed(Duration.zero, () {
      ref
          .read(momentControllerProvider.notifier)
          .getListMomentSuggest({"limit": 3});
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey();

    List iconAction = [
      {"icon": Icons.search, 'type': 'icon'},
    ];

    List momentSuggests = ref.watch(momentControllerProvider).momentSuggest;

    return Scaffold(
        key: key,
        drawerEnableOpenDragGesture: false,
        drawer: const Drawer(
          child: DrawerMoment(),
        ),
        body: Stack(children: <Widget>[
          Expanded(
            child: TabBarView(controller: _tabController, children: [
              Container(
                color: Colors.red,
              ),
              PageView.builder(
                itemCount: momentSuggests.length,
                scrollDirection: Axis.vertical,
                onPageChanged: (value) {
                  if (value == momentSuggests.length - 3) {
                    ref
                        .read(momentControllerProvider.notifier)
                        .getListMomentSuggest({
                      "limit": 5,
                      "max_id": momentSuggests.last['score']
                    });
                  }
                },
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      MomentVideo(
                          key: Key(momentSuggests[index]['id']),
                          moment: momentSuggests[index]),
                      Positioned(
                          bottom: 15,
                          left: 15,
                          child:
                              VideoDescription(moment: momentSuggests[index]))
                    ],
                  );
                },
              ),
            ]),
          ),
          Positioned(
            //Place it at the top, and not use the entire screen
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widget.isBack != null
                            ? const BackButton()
                            : InkWell(
                                onTap: () => key.currentState!.openDrawer(),
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 0),
                                  child: Icon(
                                    Icons.menu,
                                    color: white,
                                  ),
                                ),
                              ),
                        const SizedBox(
                          width: 7,
                        ),
                      ]),
                  TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      onTap: (index) {},
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 1,
                      tabs: const [
                        Tab(
                          text: "Đang theo dõi",
                        ),
                        Tab(
                          text: "Dành cho bạn",
                        )
                      ]),
                  Row(
                    children: List.generate(
                        iconAction.length,
                        (index) => Container(
                              width: 30,
                              height: 30,
                              margin: const EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.withOpacity(0.3)),
                              child: Icon(
                                iconAction[index]['icon'],
                                size: 20,
                                color: white,
                              ),
                            )),
                  )
                ],
              ),
              backgroundColor: transparent, //No more green
              elevation: 0.0, //Shadow gone
            ),
          )
        ]));
  }
}
