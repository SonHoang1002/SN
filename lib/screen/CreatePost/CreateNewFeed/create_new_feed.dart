import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widget/PickImageVideo/src/gallery/src/gallery_view.dart';
import '../../../widget/appbar_title.dart';
import '../../../widget/back_icon_appbar.dart';
import '../../../widget/button_primary.dart';
import '../MenuBody/checkin.dart';
import '../MenuBody/emoji_activity.dart';
import '../MenuBody/friend_tag.dart';
import '../MenuBody/gif.dart';
import '../MenuBody/life_event_categories.dart';
import '../create_modal_base_menu.dart';
import 'create_feed_menu.dart';
import 'create_feed_status.dart';

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

    if (menu['key'] == 'media') {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => const Expanded(child: GalleryView())));
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
        buttonAppbar =  ButtonPrimary(label: "Xong");
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
          children:  [
            BackIconAppbar(),
            AppBarTitle(title: "Tạo bài post"),
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
