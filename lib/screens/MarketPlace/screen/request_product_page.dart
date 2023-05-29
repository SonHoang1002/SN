import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';

class RequestProductMarketPage extends StatefulWidget {
  final List<dynamic> listProduct;
  const RequestProductMarketPage({super.key, required this.listProduct});
  @override
  State<RequestProductMarketPage> createState() =>
      _RequestProductMarketPageState();
}

class _RequestProductMarketPageState extends State<RequestProductMarketPage> {
  late double width = 0;
  late double height = 0;
  dynamic addressList;
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
              AppBarTitle(text: "Lời mời"),
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
          ],
        ));
  }
}
