import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/moment.dart';

import 'package:social_network_app_mobile/widgets/search_input.dart';
import 'package:social_network_app_mobile/widgets/user_item.dart';

class DrawerMoment extends StatelessWidget {
  const DrawerMoment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 140,
          child: DrawerHeader(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tài khoản đang theo dõi',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 5,
              ),
              SearchInput()
            ],
          )),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: List.generate(
                  friendMoment.length,
                  (index) => Padding(
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 8, right: 8, left: 10),
                        child: UserItem(user: friendMoment[index]),
                      )),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
