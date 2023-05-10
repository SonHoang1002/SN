import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/providers/watch_provider.dart';
import 'package:social_network_app_mobile/screen/Watch/watch_home.dart';
import 'package:social_network_app_mobile/screen/Watch/watch_saved.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/header_tabs.dart';

class WatchRender extends ConsumerStatefulWidget {
  const WatchRender({Key? key}) : super(key: key);

  @override
  ConsumerState<WatchRender> createState() => _WatchRenderState();
}

class _WatchRenderState extends ConsumerState<WatchRender>
    with AutomaticKeepAliveClientMixin {
  String menuSelected = 'watch_home';

  void fetchDataWatch(type, params) {
    bool isFetchData = ref.read(watchControllerProvider).watchSuggest.isEmpty &&
            menuSelected == 'watch_home' ||
        ref.read(watchControllerProvider).watchFollow.isEmpty &&
            menuSelected == 'watch_follow';

    if (isFetchData) {
      if (type == 'watch_home') {
        ref.read(watchControllerProvider.notifier).getListWatchSuggest(params);
      } else if (type == 'watch_follow') {
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
        if (['watch_home', 'watch_follow'].contains(menuSelected))
          WatchHome(type: menuSelected, fetchDataWatch: fetchDataWatch)
        else
          menuSelected == 'watch_saved' ? const WatchSaved() : const SizedBox()
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
