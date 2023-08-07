import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/category_product_apis.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/province_api.dart';
import 'package:social_network_app_mobile/constant/get_min_max_price.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/products_provider.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/screen/notification_market_page.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/filter_product_body.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/messenger_app_bar/app_bar_title.dart';

class FilterPage extends ConsumerStatefulWidget {
  final dynamic categoryData;
  const FilterPage({super.key, this.categoryData});

  @override
  ConsumerState<FilterPage> createState() => _FilterPageState();
}

const String childCategory = "childCategory";
const String province = "province";
List filterList = [
  {'key': "popular", "title": "Phổ biến"},
  {'key': "newest", "title": "Mới nhất"},
  {'key': "sold", "title": "Bán chạy"},
  {'key': "currency", "title": "Giá"},
];

class _FilterPageState extends ConsumerState<FilterPage> {
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackIconAppbar(),
                AppBarTitle(title: (widget.categoryData?['text']) ?? "Lọc theo hạng mục"),
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
        body: FilterPageBody(
          categoryData: widget.categoryData,
        ));
  }
}
