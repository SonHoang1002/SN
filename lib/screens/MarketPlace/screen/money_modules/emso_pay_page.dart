import 'package:flutter/material.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_button.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';

// ignore: must_be_immutable
class EmsoPayPage extends StatelessWidget {
  EmsoPayPage({super.key});
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
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            child: buildTextContentButton(
                "Nạp tiền vào ví để có thể trở thành BillGate của Việt Nam",
                true,
                fontSize: 19,
                isCenterLeft: false,
                function: () {}),
          ),
        ));
  }
}
