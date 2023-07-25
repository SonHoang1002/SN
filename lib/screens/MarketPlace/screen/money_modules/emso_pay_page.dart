import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_button.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

// ignore: must_be_immutable
class EmsoPayPage extends StatelessWidget {
  EmsoPayPage({super.key});
  double width = 0;
  double height = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
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
              AppBarTitle(title: "EMSOPAY"),
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
