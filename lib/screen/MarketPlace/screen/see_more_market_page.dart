import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/products_provider.dart';
import '../../../widget/appbar_title.dart';
import '../../../widget/back_icon_appbar.dart';
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
    // Future.delayed(Duration.zero, () {
    //   final interestProductList =
    //       ref.read(suggestProductsProvider.notifier).getSuggestProducts();
    // });
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
            AppBarTitle(title: "Danh sách sản phẩm"),
            Icon(
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
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                                crossAxisCount: 2,
                                // childAspectRatio: 0.79),
                                childAspectRatio: 0.8),
                        itemCount: _seeMoreProductList!.length,
                        // shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return buildProductItem(
                              context: context,
                              width: width,
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
    _seeMoreProductList = ref.watch(suggestProductsProvider).listSuggest;
    setState(() {});
  }
}
