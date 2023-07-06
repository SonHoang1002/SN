import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/screens/Page/PageDetail/photo_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

import '../../providers/UserPage/user_media_provider.dart';

class UserPhotoVideo extends ConsumerStatefulWidget {
  final dynamic id;
  const UserPhotoVideo({super.key, this.id});

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
    Future.delayed(
        Duration.zero,
        () => {
              ref.read(userMediaControllerProvider.notifier).getUserPhoto(
                  widget.id, {"media_type": "image", "limit": 10}),
              ref.read(userMediaControllerProvider.notifier).getUserVideo(
                  widget.id, {"media_type": "video", "limit": 10}),
              ref
                  .read(userMediaControllerProvider.notifier)
                  .getUserAlbum(widget.id, {"limit": 10}),
              ref.read(userMediaControllerProvider.notifier).getUserMoment(
                  widget.id,
                  {"media_type": "video", "post_type": "moment", "limit": 10})
            });

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
    List userPhoto = ref.watch(userMediaControllerProvider).photoUser;
    List userVideo = ref.watch(userMediaControllerProvider).videoUser;
    List userMoment = ref.watch(userMediaControllerProvider).momentUser;
    List userAlbum = ref.watch(userMediaControllerProvider).albumUser;

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
          title: const Text('Ảnh của bạn'),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: secondaryColor,
            dividerColor: secondaryColor,
            labelColor: Theme.of(context).textTheme.bodyLarge?.color,
            tabs: List.generate(
              userMediaMenu.length,
              (index) => Text(
                userMediaMenu[index]['label'],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: TabBarView(
            controller: _tabController,
            children: [
              RenderPhoto(
                photoData: userPhoto,
                hasTitle: false,
              ),
              RenderPhoto(
                photoData: userAlbum,
                hasTitle: true,
                type: 'buttonAlbum',
              ),
              RenderPhoto(
                photoData: userVideo,
                hasTitle: false,
              ),
              RenderPhoto(
                photoData: userMoment,
                hasTitle: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
