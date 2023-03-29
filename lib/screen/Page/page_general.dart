import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/data/watch.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/Page/PageCreate/page_create.dart';
import 'package:social_network_app_mobile/screen/Page/page_invite.dart';
import 'package:social_network_app_mobile/screen/Page/page_liked.dart';
import 'package:social_network_app_mobile/widget/chip_menu.dart';
import 'package:social_network_app_mobile/widget/page_item.dart';

class PageGeneral extends StatelessWidget {
  const PageGeneral({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    handlePressMenu(menu) {
      Widget body = const SizedBox();
      switch (menu['key']) {
        case 'create_page':
          body = const PageCreate();
          break;
        case 'liked_page':
          body = const PageLiked();
          break;
        case 'invite_page':
          body = const PageInvite();
          break;
      }

      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: ((context) => CreateModalBaseMenu(
                  title: menu['name'],
                  body: body,
                  buttonAppbar: const SizedBox()))));
    }

    List menuButton = [
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: size.width,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  menuButton.length,
                  (index) => GestureDetector(
                        onTap: () {
                          handlePressMenu(menuButton[index]);
                        },
                        child: ChipMenu(
                            icon: Icon(
                              menuButton[index]['icon'],
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .color,
                              size: 14,
                            ),
                            isSelected: false,
                            label: menuButton[index]['name']),
                      ))),
        ),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [PageItem(page: pagesLike[i]['page'])],
              ),
            );
          },
        ))
      ],
    );
  }
}
