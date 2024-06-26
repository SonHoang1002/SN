import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/review_item_widget.dart';

import 'notification_market_page.dart';

import 'notification_market_page.dart';

import 'notification_market_page.dart';

class ReviewAllProductPage extends StatefulWidget {
  final List<dynamic> listProduct;
  const ReviewAllProductPage({super.key, required this.listProduct});
  @override
  State<ReviewAllProductPage> createState() => _ReviewAllProductPageState();
}

class _ReviewAllProductPageState extends State<ReviewAllProductPage> {
  late double width = 0;
  late double height = 0;
  dynamic addressList;
  @override
  void initState() {
    super.initState();
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackIconAppbar(),
              const AppBarTitle(title: "Đánh giá sản phẩm"),
              InkWell(
                onTap: () {
                  pushToNextScreen(context, NotificationMarketPage());
                },
                child: const Icon(
                  FontAwesomeIcons.bell,
                  size: 18,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
              children: List.generate(
                  widget.listProduct.length,
                  (index) => buildReviewItemWidget(
                      context, widget.listProduct[index]))),
        ));
  }
}
