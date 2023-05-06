import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/Friend/friend_of_you.dart';
import 'package:social_network_app_mobile/screen/Friend/friend_render.dart';
import 'package:social_network_app_mobile/screen/Friend/friend_suggest.dart';
import 'package:social_network_app_mobile/widget/chip_menu.dart';

class Friend extends StatefulWidget {
  const Friend({Key? key}) : super(key: key);

  @override
  State<Friend> createState() => _GroupState();
}

class _GroupState extends State<Friend> {
  String menuSelected = "";

  @override
  Widget build(BuildContext context) {
    List menuFriend = [
      {
        "key": "suggest-friend",
        "label": "Gợi ý",
      },
      {
        "key": "your-frieend",
        "label": "Bạn bè",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              children: List.generate(
                  menuFriend.length,
                  (index) => GestureDetector(
                        onTap: () {
                          menuFriend[index]['key'] == 'suggest-friend'
                              ? Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const FriendSuggest()),
                                )
                              : Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const FriendOfYou()),
                                );
                        },
                        child: ChipMenu(
                          isSelected: false,
                          label: menuFriend[index]['label'],
                        ),
                      )),
            ),
          ),
        ),
        const Divider(
          height: 20,
          thickness: 1,
          indent: 18,
          endIndent: 18,
        ),
        const FriendRender()
      ],
    );
  }
}
