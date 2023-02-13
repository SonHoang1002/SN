import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';

import '../../../helper/push_to_new_screen.dart';
import '../../../widget/back_icon_appbar.dart';

class PaymentMarketPage extends StatefulWidget {
  const PaymentMarketPage({super.key});

  @override
  State<PaymentMarketPage> createState() => _PaymentMarketPageState();
}

class _PaymentMarketPageState extends State<PaymentMarketPage> {
  late double width = 0;
  late double height = 0;
  bool _isOpenProductOfYou = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackIconAppbar(),
            GestureDetector(
                onTap: () {
                  popToPreviousScreen(context);
                },
                child: AppBarTitle(title: "Thanh toán")),
            SizedBox()
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        height: height * 0.89,
        child: ListView(children: [
          
        ]),
      ),
    );
  }
}
