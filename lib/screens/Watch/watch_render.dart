import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/type_constant.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/providers/disable_watch_provider.dart';
import 'package:social_network_app_mobile/providers/watch_provider.dart';
import 'package:social_network_app_mobile/screens/Watch/watch_home.dart';
import 'package:social_network_app_mobile/screens/Watch/watch_saved.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';

import 'watch_live.dart';
import 'watch_program.dart';

class WatchRender extends ConsumerStatefulWidget {
  const WatchRender({Key? key}) : super(key: key);

  @override
  ConsumerState<WatchRender> createState() => _WatchRenderState();
}

class _WatchRenderState extends ConsumerState<WatchRender>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  String menuSelected = watchHome;
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: watchMenu.length, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        setState(() {
          menuSelected = watchMenu[tabController.index]['key'];
        });
      }
    });
    Future.delayed(Duration.zero, () async {
      ref
          .read(videoCurrentTabController.notifier)
          .setVideoCurrentTab(watchHome);
      ref
          .read(disableVideoController.notifier)
          .setDisableVideo(watchHome, false, disableBefore: true);
    });
    fetchDataWatch(menuSelected, {'limit': 3});
  }

  void fetchDataWatch(type, params) {
    bool isFetchData =
        (ref.read(watchControllerProvider).watchSuggest.isEmpty &&
                menuSelected == watchHome) ||
            (ref.read(watchControllerProvider).watchFollow.isEmpty &&
                menuSelected == watchFollow);

    if (isFetchData || params['max_id'] != null) {
      if (type == watchHome) {
        ref.read(watchControllerProvider.notifier).getListWatchSuggest(params);
      } else if (type == watchFollow) {
        ref.read(watchControllerProvider.notifier).getListWatchFollow(params);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(children: [
      TabBar(
        controller: tabController,
        isScrollable: true,
        tabs: watchMenu
            .map(
              (e) => Tab(
                child: buildTextContent(e['label'], false,
                    fontSize: 14, isCenterLeft: false),
              ),
            )
            .toList(),
        indicatorColor: primaryColor,
        labelColor: primaryColor,
        unselectedLabelColor: Theme.of(context).textTheme.displayLarge!.color,
        onTap: (index) {
          ref
              .read(videoCurrentTabController.notifier)
              .setVideoCurrentTab(watchMenu[index]['key']);
          ref.read(disableVideoController.notifier).setDisableVideo(
              watchMenu[index]['key'], false,
              disableBefore: true);
          if (mounted) {
            setState(() {
              menuSelected = watchMenu[index]['key'];
            });
            fetchDataWatch(watchMenu[index]['key'], {'limit': 3});
          }
        },
      ),
      buildSpacer(height: 20),
      Expanded(
        child: TabBarView(
          controller: tabController,
          physics: const BouncingScrollPhysics(),
          children: [
            WatchHome(
                type: watchHome,
                fetchDataWatch: fetchDataWatch,
                isFocus: menuSelected == watchHome),
            WatchHome(
                type: watchFollow,
                fetchDataWatch: fetchDataWatch,
                isFocus: menuSelected == watchFollow),
            const WatchLive(),
            const WatchProgram(),
            const WatchSaved(),
          ],
        ),
      )
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}
