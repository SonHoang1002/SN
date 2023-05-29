import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/providers/market_place_providers/products_provider.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';

import '../widgets/product_item_widget.dart';

class SeeMoreMarketPage extends ConsumerStatefulWidget {
  const SeeMoreMarketPage({super.key});

  @override
  ConsumerState<SeeMoreMarketPage> createState() => _SeeMoreMarketPageState();
}

class _SeeMoreMarketPageState extends ConsumerState<SeeMoreMarketPage> {
  late double width = 0;
  late double height = 0;
  List<dynamic>? _seeMoreProductList;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    _initData();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            BackIconAppbar(),
            AppBarTitle(text: "Danh sách sản phẩm"),
            Icon(
              FontAwesomeIcons.bell,
              size: 18,
              color: Colors.black,
            )
          ],
        ),
      ),
      body: Column(children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          crossAxisCount: 2,
                          childAspectRatio:
                              height > 800 ? 0.78 : width / (height - 190),
                        ),
                        itemCount: _seeMoreProductList!.length,
                        itemBuilder: (context, index) {
                          return buildProductItem(
                              context: context,
                              data: _seeMoreProductList?[index]);
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

  _initData() {
    if (_seeMoreProductList == null || _seeMoreProductList!.isEmpty) {
      _seeMoreProductList = ref.watch(productsProvider).list;
    }
    setState(() {});
  }
}
