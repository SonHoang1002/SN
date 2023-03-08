import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';

import '../../../../widget/back_icon_appbar.dart';

class RequestProductMarketPage extends StatefulWidget {
  @override
  State<RequestProductMarketPage> createState() =>
      _RequestProductMarketPageState();
}

class _RequestProductMarketPageState extends State<RequestProductMarketPage> {
  late double width = 0;
  late double height = 0;

  @override
  void initState() {
    super.initState();
  }

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
              AppBarTitle(title: "Lời mời"),
              Icon(
                FontAwesomeIcons.bell,
                size: 18,
                color: Colors.black,
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                // padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: buildTextContent("Không có lời mời nào", true,
                          fontSize: 19, isCenterLeft: false),
                    )
                  ],
                ),
              ),
            ),
            //
          ],
        ));
  }
}
