import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:social_network_app_mobile/data/market_place_datas/product_categories_data.dart';
import 'package:social_network_app_mobile/helper/get_min_max_price.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/cart_product_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/discover_product_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/interest_product_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/products_provider.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/personal_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/search_modules/search_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/see_more_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/banner_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/cart_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/category_product_item_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/title_and_see_all.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_button.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

import '../../../../constant/marketPlace_constants.dart';
import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/divider_widget.dart';
import '../../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../../widget/GeneralWidget/text_content_widget.dart';
import '../widgets/product_item_widget.dart';
import 'filter_categories_market_page.dart';
import 'search_modules/category_search_page.dart';

class MainMarketPage extends ConsumerStatefulWidget {
  const MainMarketPage({super.key});

  @override
  ConsumerState<MainMarketPage> createState() => _MainMarketPageState();
}

class _MainMarketPageState extends ConsumerState<MainMarketPage> {
  late double width = 0;

  late double height = 0;
  List<dynamic> product_categories = [];
  List<dynamic>? all_data;
  List<dynamic>? _suggestProductList;
  List<dynamic>? _discoverProduct;
  String? _filterTitle;
  Color colorWord = ThemeMode.dark == true
      ? white
      : true == ThemeMode.light
          ? blackColor
          : blackColor;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  double opacityForAppBar = 0.0;
  @override
  void initState() {
    if (!mounted) {
      return;
    }
    super.initState();

    Future.delayed(Duration.zero, () {
      final suggestProduct = ref.read(productsProvider.notifier).getProducts();
      final discoverProduct =
          ref.read(discoverProductsProvider.notifier).getDiscoverProducts();
      final interestList = ref
          .read(interestProductsProvider.notifier)
          .addInterestProductItem({});
      final cartProduct =
          ref.read(cartProductsProvider.notifier).initCartProductList();
    });
    _filterTitle = "Lọc";
    _scrollController.addListener(() {
      if (_scrollController.offset > 30 && !_isScrolled) {
        setState(() {
          _isScrolled = true;
          opacityForAppBar = _scrollController.offset / 100.0;
        });
      } else if (_scrollController.offset <= 100 && _isScrolled) {
        setState(() {
          _isScrolled = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;

    if (all_data == null || all_data!.isEmpty) {
      all_data = demoProductCategories;
    }
    getCategoriesName();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                buildBanner(context, width: width, height: 300),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildCategoriesComponent(),
                ),
                const CrossBar(
                  height: 10,
                ),
                // suggest product
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildSuggestComponent(),
                ),
                buildSpacer(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildLatestSearchComponent(),
                ),
                const CrossBar(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildDiscoverComponent(),
                )
              ],
            ),
          ),
          Column(
            children: [
              Container(
                height: 50,
                color: _isScrolled ? secondaryColor : transparent,
              ),
              _customAppBar(),
            ],
          )
        ],
      ),
    );
  }

  Widget _customAppBar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 50,
          color: _isScrolled
              ? secondaryColor
                  .withOpacity(opacityForAppBar > 1 ? 1.0 : opacityForAppBar)
              : transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: BackIconAppbar(),
              ),
              Expanded(
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border.all(color: greyColor, width: 0.4),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            pushToNextScreen(context, const SearchMarketPage());
                          },
                          child: Row(
                            children: [
                              buildSpacer(width: 7),
                              Icon(
                                FontAwesomeIcons.magnifyingGlass,
                                size: 14,
                                color: colorWord,
                              ),
                              buildSpacer(width: 7),
                              buildTextContent(
                                "Tìm kiếm",
                                false,
                                fontSize: 12,
                                colorWord: colorWord,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: () {},
                          child: Icon(
                            FontAwesomeIcons.camera,
                            size: 14,
                            color: colorWord,
                          )),
                      buildSpacer(width: 7)
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const CartWidget(),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        pushToNextScreen(
                            context, const PersonalMarketPlacePage());
                      },
                      child: Icon(
                        FontAwesomeIcons.user,
                        size: 16,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox()
      ],
    );
  }

  Widget _buildCategoriesComponent() {
    return Column(
      children: [
        buildTitleAndSeeAll(
          "Hạng mục",
          suffixWidget: buildTextContentButton("Xem tất cả", false,
              fontSize: 14, colorWord: greyColor, function: () {
            pushToNextScreen(context, const FilterCategoriesPage());
          }),
          iconData: FontAwesomeIcons.angleRight,
        ),
        Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 230,
            padding: const EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                            crossAxisCount: 2,
                            // childAspectRatio: 0.79),
                            childAspectRatio: 1.0),
                    itemCount: product_categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: buildCategoryProductItemWidget(
                            context,
                            product_categories[index]["title"],
                            product_categories[index]["icon"] != ""
                                ? product_categories[index]["icon"]
                                : "${MarketPlaceConstants.PATH_IMG}Bách hóa Online.png",
                            height: 120,
                            width: 100, function: () {
                          pushToNextScreen(
                              context,
                              CategorySearchPage(
                                title: product_categories[index]["title"],
                                id: product_categories[index]["id"],
                              ));
                        }),
                      );
                    }))),
      ],
    );
  }

  Widget _buildSuggestComponent() {
    return Column(
      children: [
        buildTitleAndSeeAll(
          "Gợi ý cho bạn",
          suffixWidget: buildTextContentButton("Xem tất cả", false,
              fontSize: 14, colorWord: greyColor, function: () {
            pushToNextScreen(context, const SeeMoreMarketPage());
          }),
          iconData: FontAwesomeIcons.angleRight,
        ),
        FutureBuilder<void>(
            future: getSuggestList(),
            builder: (context, builder) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(top: 10),
                child: _suggestProductList != null &&
                        _suggestProductList!.isNotEmpty
                    ? GridView.builder(
                        padding: EdgeInsets.zero,
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
                          return SizedBox(
                              width: width * 0.4,
                              height: 200,
                              child: CardSkeleton());
                        }),
              );
            }),
      ],
    );
  }

  Widget _buildLatestSearchComponent() {
    return Column(
      children: [
        buildTitleAndSeeAll(
          "Tìm kiếm hàng đầu",
          suffixWidget: buildTextContentButton("Xem tất cả", false,
              fontSize: 14, colorWord: greyColor, function: () {
            pushToNextScreen(context, const SeeMoreMarketPage());
          }),
          iconData: FontAwesomeIcons.angleRight,
        ),
        FutureBuilder<void>(
            future: getSuggestList(),
            builder: (context, builder) {
              return _suggestProductList != null &&
                      _suggestProductList!.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                          children: List.generate(_suggestProductList!.length,
                              (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            onTap: () {},
                            child: buildProductItem(
                                context: context,
                                width: width,
                                data: _suggestProductList?[index]),
                          ),
                        );
                      })))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return SizedBox(
                            width: width * 0.4,
                            height: 200,
                            child: CardSkeleton());
                      });
            }),
      ],
    );
  }

  Widget _buildDiscoverComponent() {
    return Column(
      children: [
        buildTitleAndSeeAll("Khám phá sản phẩm",
            suffixWidget:
                buildTextContentButton(_filterTitle!, false, function: () {
              showCustomBottomSheet(context, 400, "Sắp xếp theo",
                  // bgColor: greyColor[400],
                  widget: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: MainMarketPageConstants
                          .MAIN_MARKETPLACE_BODY_SORT_SELECTIONS["data"].length,
                      itemBuilder: (context, index) {
                        final data = MainMarketPageConstants
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
                                _filterDiscover(data[index]["title"]);
                                _filterTitle = data[index]["title"];
                                setState(() {});
                                popToPreviousScreen(context);
                              },
                            ),
                            buildDivider(color: red),
                            data[index]["sub_selections"] != null
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Column(
                                      children: [
                                        GeneralComponent(
                                          [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            buildTextContent(
                                                data[index]["sub_selections"]
                                                    [0],
                                                true,
                                                fontSize: 17),
                                            const SizedBox(
                                              height: 5,
                                            )
                                          ],
                                          changeBackground: transparent,
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          function: () {
                                            popToPreviousScreen(context);
                                            setState(() {
                                              _filterDiscover(data[index]
                                                  ["sub_selections"][0]);
                                              _filterTitle = data[index]
                                                  ["sub_selections"][0];
                                            });
                                          },
                                        ),
                                        buildDivider(color: red),
                                        GeneralComponent(
                                          [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            buildTextContent(
                                                data[index]["sub_selections"]
                                                    [1],
                                                true,
                                                fontSize: 17),
                                            const SizedBox(
                                              height: 5,
                                            )
                                          ],
                                          changeBackground: transparent,
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          function: () {
                                            setState(() {
                                              popToPreviousScreen(context);
                                              _filterDiscover(data[index]
                                                  ["sub_selections"][1]);
                                              _filterTitle = data[index]
                                                  ["sub_selections"][1];
                                            });
                                          },
                                        ),
                                        buildDivider(color: red),
                                      ],
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        );
                      }));
            }),
            iconData: FontAwesomeIcons.filter),
        FutureBuilder<void>(
            future: getDiscoverList(),
            builder: (context, builder) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(top: 10),
                child: GridView.builder(
                    padding: EdgeInsets.zero,
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

  Future getSuggestList() async {
    _suggestProductList = ref.watch(productsProvider).list.take(8).toList();
    setState(() {});
  }

  Future getDiscoverList() async {
    _discoverProduct = ref.watch(discoverProductsProvider).listDiscover;
    setState(() {});
  }

  void _filterDiscover(String sortedTitle) { 
    List<dynamic> filterDiscoverList = _discoverProduct!;
    const String newTitle = "Mới nhất";
    const String soldRun = "Bán chạy";
    const String maxToMin = "Cao đến thấp";
    const String minToMax = "Thấp đến cao";

    switch (sortedTitle) {
      case newTitle:
        for (int i = 0; i < filterDiscoverList.length - 1; i++) {
          for (int j = 0; j < filterDiscoverList.length - i - 1; j++) {
            if (DateTime.parse(filterDiscoverList[j]["created_at"])
                    .microsecondsSinceEpoch <
                DateTime.parse(filterDiscoverList[j + 1]["created_at"])
                    .microsecondsSinceEpoch) {
              dynamic temp = filterDiscoverList[j];
              filterDiscoverList[j] = filterDiscoverList[j + 1];
              filterDiscoverList[j + 1] = temp;
            }
          }
        }
        break;
      case soldRun:
        for (int i = 0; i < filterDiscoverList.length - 1; i++) {
          for (int j = 0; j < filterDiscoverList.length - i - 1; j++) {
            if (filterDiscoverList[j]["sold"] <
                filterDiscoverList[j + 1]["sold"]) {
              dynamic temp = filterDiscoverList[j];
              filterDiscoverList[j] = filterDiscoverList[j + 1];
              filterDiscoverList[j + 1] = temp;
            }
          }
        }
        break;
      case maxToMin:
        for (int i = 0; i < filterDiscoverList.length - 1; i++) {
          for (int j = 0; j < filterDiscoverList.length - i - 1; j++) {
            if (getMinAndMaxPrice(
                    filterDiscoverList[j]["product_variants"])[1] <
                getMinAndMaxPrice(
                    filterDiscoverList[j + 1]["product_variants"])[1]) {
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
                    filterDiscoverList[j]["product_variants"])[0] >
                getMinAndMaxPrice(
                    filterDiscoverList[j + 1]["product_variants"])[0]) {
              dynamic temp = filterDiscoverList[j];
              filterDiscoverList[j] = filterDiscoverList[j + 1];
              filterDiscoverList[j + 1] = temp;
            }
          }
        }
        break;
      default:
        break;
    }
    _discoverProduct = filterDiscoverList;
    setState(() {});
  }

  void getCategoriesName() {
    if (product_categories.isEmpty) {
      List<dynamic> primaryProductCategories = [];
      for (int i = 0; i < all_data!.length; i++) {
        primaryProductCategories.add({
          "id": all_data![i]["id"],
          "title": all_data![i]["text"],
          "icon": all_data![i]["icon"]
        });
      }
      product_categories = primaryProductCategories;

      setState(() {});
    }
  }
}
