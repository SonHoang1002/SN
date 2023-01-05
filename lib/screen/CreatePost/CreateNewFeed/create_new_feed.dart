import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/CreatePost/CreateNewFeed/create_feed_menu.dart';
import 'package:social_network_app_mobile/screen/CreatePost/CreateNewFeed/create_feed_status.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/checkin.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/emoji_activity.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/friend_tag.dart';
import 'package:social_network_app_mobile/screen/CreatePost/MenuBody/image_video.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';

class CreateNewFeed extends StatefulWidget {
  const CreateNewFeed({Key? key}) : super(key: key);

  @override
  State<CreateNewFeed> createState() => _CreateNewFeedState();
}

class _CreateNewFeedState extends State<CreateNewFeed> {
  dynamic menuSelected;
  List friendSelected = [];

  handleUpdateSelectedFriend(newList) {
    setState(() {
      friendSelected = newList;
    });
  }

  handleChooseMenu(menu) {
    if (menu == null) return;
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
      case 'media':
        body = const ImageVideo();
        buttonAppbar = const ButtonPrimary(label: "Xong");
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
            AppbarTitle(title: "Tạo bài post"),
            ButtonPrimary(label: "Đăng")
          ],
        ),
      ),
      body: Column(
        children: [
          const CreateFeedStatus(),
          CreateFeedMenu(
            handleChooseMenu: handleChooseMenu,
          )
        ],
      ),
    );
  }
}
