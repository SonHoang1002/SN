import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

class CreateModalBaseMenu extends StatelessWidget {
  final String title;
  final Widget body;
  const CreateModalBaseMenu({Key? key, required this.title, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackIconAppbar(),
              AppBarTitle(
                title: title,
              ),
              const SizedBox()
            ],
          )),
      body: body,
    );
  }
}
