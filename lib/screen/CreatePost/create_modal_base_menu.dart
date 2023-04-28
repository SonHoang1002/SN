import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

class CreateModalBaseMenu extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget buttonAppbar;

  const CreateModalBaseMenu(
      {Key? key,
      required this.title,
      required this.body,
      required this.buttonAppbar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        leading: const BackIconAppbar(),
        centerTitle: true,
        title: AppBarTitle(
          title: title,
        ),
        actions: [buttonAppbar],
      ),
      body: body,
    );
  }
}
