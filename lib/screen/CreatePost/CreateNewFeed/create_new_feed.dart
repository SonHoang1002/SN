import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/screen/CreatePost/CreateNewFeed/create_feed_menu.dart';
import 'package:social_network_app_mobile/screen/CreatePost/CreateNewFeed/create_feed_status.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/checkin.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/emoji_activity.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/friend_tag.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/gif.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/life_event_categories.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/widget/PickImageVideo/src/gallery/src/gallery_view.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/grid_layout_image.dart';

class CreateNewFeed extends ConsumerStatefulWidget {
  const CreateNewFeed({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateNewFeed> createState() => _CreateNewFeedState();
}

class _CreateNewFeedState extends ConsumerState<CreateNewFeed> {
  dynamic menuSelected;
  List friendSelected = [];
  List files = [];

  handleUpdateSelectedFriend(newList) {
    setState(() {
      friendSelected = newList;
    });
  }

  functionConvertFile(file) async {
    if (file == null) return;
    Uint8List? bytes;
    if (file.pickedThumbData == null) {
      bytes = await file.thumbnailData;
    } else {
      bytes = file.pickedThumbData;
    }

    file = file.copyWith(
      pickedThumbData: bytes,
    );

    return await file;
  }

  handleGetFiles(file) async {
    if (file.isEmpty) {
      setState(() {
        files = [];
      });
    }

    List newFiles =
        file.map((element) => functionConvertFile(element)).toList();

    print('newFiles $newFiles');

    setState(() {
      files = newFiles;
    });
  }

  handlePress() {}

  handleChooseMenu(menu) {
    if (menu == null) return;

    if (menu['key'] == 'media') {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => Expanded(
                      child: GalleryView(
                    isMutipleFile: true,
                    handleGetFiles: handleGetFiles,
                    filesSelected: const [],
                  ))));
      return;
    }
    setState(() {
      menuSelected = menu;
    });

    Widget body = const SizedBox();
    Widget buttonAppbar = const SizedBox();

    switch (menu['key']) {
      case 'emoji-activity':
        body = const EmojiActivity();
        break;
      case 'checkin':
        body = const Checkin();
        break;
      case 'tag-people':
        body =
            FriendTag(handleUpdateSelectedFriend: handleUpdateSelectedFriend);
        buttonAppbar = const ButtonPrimary(label: "Xong");
        break;
      case 'gif':
        body = const Gif();
        break;
      case 'life-event':
        body = const LifeEventCategories();
        break;
      default:
    }

    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => CreateModalBaseMenu(
                title: menu['label'], body: body, buttonAppbar: buttonAppbar)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            BackIconAppbar(),
            AppBarTitle(title: "Tạo bài post"),
            ButtonPrimary(label: "Đăng")
          ],
        ),
      ),
      body: Column(
        children: [
          const CreateFeedStatus(),
          files.isNotEmpty
              ? ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor:
                        files[0].width / files[0].height < 0.4 ? 0.6 : 1,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Image.memory(
                          files[0].pickedThumbData,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Text('Hình ảnh không được hiển thị'),
                        )),
                  ),
                )
              : const SizedBox(),
          CreateFeedMenu(
            handleChooseMenu: handleChooseMenu,
          )
        ],
      ),
    );
  }
}
