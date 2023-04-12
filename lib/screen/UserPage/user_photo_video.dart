import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/screen/Page/PageDetail/photo_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/header_tabs.dart';
import 'package:provider/provider.dart' as pv;

class UserPhotoVideo extends ConsumerStatefulWidget {
  const UserPhotoVideo({super.key});

  @override
  ConsumerState<UserPhotoVideo> createState() => _UserPhotoVideoState();
}

class _UserPhotoVideoState extends ConsumerState<UserPhotoVideo>
    with SingleTickerProviderStateMixin {
  String typeMedia = 'image';
  String tabSelected = 'home_page';
  ScrollController scrollController = ScrollController();
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: userMediaMenu.length);

    _tabController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {}
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: userMediaMenu.length,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    FontAwesomeIcons.angleLeft,
                    size: 18,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  )),
              centerTitle: true,
              title: Text('Ảnh của bạn'),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: secondaryColor,
                dividerColor: secondaryColor,
                labelColor: Theme.of(context).textTheme.bodyLarge?.color,
                tabs: List.generate(userMediaMenu.length,
                    (index) => Text(userMediaMenu[index]['label'])),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: const [
                RenderPhoto(
                  photoData: [],
                  hasTitle: false,
                ),
                RenderPhoto(
                  photoData: [],
                  hasTitle: false,
                ),
                RenderPhoto(
                  photoData: [],
                  hasTitle: false,
                ),
                RenderPhoto(
                  photoData: [],
                  hasTitle: false,
                ),
              ],
            )));
  }
}
