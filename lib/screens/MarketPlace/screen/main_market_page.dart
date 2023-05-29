import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:market_place/constant/get_min_max_price.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/providers/market_place_providers/cart_product_provider.dart';
import 'package:market_place/providers/market_place_providers/discover_product_provider.dart';
import 'package:market_place/providers/market_place_providers/product_categories_provider.dart';
import 'package:market_place/providers/market_place_providers/products_provider.dart';
import 'package:market_place/screens/MarketPlace/screen/buyer_orders/my_order_page.dart';
import 'package:market_place/screens/MarketPlace/screen/buyer_orders/my_order_page_1.dart';
import 'package:market_place/screens/MarketPlace/screen/create_product_page.dart';
import 'package:market_place/screens/MarketPlace/screen/filter_categories_page.dart';
import 'package:market_place/screens/MarketPlace/screen/interest_product_page.dart';
import 'package:market_place/screens/MarketPlace/screen/manage_product_page.dart';
import 'package:market_place/screens/MarketPlace/screen/money_modules/emso_coin_page.dart';
import 'package:market_place/screens/MarketPlace/screen/money_modules/emso_pay_page.dart';
import 'package:market_place/screens/MarketPlace/screen/request_product_page.dart';
import 'package:market_place/screens/MarketPlace/screen/search_modules/search_market_page.dart';
import 'package:market_place/screens/MarketPlace/screen/see_more_page.dart';
import 'package:market_place/screens/MarketPlace/screen/seller_orders/manage_order_page.dart';
import 'package:market_place/screens/MarketPlace/widgets/banner_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/cart_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/category_product_item.dart';
import 'package:market_place/screens/MarketPlace/widgets/title_and_see_all.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_button.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/cross_bar.dart';

