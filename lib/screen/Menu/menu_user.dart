import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/me_data.dart';
import 'package:social_network_app_mobile/screen/Menu/tranfer_account.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/user_item.dart';
import 'package:badges/badges.dart' as ChipNoti;

class MenuUser extends StatelessWidget {
  const MenuUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          UserItem(user: meData, subText: 'Xem trang cá nhân của bạn'),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15))),
                  builder: (BuildContext context) {
                    return const TranferAccount();
                  });
            },
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChipNoti.Badge(
                  badgeContent: const Text('2',
                      style: TextStyle(color: white, fontSize: 13)),
                  child: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: greyColor,
                    size: 25,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
