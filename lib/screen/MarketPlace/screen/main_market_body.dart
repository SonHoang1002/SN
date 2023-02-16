import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/detail_product_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/product_categories_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/products_provider.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/see_more_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/category_product_item_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

import '../../../../constant/marketPlace_constants.dart';
import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/divider_widget.dart';
import '../../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../../widget/GeneralWidget/text_content_widget.dart';
import '../widgets/product_item_widget.dart';
import 'filter_categories_market_page.dart';

class MainMarketBody extends ConsumerStatefulWidget {
  @override
  ConsumerState<MainMarketBody> createState() => _MainMarketBodyState();
}

class _MainMarketBodyState extends ConsumerState<MainMarketBody> {
  late double width = 0;

  late double height = 0;
  List<dynamic> product_categories = [];
  late List<dynamic> all_data;
  List<dynamic>? suggestProduct;
  @override
  void initState() {
    if (!mounted) {
      return;
    }
    super.initState();

    Future.delayed(Duration.zero, () {
      final data = ref
          .read(productCategoriesProvider.notifier)
          .getListProductCategories();
      final suggestProduct =
          ref.read(suggestProductsProvider.notifier).getSuggestProducts();
      // getDetailProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    all_data = ref.watch(productCategoriesProvider).list;
    getProductCategoriesName();
    return Stack(
      children: [
        Column(children: [
          // main content
          Expanded(
            child: Container(
              // padding: const EdgeInsets.symmetric(horizontal: 10),
              // color: Colors.grey[900],
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // buy and category
                    // tim lai o test.dart
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _buildCategoriesComponent(),
                    ),
                    CrossBar(
                      height: 10,
                    ),
                    // suggest product
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _buildSuggestProductComponent(),
                    ),
                    buildSpacer(height: 10),
                    CrossBar(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _buildDiscoverProductComponent(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),
      ],
    );
  }

  Widget _buildCategoriesComponent() {
    return Column(
      children: [
        _buildTitleAndSeeAll(
          "Hạng mục",
          suffixWidget: buildTextContent("Xem tất cả", false,
              fontSize: 14, colorWord: greyColor, function: () {
            pushToNextScreen(context, FilterCategoriesPage());
          }),
          iconData: FontAwesomeIcons.angleRight,
        ),
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(product_categories.length, (index) {
                  final data = product_categories;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: buildCategoryProductItemWidget(
                        product_categories[index],
                        MarketPlaceConstants.PATH_IMG + "Bách hóa Online.png",
                        height: 120,
                        width: 100),
                  );
                }),
              )),
        ),
      ],
    );
  }

  Widget _buildSuggestProductComponent() {
    return Column(
      children: [
        _buildTitleAndSeeAll(
          "Gợi ý cho bạn",
          suffixWidget: buildTextContent("Xem tất cả", false,
              fontSize: 14, colorWord: greyColor, function: () {
            pushToNextScreen(context, SeeMoreMarketPage());
          }),
          iconData: FontAwesomeIcons.angleRight,
        ),
        FutureBuilder(
            future: getSuggestProduct(),
            builder: (context, buider) {
              return SingleChildScrollView(
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
                    itemCount: suggestProduct?.length,
                    // shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (buider.connectionState == ConnectionState.done) {
                        return buildProductItem(
                            context: context,
                            width: width,
                            data: suggestProduct?[index]);
                      } else {
                        return CardSkeleton();
                      }
                    }),
              );
            }),
      ],
    );
  }

  Widget _buildDiscoverProductComponent() {
    return Column(
      children: [
        _buildTitleAndSeeAll("Khám phá sản phẩm",
            suffixWidget: buildTextContent("Lọc", false, function: () {
              showBottomSheetCheckImportantSettings(
                  context, 400, "Sắp xếp theo",
                  bgColor: greyColor[400],
                  widget: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: MainMarketBodyConstants
                          .MAIN_MARKETPLACE_BODY_SORT_SELECTIONS["data"].length,
                      itemBuilder: (context, index) {
                        final data = MainMarketBodyConstants
                            .MAIN_MARKETPLACE_BODY_SORT_SELECTIONS["data"];
                        return Column(
                          children: [
                            GeneralComponent(
                              [
                                buildTextContent(data[index]["title"], true,
                                    fontSize: 17),
                              ],
                              changeBackground: transparent,
                              padding: const EdgeInsets.all(5),
                            ),
                            buildDivider(color: red),
                            data[index]["sub_selections"] != null
                                ? Column(
                                    children: [
                                      GeneralComponent(
                                        [
                                          buildTextContent(
                                              data[index]["sub_selections"][0],
                                              true,
                                              fontSize: 17),
                                        ],
                                        changeBackground: transparent,
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                      ),
                                      buildDivider(color: red),
                                      GeneralComponent(
                                        [
                                          buildTextContent(
                                              data[index]["sub_selections"][1],
                                              true,
                                              fontSize: 17),
                                        ],
                                        changeBackground: transparent,
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                      ),
                                      buildDivider(color: red),
                                    ],
                                  )
                                : SizedBox()
                          ],
                        );
                      }));
            }),
            iconData: FontAwesomeIcons.filter),
        FutureBuilder(
            future: getSuggestProduct(),
            builder: (context, builder) {
              return SingleChildScrollView(
                child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                            crossAxisCount: 2,
                            childAspectRatio: 0.8),
                    itemCount: suggestProduct?.length,
                    // shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return buildProductItem(
                          context: context,
                          width: width,
                          data: suggestProduct?[index]);
                    }),
              );
            }),
      ],
    );
  }

  getProductCategoriesName() {
    List<dynamic> primaryProductCategories = all_data.map((e) {
      return e["text"];
    }).toList();
    for (int i = 0; i < all_data.length; i++) {
      primaryProductCategories.add(all_data[i]["text"]);
    }
    product_categories = primaryProductCategories;

    setState(() {});
  }

  // getDetailProduct() {
  //   ref.read(detailProductProvider.notifier).getDetailProduct("1");

  //   setState(() {});
  // }

  Future getSuggestProduct() async {
    suggestProduct = ref.watch(suggestProductsProvider).listSuggest;
    print("data: ${suggestProduct}");
    setState(() {});
  }
}

_buildTitleAndSeeAll(String title, {Widget? suffixWidget, IconData? iconData}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildTextContent(
          title,
          true,
          fontSize: 22,
          // colorWord: blackColor,
        ),
        Row(
          children: [
            suffixWidget ?? const SizedBox(),
            buildSpacer(width: 5),
            iconData != null
                ? Icon(
                    iconData,
                    color: greyColor,
                    size: 14,
                  )
                : const SizedBox()
          ],
        ),
      ],
    ),
  );
}