import '../../../../constant/marketPlace_constants.dart';
import '../../../../theme/colors.dart';
import '../../../providers/market_place_providers/interest_product_provider.dart';
import '../widgets/product_item_widget.dart';
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
  // List<dynamic>? all_data;
  List<dynamic>? _suggestProductList;
  List<dynamic>? _discoverProduct;
  String? _filterTitle;
  Color colorWord = primaryColor;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  double opacityForAppBar = 0.0;
  Offset? offset;

  // double _appBarOpacity = 0.0;
  // final ScrollController _scrollController1 = ScrollController();
  @override
  void initState() {
    if (!mounted) {
      return;
    }
    super.initState();

    Future.delayed(Duration.zero, () {
      final suggestProduct = ref.read(productsProvider.notifier).getProducts();
      final categoryParent = ref
          .read(parentCategoryController.notifier)
          .getParentProductCategories();
      final discoverProduct =
          ref.read(discoverProductsProvider.notifier).getDiscoverProducts();
      // final interestList = ref
      //     .read(interestProductsProvider.notifier)
      //     .addInterestProductItem({});
      final cartProduct =
          ref.read(cartProductsProvider.notifier).initCartProductList();
    });
    _filterTitle = "Lọc";

    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && !_isScrolled) {
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
    // _scrollController1.addListener(() {
    //   setState(() {
    //     _appBarOpacity = (_scrollController1.offset / 250).toDouble();
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    product_categories = [];
    _suggestProductList = [];
    _discoverProduct = [];
    _filterTitle = "";
    _isScrolled = false;
    opacityForAppBar = 0.0;
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
      product_categories = ref.watch(parentCategoryController).parentList;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    getCategoriesName();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _suggestProductList = [];
            _discoverProduct = [];
          });
          product_categories = [];
          getCategoriesName();
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              // controller: _scrollController1,
              child: Column(
                children: [
                  // buildBanner(context, width: width, height: 300),
                  const CustomBanner(),
                  buildSpacer(height: 10),
                  _rechargeExchangeCoin(),
                  const CrossBar(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _buildCategoriesComponent(),
                  ),
                  const CrossBar(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _buildSuggestComponent(),
                  ),
                  buildSpacer(height: 10),
                  const CrossBar(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _buildLatestSearchComponent(),
                  ),
                  const CrossBar(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _buildDiscoverComponent(),
                  ),
                ],
              ),
            ),
            // Column(
            //   children: [
            //     Container(
            //       height: 35,
            //       // color: _isScrolled
            //       //     ? Theme.of(context).scaffoldBackgroundColor
            //       //     : transparent,
            //     ),
            //     AnimatedOpacity(
            //       duration: const Duration(milliseconds: 200),
            //       opacity: _appBarOpacity > 1 ? 1 : _appBarOpacity,
            //       child: _customAppBar1(),
            //     ),
            //   ],
            // ),
            Column(
              children: [
                Container(
                  height: 35,
                  color: _isScrolled
                      ? Theme.of(context).scaffoldBackgroundColor
                      : transparent,
                ),
                _customAppBar(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _rechargeExchangeCoin() {
    return Container(
      height: 60,
      width: width * 0.95,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          color: Theme.of(context).colorScheme.background),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Flexible(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                //
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 9, right: 10),
                child: const Icon(FontAwesomeIcons.barcode),
              ),
            ),
          ),
          _exchangeChildWidget(FontAwesomeIcons.moneyBill, "EmsoPay",
              "Voucher giảm đến 1 tỷ VND", function: () {
            pushToNextScreen(context, EmsoPayPage());
          }),
          _exchangeChildWidget(
              FontAwesomeIcons.moneyBill, "0", "Đổi coin lấy mã giảm giá",
              function: () {
            pushToNextScreen(context, EmsoCoinPage());
          })
        ],
      ),
    );
  }

  Widget _exchangeChildWidget(
      IconData iconData, String title, String description,
      {Function? function}) {
    return Flexible(
      flex: 7,
      child: GestureDetector(
        onTap: () {
          function != null ? function() : null;
        },
        child: Row(children: [
          Container(
            margin: const EdgeInsets.only(right: 7),
            height: 25,
            width: 1,
            color: greyColor,
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      iconData,
                      size: 10,
                      color: secondaryColor,
                    ),
                    buildSpacer(width: 5),
                    buildTextContent(title, true, fontSize: 13),
                  ],
                ),
                buildTextContent(description, false, fontSize: 11),
              ]),
        ]),
      ),
    );
  }

  Widget _customAppBar1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 50,
          // color: _isScrolled
          //     ? Theme.of(context).scaffoldBackgroundColor
          //     : transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Container(
                  height: 38,
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
                              const Icon(
                                FontAwesomeIcons.magnifyingGlass,
                                size: 14,
                              ),
                              buildSpacer(width: 7),
                              buildTextContent(
                                "Tìm kiếm",
                                false,
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: () {},
                          child: const Icon(
                            FontAwesomeIcons.camera,
                            size: 14,
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
                    CartWidget(
                      iconColor:
                          Theme.of(context).textTheme.displayLarge!.color,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        _showMenuOptions();
                      },
                      child: Icon(
                        FontAwesomeIcons.bars,
                        size: 18,
                        color: Theme.of(context).textTheme.displayLarge!.color,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
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

  Widget _customAppBar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 50,
          color: _isScrolled
              ? Theme.of(context).scaffoldBackgroundColor
              : transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Container(
                  height: 38,
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
                              const Icon(
                                FontAwesomeIcons.magnifyingGlass,
                                size: 14,
                              ),
                              buildSpacer(width: 7),
                              buildTextContent(
                                "Tìm kiếm",
                                false,
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: () {},
                          child: const Icon(
                            FontAwesomeIcons.camera,
                            size: 14,
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
                    CartWidget(
                      iconColor:
                          Theme.of(context).textTheme.displayLarge!.color,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        _showMenuOptions();
                      },
                      child: Icon(
                        FontAwesomeIcons.bars,
                        size: 18,
                        color: Theme.of(context).textTheme.displayLarge!.color,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
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
                            childAspectRatio: 1.0),
                    itemCount: product_categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: buildCategoryProductItem(
                            context,
                            product_categories[index]["text"],
                            product_categories[index]["icon"] != null &&
                                    product_categories[index]["icon"] != ""
                                ? product_categories[index]["icon"]
                                : "https://media.emso.vn/sn/Category%20MKP/ThoiTrangNu.png",
                            height: 120,
                            width: 100, function: () {
                          pushToNextScreen(
                              context,
                              CategorySearchPage(
                                title: product_categories[index]["text"],
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                            crossAxisCount: 2,
                            childAspectRatio: height > 800
                                ? 0.78
                                : (width / (height - 190) > 0
                                    ? width / (height - 190)
                                    : .81)),
                        itemCount: _suggestProductList?.length,
                        itemBuilder: (context, index) {
                          return buildProductItem(
                              context: context,
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
              showCustomBottomSheet(context, 400,
                  title: "Sắp xếp theo",
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
                                buildTextContent(data[index]["text"], true,
                                    fontSize: 17),
                              ],
                              changeBackground: transparent,
                              padding: const EdgeInsets.all(5),
                              function: () {
                                popToPreviousScreen(context);

                                setState(() {
                                  _filterDiscover(data[index]["text"]);
                                  _filterTitle = data[index]["text"];
                                });
                              },
                            ),
                            buildDivider(color: greyColor),
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
                                        buildDivider(color: greyColor),
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
                                            popToPreviousScreen(context);
                                            setState(() {
                                              _filterDiscover(data[index]
                                                  ["sub_selections"][1]);
                                              _filterTitle = data[index]
                                                  ["sub_selections"][1];
                                            });
                                          },
                                        ),
                                        buildDivider(color: greyColor),
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        crossAxisCount: 2,
                        childAspectRatio: height > 800
                            ? 0.78
                            : (width / (height - 190) > 0
                                ? width / (height - 190)
                                : .81)),
                    itemCount: _discoverProduct?.length,
                    itemBuilder: (context, index) {
                      return buildProductItem(
                          context: context, data: _discoverProduct?[index]);
                    }),
              );
            }),
      ],
    );
  }

  Future getSuggestList() async {
    // if (_suggestProductList == null || _suggestProductList!.isEmpty) {
    setState(() {
      _suggestProductList = ref.watch(productsProvider).list.take(8).toList();
    });
    // }
  }

  Future getDiscoverList() async {
    if (_discoverProduct == null || _discoverProduct!.isEmpty) {
      setState(() {
        _discoverProduct = ref.watch(discoverProductsProvider).listDiscover;
      });
    }
  }

  dynamic _showMenuOptions() {
    return showCustomBottomSheet(context, 430,
        isNoHeader: true,
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Column(children: [
                  GeneralComponent(
                    [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                        child: buildTextContent("Shop của bạn", true),
                      ),
                    ],
                    changeBackground: transparent,
                    padding: const EdgeInsets.all(5),
                    function: () {},
                  ),
                  _buildRenderList(PersonalMarketPlaceConstants
                      .PERSONAL_MARKET_PLACE_YOUR_SHOP["data"]),
                ]),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Column(children: [
                  GeneralComponent(
                    [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                        child: buildTextContent("Tài khoản", true),
                      ),
                    ],
                    changeBackground: transparent,
                    padding: const EdgeInsets.all(5),
                    function: () {},
                  ),
                  _buildRenderList(PersonalMarketPlaceConstants
                      .PERSONAL_MARKET_PLACE_YOUR_ACCOUNT["data"]),
                ]),
              ),
            ],
          ),
        ));
  }

  Widget _buildRenderList(dynamic data) {
    return Column(
      children: List.generate(data.length, (index) {
        return GeneralComponent(
          [buildTextContent(data[index]["title"], false)],
          prefixWidget: Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(5),
            child: Icon(
              data[index]["icon"],
            ),
          ),
          changeBackground: transparent,
          padding: const EdgeInsets.all(5),
          function: () {
            _checkNavigator(data[index]["title"]);
          },
        );
      }).toList(),
    );
  }

  _checkNavigator(String value) {
    popToPreviousScreen(context);
    switch (value) {
      case "Quản lý đơn hàng":
        pushToNextScreen(context, const ManageOrderMarketPage());
        break;
      case "Quản lý sản phẩm":
        pushToNextScreen(context, const ManageProductMarketPage());
        break;
      case "Tạo sản phẩm mới":
        pushToNextScreen(context, const CreateProductMarketPage());
        break;
      case "Đơn mua của tôi":
        pushToNextScreen(context, const MyOrderPage1());
        break;
      case "Lời mời":
        pushToNextScreen(
            context,
            const RequestProductMarketPage(
              listProduct: [],
            ));
        break;
      default:
        pushToNextScreen(context, const InterestProductMarketPage());
        break;
    }
  }
}
