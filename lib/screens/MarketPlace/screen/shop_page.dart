import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/apis/market_place_apis/category_product_apis.dart';
import 'package:market_place/constant/common.dart';
import 'package:market_place/helpers/common.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/screens/MarketPlace/screen/filter_categories_page.dart';
import 'package:market_place/screens/MarketPlace/screen/main_market_page.dart';
import 'package:market_place/screens/MarketPlace/widgets/classify_category_conponent.dart';
import 'package:market_place/screens/MarketPlace/widgets/filter_product_body.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/cross_bar.dart';

import '../../../providers/market_place_providers/products_provider.dart';
import '../widgets/circular_progress_indicator.dart';

class ShopPage extends ConsumerStatefulWidget {
  final dynamic pageData;
  const ShopPage({super.key, this.pageData});
  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List? listSuggest;
  ValueNotifier<List<dynamic>?> listProductShop =
      ValueNotifier<List<dynamic>?>(null);
  ScrollController _productScrollController = ScrollController();
  ValueNotifier<List<dynamic>?> listCategory =
      ValueNotifier<List<dynamic>?>(null);
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref
          .read(productsProvider.notifier)
          .getProductsSearch(paramConfigProductSearch);
      listCategory.value =
          await CategoryProductApis().getParentCategoryProductApi();
      listSuggest = ref.read(productsProvider).list;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ValueListenableBuilder(
            valueListenable: listProductShop,
            builder: (context, value, child) {
              return CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    floating: false,
                    delegate: HeaderPersistentDelegate(
                        pageData: widget.pageData,
                        tabController: _tabController),
                  ),
                  SliverFillRemaining(
                    fillOverscroll: true,
                    child: Stack(children: [
                      TabBar(
                        controller: _tabController,
                        onTap: (index) {},
                        indicatorColor: primaryColor,
                        labelColor: primaryColor,
                        unselectedLabelColor:
                            Theme.of(context).textTheme.displayLarge!.color,
                        tabs: [
                          Tab(
                              child: buildTextContent("Shop", false,
                                  fontSize: 12, isCenterLeft: false)),
                          Tab(
                              child: buildTextContent("Sản phẩm", false,
                                  fontSize: 12, isCenterLeft: false)),
                          Tab(
                              child: buildTextContent("Danh mục hàng", false,
                                  fontSize: 12, isCenterLeft: false)),
                        ],
                      ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: TabBarView(
                            // Thêm TabBarView vào đây
                            controller: _tabController,
                            children: [
                              _buildShopTabView(),
                              _buildProductTabView(),
                              _buildCategoriesTabView()
                            ],
                          ),
                        ),
                      ),
                    ]),
                  )
                ],
              );
            }));
  }

  Widget _buildShopTabView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          listSuggest != null
              ? Container(
                  margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: SuggestListComponent(
                    context: context,
                    axis: Axis.horizontal,
                    controller: _productScrollController,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTextContent("Gợi ý cho bạn", true, fontSize: 15),
                        Row(
                          children: [
                            buildTextContent("Xem tất cả", false,
                                fontSize: 13, colorWord: secondaryColor),
                            buildSpacer(width: 5),
                            const Icon(
                              FontAwesomeIcons.chevronRight,
                              size: 13,
                              color: secondaryColor,
                            )
                          ],
                        )
                      ],
                    ),
                    contentList: listSuggest!,
                    isShowAll: true,
                  ),
                )
              : const SizedBox(),
          const CrossBar(
            height: 7,
            opacity: 0.2,
          ),
          listSuggest != null
              ? Container(
                  margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: SuggestListComponent(
                    context: context,
                    axis: Axis.vertical,
                    productIsVertical: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTextContent("Sản phẩm bán chạy", true,
                            fontSize: 15),
                        Row(
                          children: [
                            buildTextContent("Xem tất cả", false,
                                fontSize: 13, colorWord: secondaryColor),
                            buildSpacer(width: 5),
                            const Icon(
                              FontAwesomeIcons.chevronRight,
                              size: 13,
                              color: secondaryColor,
                            )
                          ],
                        )
                      ],
                    ),
                    contentList: listSuggest!.take(3).toList(),
                    isShowAll: true,
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget _buildProductTabView() {
    return Column(
      children: [
        buildSpacer(height: 10),
        Flexible(
          child: Stack(
            children: [
              listProductShop.value == null
                  ? Center(
                      child: buildCircularProgressIndicator(),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          buildSpacer(height: 50),
                          Flexible(
                            child: SuggestListComponent(
                              context: context,
                              title: const SizedBox(),
                              contentList: listProductShop.value!,
                              isLoading: true,
                              isLoadingMore: true,
                              callbackFunction: () async {
                                // dynamic params = {
                                //   "offset": listProductShop.value,
                                //   ...{"limit":3,"visibility": "public"},
                                // };
                                // var response = await ProductsApi()
                                //     .getShopProducts(widget.pageData, params);
                                //   List newList = checkObjectUniqueInList(
                                //       listProductShop.value! + response, "id");
                                //   Future.delayed(
                                //       const Duration(milliseconds: 200),
                                //       () async {
                                //     setState(() {
                                //       listProductShop.value = newList;
                                //     });
                                //   });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
              FilterPageBody(
                shopId: widget.pageData['id'],
                callbackFunction: () {
                  setState(() {});
                },
                updateDataFunction: (newList) {
                  setState(() {
                    listProductShop.value = null;
                  });
                  Future.delayed(const Duration(milliseconds: 200), () async {
                    setState(() {
                      listProductShop.value = newList;
                    });
                  });
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCategoriesTabView() {
    return listCategory.value != null
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemCount: listCategory.value!.length,
            itemBuilder: (ctx, index) {
              final item = listCategory.value![index];
              return Column(
                children: [
                  GeneralComponent(
                    [
                      buildTextContent((item?['text']) ?? "", false,
                          fontSize: 15),
                      buildSpacer(height: 7),
                      buildTextContent(
                        "${Random().nextInt(1000)} sản phẩm",
                        false,
                        fontSize: 12,
                        colorWord: greyColor,
                      ),
                    ],
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    changeBackground: transparent,
                    prefixWidget: ExtendedImage.network(
                      (item?['icon']) ?? linkBannerDefault,
                      height: 30,
                      width: 30,
                    ),
                    suffixWidget: const Icon(
                      FontAwesomeIcons.chevronRight,
                      size: 16,
                      color: secondaryColor,
                    ),
                    function: () {
                      pushToNextScreen(
                          context,
                          const FilterPage(
                              // categoryData: {
                              //   "id": 4547,
                              //   "text": "Thời Trang Nữ",
                              //   "icon":
                              //       "https://s3-hn-2.cloud.cmctelecom.vn/sn-web/images/product_categories/icon_categories/Th%E1%BB%9Di%20Trang%20N%E1%BB%AF.png",
                              //   "parent_category_id": null,
                              //   "has_children": true,
                              //   "level": 1,
                              //   "category_attributes": []
                              // },
                              ));
                    },
                  ),
                  const CrossBar(
                    height: 2,
                    opacity: 0.2,
                  )
                ],
              );
            })
        : Center(
            child: buildCircularProgressIndicator(),
          );
  }
}

class HeaderPersistentDelegate extends SliverPersistentHeaderDelegate {
  final dynamic pageData;
  final TabController tabController;
  HeaderPersistentDelegate(
      {required this.pageData, required this.tabController});

  @override
  double get maxExtent => 230;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = MediaQuery.sizeOf(context);
    double shrinkPercentage = min(1, shrinkOffset / (maxExtent - minExtent));

    return Stack(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueAccent,
                ),
              ),
              child: Material(
                elevation: 0,
                child: Stack(
                  children: [
                    Image.network(
                      (pageData?['banner']?['url']) ?? linkBannerDefault,
                      width: size.width,
                      fit: BoxFit.cover,
                      opacity: const AlwaysStoppedAnimation(0.75),
                    ),
                    Positioned.fill(
                        child: Container(
                      color: blackColor.withOpacity(0.5),
                    )),
                    AnimatedOpacity(
                      opacity: 1 - shrinkPercentage,
                      duration: const Duration(milliseconds: 200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: EdgeInsets.only(
                                top: 110 * (1 - shrinkPercentage), bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: SizedBox(
                                    height: 65,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 60.0,
                                          width: 60.0,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: ExtendedImage.network(
                                              pageData?["avatar_media"]
                                                      ?['url'] ??
                                                  linkAvatarDefault,
                                              height: 60.0,
                                              width: 60.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: size.width * 0.5),
                                              child: buildTextContent(
                                                  pageData?['title'] ??
                                                      "Kim Cuong hy lac",
                                                  true,
                                                  fontSize: 14,
                                                  maxLines: 1,
                                                  colorWord: white,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            buildSpacer(height: 5),
                                            buildTextContent(
                                                pageData?['status'] ?? "Online",
                                                false,
                                                fontSize: 14,
                                                colorWord: greyColor),
                                            buildSpacer(height: 5),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  size: 17,
                                                  color: Colors.yellow,
                                                ),
                                                buildTextContent(
                                                    " ${pageData?['rating_product_count'] ?? 0} / 5.0",
                                                    true,
                                                    colorWord: white,
                                                    fontSize: 14),
                                                Container(
                                                    height: 15,
                                                    width: 2,
                                                    color: greyColor,
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 6)),
                                                buildTextContent(
                                                    "${shortenNumber(pageData?['follow_count'] ?? 0)} ",
                                                    true,
                                                    colorWord: white,
                                                    fontSize: 14),
                                                buildTextContent(
                                                    " Người theo dõi", false,
                                                    colorWord: white,
                                                    fontSize: 14),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildButton(context,
                                          title: "Theo dõi",
                                          bgColor: secondaryColor),
                                      _buildButton(context,
                                          title: "Chat", bgColor: transparent),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: blueColor,
              margin: const EdgeInsets.only(top: 60),
              height: 45,
              width: MediaQuery.sizeOf(context).width,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context,
      {Function? onPress, String? title, IconData? iconData, Color? bgColor}) {
    return ElevatedButton(
        onPressed: () {
          onPress != null ? onPress() : null;
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.resolveWith((states) => bgColor),
            shape: MaterialStateProperty.resolveWith(
              (states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
                side: const BorderSide(
                  color: white,
                  width: 0.5,
                ),
              ),
            ),
            maximumSize: MaterialStateProperty.resolveWith(
                (states) => const Size(65, 30)),
            minimumSize: MaterialStateProperty.resolveWith(
                (states) => const Size(40, 30)),
            alignment: Alignment.center,
            padding: MaterialStateProperty.resolveWith((states) =>
                const EdgeInsets.symmetric(horizontal: 4, vertical: 0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconData != null
                ? Container(
                    margin: const EdgeInsets.only(right: 7),
                    child: Icon(iconData))
                : const SizedBox(),
            buildTextContent(title ?? "", false,
                colorWord: white, fontSize: 12, isCenterLeft: false)
          ],
        ));
  }
}

class HeaderPersistentWidget extends StatelessWidget {
  final dynamic pageData;
  final TabController tabController;
  HeaderPersistentWidget({required this.pageData, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          floating: false,
          delegate: HeaderPersistentDelegate(
              pageData: pageData, tabController: tabController),
        ),
      ],
    );
  }
}
