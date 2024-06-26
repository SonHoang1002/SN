import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import '../../../widgets/back_icon_appbar.dart';

class RequestProductMarketPage extends StatefulWidget {
  const RequestProductMarketPage({super.key});

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
  void dispose() {
    super.dispose();
  }

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
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
