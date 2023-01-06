import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/data/watch.dart';
import 'package:social_network_app_mobile/screen/Page/page_create.dart';
import 'package:social_network_app_mobile/screen/Page/page_invite.dart';
import 'package:social_network_app_mobile/screen/Page/page_liked.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/page_item.dart';

class PageGeneral extends StatefulWidget {
  final dynamic data;
  const PageGeneral({super.key, this.data});

  @override
  State<PageGeneral> createState() => _PageGeneralState();
}

class _PageGeneralState extends State<PageGeneral> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            BackIconAppbar(),
            AppBarTitle(title: 'Trang'),
            SizedBox()
          ],
        ),
      ),
      body: getBody(),
    );
  }

  getBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topBody(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(
              height: 2,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
            child: Text(
              'Trang bạn quản lý',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: pagesLike.length,
            itemBuilder: (context, i) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [PageItem(page: pagesLike[i]['page'])],
                ),
              );
            },
          ))
        ],
      ),
    );
  }

  topBody() {
    var menuButton = [
      {
        'key': 'create_page',
        'name': 'Tạo',
        'icon': FontAwesomeIcons.circlePlus
      },
      {
        'key': 'liked_page',
        'name': 'Trang đã thích',
        'icon': FontAwesomeIcons.solidThumbsUp
      },
      {
        'key': 'invite_page',
        'name': 'Lời mời',
        'icon': FontAwesomeIcons.userPlus
      },
    ];

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                menuButton.length,
                (index) => ButtonSocial(
                      name: menuButton[index]['name'],
                      icon: menuButton[index]['icon'],
                      onTapButton: () {
                        print('2');
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    handleNavigator(menuButton[index]['key'])));
                      },
                    ))));
  }

  handleNavigator(key) {
    switch (key) {
      case 'create_page':
        return PageCreate();
      case 'liked_page':
        return PageLiked();
      case 'invite_page':
        return PageInvite();
      default:
    }
  }
}

class ButtonSocial extends StatelessWidget {
  final name;
  final icon;
  final onTapButton;
  const ButtonSocial(
      {super.key, this.name, this.icon, required this.onTapButton});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Theme.of(context).colorScheme.background),
        child: InkWell(
          onTap: () {
            onTapButton();
          },
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                icon != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Icon(
                          icon,
                          color:
                              Theme.of(context).textTheme.displayLarge!.color,
                          size: 14,
                        ),
                      )
                    : const SizedBox(),
                Text(
                  name!,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 13),
                )
              ]),
        ));
  }
}
