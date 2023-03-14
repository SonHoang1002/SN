import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

class PageEditMediaProfile extends StatelessWidget {
  final String typePage;
  final dynamic entityObj;
  const PageEditMediaProfile({Key? key, required this.typePage, this.entityObj})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            AppBarTitle(
                title: typePage == 'avatar'
                    ? "Xem trước ảnh đại diện"
                    : "Xem trước ảnh bìa"),
            Container()
          ],
        ),
      ),
    );
  }
}
