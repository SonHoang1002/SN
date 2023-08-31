import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/type_constant.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/providers/disable_watch_provider.dart';
import 'package:social_network_app_mobile/providers/watch_provider.dart';
import 'package:social_network_app_mobile/screens/Watch/watch_home.dart';
import 'package:social_network_app_mobile/screens/Watch/watch_saved.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/header_tabs.dart';

class WatchRender extends ConsumerStatefulWidget {
  const WatchRender({Key? key}) : super(key: key);

  @override
  ConsumerState<WatchRender> createState() => _WatchRenderState();
}

class _WatchRenderState extends ConsumerState<WatchRender>
    with AutomaticKeepAliveClientMixin {
  String menuSelected = watchHome;

  @override
  void initState() {
    super.initState();
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
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: HeaderTabs(
            chooseTab: (tab) {
              if (mounted) {
                setState(() {
                  menuSelected = tab;
                });
                ref
                    .read(videoCurrentTabController.notifier)
                    .setVideoCurrentTab(tab);
                ref
                    .read(disableVideoController.notifier)
                    .setDisableVideo(tab, false, disableBefore: true);
                fetchDataWatch(tab, {'limit': 3});
              }
            },
            listTabs: watchMenu,
            tabCurrent: menuSelected,
          ),
        ),
        const CrossBar(
          height: 1,
        ),
        if (menuSelected == watchHome)
          WatchHome(
              type: menuSelected,
              fetchDataWatch: fetchDataWatch,
              isFocus: menuSelected == watchHome)
        else if (menuSelected == watchFollow)
          WatchHome(
              type: menuSelected,
              fetchDataWatch: fetchDataWatch,
              isFocus: menuSelected == watchFollow)
        else
          menuSelected == watchSaved ? const WatchSaved() : const SizedBox()
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
