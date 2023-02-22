import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:social_network_app_mobile/helper/get_min_max_price.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/cart_product_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/detail_product_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/discover_product_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/interest_product_provider.dart';
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
  List<dynamic>? _suggestProductList;
  List<dynamic>? _discoverProduct;
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
      final discoverProduct =
          ref.read(discoverProductsProvider.notifier).getDiscoverProducts();
      final interestList = ref
          .read(interestProductsProvider.notifier)
          .addInterestProductItem({});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    print("height:$height");
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
                    // tim lai o test.dart

                    buildTextContent("thêm icon vào hạng mục", true,
                        fontSize: 16),
                    buildTextContent(
                        "chưa làm sort theo Mới nhất, Bán chạy,", true,
                        fontSize: 16),
                    buildTextContent("custom cardSkeleton", true, fontSize: 16),
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
            height: 230,
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                            crossAxisCount: 2,
                            // childAspectRatio: 0.79),
                            childAspectRatio: 1.1),
                    itemCount: product_categories.length,
                    // shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: buildCategoryProductItemWidget(
                            product_categories[index]["title"],
                            product_categories[index]["icon"] != ""
                                ? product_categories[index]["icon"]
                                : "${MarketPlaceConstants.PATH_IMG}Bách hóa Online.png",
                            height: 120,
                            width: 100),
                      );
                    }))),
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
            future: getSuggestProductList(),
            builder: (context, builder) {
              return SingleChildScrollView(
                child: _suggestProductList != null &&
                        _suggestProductList!.isNotEmpty
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                                crossAxisCount: 2,
                                childAspectRatio: 0.78),
                        // childAspectRatio: 0.78),
                        itemCount: _suggestProductList?.length,
                        itemBuilder: (context, index) {
                          return buildProductItem(
                              context: context,
                              width: width,
                              data: _suggestProductList?[index]);
                        })
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Container(
                              width: width * 0.4,
                              height: 200,
                              child: CardSkeleton());
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
                  // bgColor: greyColor[400],
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
                              function: () {
                                _filterDiscoverProduct(data[index]["title"]);
                                popToPreviousScreen(context);
                              },
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
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                        changeBackground: transparent,
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        function: () {
                                          _filterDiscoverProduct(
                                              data[index]["sub_selections"][0]);
                                          popToPreviousScreen(context);
                                        },
                                      ),
                                      buildDivider(color: red),
                                      GeneralComponent(
                                        [
                                          buildTextContent(
                                              data[index]["sub_selections"][1],
                                              true,
                                              fontSize: 17),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                        changeBackground: transparent,
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        function: () {
                                          _filterDiscoverProduct(
                                              data[index]["sub_selections"][1]);
                                          popToPreviousScreen(context);
                                        },
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
            future: getDiscoverProductList(),
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
                            childAspectRatio: 0.78),
                    itemCount: _discoverProduct?.length,
                    // shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return buildProductItem(
                          context: context,
                          width: width,
                          data: _discoverProduct?[index]);
                    }),
              );
            }),
      ],
    );
  }

  Future getSuggestProductList() async {
    _suggestProductList =
        ref.watch(suggestProductsProvider).listSuggest.take(6).toList();
    setState(() {});
  }

  Future getDiscoverProductList() async {
    _discoverProduct = ref.watch(discoverProductsProvider).listDiscover;
    setState(() {});
  }

  Future _filterDiscoverProduct(String sortedTitle) async {
    List<dynamic> filterDiscoverList = _discoverProduct!;
    const String newTitle = "Mới nhất";
    const String soldRun = "Bán chạy";
    const String maxToMin = "Giá: Cao đến thấp";
    const String minToMax = "Giá: Thấp đến cao";

    switch (sortedTitle) {
      case newTitle:
        break;
      case soldRun:
        break;
      case maxToMin:
        for (int i = 0; i < filterDiscoverList.length - 1; i++) {
          for (int j = 0; j < filterDiscoverList.length - i - 1; j++) {
            if (getMinAndMaxPrice(
                    filterDiscoverList[j]["product_variants"])[0] <
                getMinAndMaxPrice(
                    filterDiscoverList[j + 1]["product_variants"])[0]) {
              dynamic temp = filterDiscoverList[j];
              filterDiscoverList[j] = filterDiscoverList[j + 1];
              filterDiscoverList[j + 1] = temp;
            }
          }
        }
        break;
      case minToMax:
        for (int i = 0; i < filterDiscoverList.length - 1; i++) {
          for (int j = 0; j < filterDiscoverList.length - i - 1; j++) {
            if (getMinAndMaxPrice(
                    filterDiscoverList[j]["product_variants"])[1] >
                getMinAndMaxPrice(
                    filterDiscoverList[j + 1]["product_variants"])[1]) {
              dynamic temp = filterDiscoverList[j];
              filterDiscoverList[j] = filterDiscoverList[j + 1];
              filterDiscoverList[j + 1] = temp;
            }
          }
        }
        break;
      default:
    }
    _discoverProduct = filterDiscoverList;
    setState(() {});
  }

  getProductCategoriesName() {
    if (product_categories.isEmpty) {
      List<dynamic> primaryProductCategories = [];
      //  = all_data.map((e) {
      //   return e["text"];
      // }).toList();
      for (int i = 0; i < all_data.length; i++) {
        primaryProductCategories
            .add({"title": all_data[i]["text"], "icon": all_data[i]["icon"]});
      }
      product_categories = primaryProductCategories;

      setState(() {});
    }
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
