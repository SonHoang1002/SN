import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/search_product_api.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/search_product_provider.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/cart_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/product_item_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import '../../../../widget/back_icon_appbar.dart';

class CategorySearchPage extends ConsumerStatefulWidget {
  // final List<dynamic> categoryList;
  final dynamic title;
  const CategorySearchPage(
      {super.key,
      //  required this.categoryList,
      required this.title});

  @override
  ConsumerState<CategorySearchPage> createState() => _CategorySearchPageState();
}

class _CategorySearchPageState extends ConsumerState<CategorySearchPage> {
  late double width = 0;
  late double height = 0;
  List? _filteredProductList;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _filteredProductList = await SearchProductsApi().searchProduct({
        "q": widget.title,
        "limit": 10,
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    Future.wait([_initData()]);
    print("category search $_filteredProductList");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            AppBarTitle(title: widget.title.toString()),
            InkWell(
              onTap: () {
                pushToNextScreen(context, const CartMarketPage());
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Icon(
                  FontAwesomeIcons.cartArrowDown,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
      body: Column(children: [
        // main content
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _filteredProductList == null
                ? const Center(
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        strokeWidth: 3,
                      ),
                    ),
                  )
                : _filteredProductList!.isEmpty
                    ?  Center(
                        child: buildTextContent("Không có dữ liệu",true,fontSize: 20,isCenterLeft: false),
                      )
                    : SingleChildScrollView(
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
                                  itemCount: _filteredProductList!.length,
                                  // shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return buildProductItem(
                                        context: context,
                                        width: width,
                                        data: _filteredProductList![index]);
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

  Future _initData() async {
    if (_filteredProductList == null) {
      final response = await SearchProductsApi().searchProduct({
        "q": widget.title,
        "limit": 10,
      });
      _filteredProductList = response;
      setState(() {});
      // Future.delayed(Duration.zero, () {
      //   final filteredProductList = ref
      //       .read(searchProductsProvider.notifier)
      //       .getSearchProducts(widget.title);
      // });
      // _filteredProductList = ref.watch(searchProductsProvider).listSearch;
      // setState(() {});
    }
  }
}
