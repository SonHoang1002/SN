import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/category_product_apis.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/products_api.dart';

import 'package:social_network_app_mobile/data/market_datas/list_category.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/products_provider.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/screen/see_more_page.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/banner_widget.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/cart_widget.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/category_product_item.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/classify_category_conponent.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/product_item_widget.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/search_product_api.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/title_and_see_all.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_button.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';

class CategorySearchPage extends ConsumerStatefulWidget {
  final String? questionKeyWord;
  final dynamic title;
  final dynamic categoryObject;
  const CategorySearchPage(
      {super.key,
      required this.title,
      required this.categoryObject,
      this.questionKeyWord});

  @override
  ConsumerState<CategorySearchPage> createState() => _CategorySearchPageState();
}

class _CategorySearchPageState extends ConsumerState<CategorySearchPage> {
  late double width = 0;
  late double height = 0;
  List? _filteredProductList;
  List? _childCategoryList;
  List<dynamic>? suggestList;
  var paramConfig = {
    "limit": 10,
  };
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (ref.watch(productsProvider).list.isEmpty) {
        await ref.read(productsProvider.notifier).getProducts(paramConfig);
      }
      await _initData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _filteredProductList = [];
    _childCategoryList = [];
    suggestList = [];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
    Future.wait([_initData()]);
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
            CartWidget(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          const CustomBanner(),
          _buildCategoriesComponent(),
          const CrossBar(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _filteredProductList == null
                ? _buildSkeletonWidget()
                : _filteredProductList!.isEmpty
                    ? Center(
                        child: buildTextContent("Không có dữ liệu", true,
                            fontSize: 20, isCenterLeft: false),
                      )
                    : GridView.builder(
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
                        itemCount: _filteredProductList!.length,
                        itemBuilder: (context, index) {
                          return buildProductItem(
                              context: context,
                              data: _filteredProductList![index]);
                        }),
          ),
          const CrossBar(
            height: 5,
          ),
          suggestList != null
              ? buildSuggestListComponent(
                  context: context,
                  title: buildTitleAndSeeAll(
                    "Có thể bạn sẽ thích",
                    suffixWidget: buildTextContentButton("Xem tất cả", false,
                        fontSize: 14, colorWord: greyColor, function: () {
                      pushToNextScreen(context, const SeeMoreMarketPage());
                    }),
                    iconData: FontAwesomeIcons.angleRight,
                  ),
                  axis: Axis.vertical,
                  contentList: suggestList!,
                )
              : _buildSkeletonWidget()
        ]),
      ),
    );
  }

  Widget _buildCategoriesComponent() {
    return _childCategoryList == null
        ? _buildSkeletonWidget()
        : _childCategoryList!.isEmpty
            ? Container(
                margin: const EdgeInsets.only(top: 10),
                child: buildTextContent("Không có hạng mục nhỏ hơn", true,
                    fontSize: 20, isCenterLeft: false),
              )
            : Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: _childCategoryList!.length > 6 ? 250 : 150,
                padding: const EdgeInsets.only(top: 10),
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                            crossAxisCount:
                                _childCategoryList!.length > 6 ? 2 : 1,
                            childAspectRatio:
                                _childCategoryList!.length > 6 ? 1.1 : 1.3),
                        itemCount: _childCategoryList?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: buildCategoryProductItem(
                                context,
                                _childCategoryList?[index]["text"],
                                _childCategoryList?[index]["icon"] != null &&
                                        _childCategoryList?[index]["icon"] != ""
                                    ? _childCategoryList![index]["icon"]
                                    : "https://media.emso.vn/sn/Category%20MKP/ThoiTrangNu.png",
                                height: 120,
                                width: 100, function: () {
                              pushToNextScreen(
                                  context,
                                  CategorySearchPage(
                                      title: _childCategoryList?[index]
                                          ["title"],
                                      categoryObject: widget.categoryObject));
                            }),
                          );
                        })));
  }

  Future _initData() async {
    await _initFilterCategory();
    await _initChildCategory();
    await _initSuggest();
    setState(() {});
  }

  Future _initFilterCategory() async {
    if (_filteredProductList == null) {
      Future.delayed(Duration.zero, () async {
        _filteredProductList = await ProductsApi().getProductsApi(
            widget.questionKeyWord != null
                ? {"q": widget.questionKeyWord, ...paramConfig}
                : paramConfig);
      });
    }
  }

  Future _initChildCategory() async {
    _childCategoryList ??=
        await _getChildCategoryList(widget.categoryObject['id']);
  }

  Future<dynamic> _getChildCategoryList(dynamic id) async {
    final response = await CategoryProductApis().getChildCategoryProductApi(id,
        widget.categoryObject['has_children'] ? {"subcategories": true} : null);
    return response;
  }

  Future _initSuggest() async {
    if (ref.watch(productsProvider).list.isEmpty) {
      final suggestProductList = await ref
          .read(productsProvider.notifier)
          .getProductsSearch(paramConfig);
    }
    if (suggestList == null || suggestList!.isEmpty) {
      suggestList = ref.watch(productsProvider).list;
    }
  }

  Widget _buildSkeletonWidget() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 1,
        itemBuilder: (context, index) {
          return SizedBox(
              width: width * 0.4, height: 200, child: CardSkeleton());
        });
  }
}
