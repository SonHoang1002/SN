import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/screen/Setting/darkmode_setting.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            BackIconAppbar(),
            AppbarTitle(title: "Cài đặt"),
            SizedBox(),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: ((context) => const DarkModeSetting())));
        },
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Row(
            children: const [
              Icon(FontAwesomeIcons.moon),
              SizedBox(
                width: 8,
              ),
              Text("Chế độ tối")
            ],
          ),
        ),
      ),
    );
  }
}
