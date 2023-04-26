import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/moment_provider.dart';
import 'package:social_network_app_mobile/screen/Moment/moment_pageview.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class Moment extends ConsumerStatefulWidget {
  final bool? isBack;
  const Moment({Key? key, this.isBack}) : super(key: key);

  @override
  ConsumerState<Moment> createState() => _MomentState();
}

class _MomentState extends ConsumerState<Moment>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  PageController controller =
      PageController(viewportFraction: 1, keepPage: true);
  bool isPlay = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);

    if (mounted) {
      Future.delayed(Duration.zero, () {
        ref
            .read(momentControllerProvider.notifier)
            .getListMomentSuggest({"limit": 10});
      });
      Future.delayed(Duration.zero, () {
        ref
            .read(momentControllerProvider.notifier)
            .getListMomentFollow({"limit": 10});
      });
    }
  }

  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final GlobalKey<ScaffoldState> key = GlobalKey();

    List iconAction = [
      {"icon": Icons.search, 'type': 'icon'},
    ];

    List momentSuggests = ref.watch(momentControllerProvider).momentSuggest;
    List momentFollow = ref.watch(momentControllerProvider).momentFollow;

    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: <Widget>[
          TabBarView(controller: _tabController, children: [
            momentFollow.isNotEmpty
                ? MomentPageview(
                    type: 'follow',
                    momentRender: momentFollow,
                    handlePageChange: (value) {
                      if (value == momentFollow.length - 5) {
                        ref
                            .read(momentControllerProvider.notifier)
                            .getListMomentFollow({
                          "limit": 10,
                          "max_id": momentFollow.last['score']
                        });
                      }
                    },
                  )
                : Container(
                    color: Colors.black,
                    width: size.width,
                    height: size.height,
                  ),
            momentSuggests.isNotEmpty
                ? MomentPageview(
                    type: 'suggest',
                    momentRender: momentSuggests,
                    handlePageChange: (value) {
                      if (value == momentSuggests.length - 5) {
                        ref
                            .read(momentControllerProvider.notifier)
                            .getListMomentSuggest({
                          "limit": 10,
                          "max_id": momentSuggests.last['score']
                        });
                      }
                    },
                  )
                : Container(
                    color: Colors.black,
                    width: size.width,
                    height: size.height,
                  )
          ]),
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
              ))
        ]));
  }

  @override
  void dispose() {
    _tabController.dispose();
    controller.dispose();
    super.dispose();
  }
}
