import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_button.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import '../../../../widget/back_icon_appbar.dart';

class NotificationMarketPage extends StatelessWidget {
  NotificationMarketPage({super.key});
  double width = 0;
  double height = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackIconAppbar(),
              AppBarTitle(title: "Thông báo"),
              SizedBox()
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    height: 300,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: buildTextContentButton(
                        "Không có thông báo nào ", true,
                        fontSize: 19, isCenterLeft: false, function: () {}),
                  )
                ],
              ),
            ),
            //
          ],
        ));
  }
}
