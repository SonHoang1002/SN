import 'package:flutter/material.dart';
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
            const BackIconAppbar(),
            GestureDetector(
                onTap: () {
                  popToPreviousScreen(context);
                },
                child: const AppBarTitle(title: "Thanh toán")),
            const SizedBox()
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox(
        height: height * 0.89,
        child: ListView(children: const []),
      ),
    );
  }
}
