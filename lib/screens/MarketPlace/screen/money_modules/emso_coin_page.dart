import 'package:flutter/material.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_button.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';

// ignore: must_be_immutable
class EmsoCoinPage extends StatelessWidget {
  EmsoCoinPage({super.key});
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
              AppBarTitle(text: "EMSOPAY"),
              SizedBox()
            ],
          ),
        ),
        body: Column(
          children: [
            SingleChildScrollView(
                child: Container(
              margin: const EdgeInsets.only(top: 30),
              child: buildTextContentButton(
                  "Nạp lần đầu để nhận ngay 10 tỷ Ecoin chơi chứng khoán",
                  true,
                  fontSize: 19,
                  isCenterLeft: false,
                  function: () {}),
            )),
          ],
        ));
  }
}
