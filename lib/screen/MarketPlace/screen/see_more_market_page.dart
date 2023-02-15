import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/detail_product_market_page.dart';

import '../../../../constant/marketPlace_constants.dart';
import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/divider_widget.dart';
import '../../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../../widget/GeneralWidget/text_content_widget.dart';
import '../../../../widget/button_primary.dart';
import '../../../../widget/image_cache.dart';
import '../../../widget/appbar_title.dart';
import '../../../widget/back_icon_appbar.dart';
import '../widgets/product_item_widget.dart';

class SeeMoreMarketPage extends StatelessWidget {
  late double width = 0;
  late double height = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackIconAppbar(),
              const AppBarTitle(title: "Gợi ý sản phẩm"),
              const Icon(
                FontAwesomeIcons.bell,
                size: 18,
                color: Colors.black,
              )
            ],
          ),
        ),
      body: Column(children: [
        // main content
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                                crossAxisCount: 2,
                                // childAspectRatio: 0.79),
                                childAspectRatio: 0.87),
                        itemCount: MainMarketBodyConstants
                            .MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_CONTENTS[
                                "data"]
                            .length,
                        // shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final data = MainMarketBodyConstants
                                  .MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_CONTENTS[
                              "data"];
                          return buildOldProductItem(
                                context: context,
                                id: data[index]["id"].toString(),
                                imgPath: data[index]["img"],
                                width: width,
                                title: data[index]["title"],
                                price: [
                                  data[index]["min_price"],
                                  data[index]["max_price"] != null
                                      ? data[index]["max_price"]
                                      : null
                                ],
                                rate: data[index]["rate"],
                                selled: data[index]["selled"]);
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}


 