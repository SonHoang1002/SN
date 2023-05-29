import 'package:flutter/material.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_button.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';

// ignore: must_be_immutable
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
              AppBarTitle(text: "Thông báo"),
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
          ],
        ));
  }
}
