import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/search_product_api.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/data/market_place_datas/product_categories_data.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/cart_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/banner_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/cart_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/category_product_item_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/product_item_widget.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import '../../../../widget/back_icon_appbar.dart';

class CategorySearchPage extends ConsumerStatefulWidget {
  final dynamic title;
  final dynamic id;
  const CategorySearchPage({super.key, required this.title, this.id});

  @override
  ConsumerState<CategorySearchPage> createState() => _CategorySearchPageState();
}

class _CategorySearchPageState extends ConsumerState<CategorySearchPage> {
  late double width = 0;
  late double height = 0;
  List? _filteredProductList;
  List? _childCategoryList;
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            const CartWidget(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          buildBanner(context),
          _buildCategoriesComponent(),
          const CrossBar(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _filteredProductList == null
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return SizedBox(
                          width: width * 0.4,
                          height: 200,
                          child: CardSkeleton());
                    })
                : _filteredProductList!.isEmpty
                    ? Center(
                        child: buildTextContent("Không có dữ liệu", true,
                            fontSize: 20, isCenterLeft: false),
                      )
                    : GridView.builder(
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
        ]),
      ),
    );
  }

  Widget _buildCategoriesComponent() {
    return Column(
      children: [
        _childCategoryList == null
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return SizedBox(
                      width: width * 0.4, height: 200, child: CardSkeleton());
                })
            : _childCategoryList!.isEmpty
                ? Center(
                    child: buildTextContent("Không có dữ liệu", true,
                        fontSize: 20, isCenterLeft: false),
                  )
                : Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: _childCategoryList!.length > 6 ? 230 : 140,
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
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 0,
                                    crossAxisCount: _childCategoryList!.length >
                                            6
                                        ? 2
                                        : 1,
                                    childAspectRatio:
                                        _childCategoryList!.length > 6
                                            ? 1.1
                                            : 1.3),
                            itemCount: _childCategoryList?.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: buildCategoryProductItemWidget(
                                    context,
                                    _childCategoryList?[index]["text"],
                                    _childCategoryList?[index]["icon"] != ""
                                        ? _childCategoryList![index]["icon"]
                                        : "${MarketPlaceConstants.PATH_IMG}Bách hóa Online.png",
                                    height: 120,
                                    width: 100, function: () {
                                  pushToNextScreen(
                                      context,
                                      CategorySearchPage(
                                          title: _childCategoryList?[index]
                                              ["title"]));
                                }),
                              );
                            }))),
      ],
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
    }
    if (_childCategoryList == null || _childCategoryList!.isEmpty) {
      for (var element in demoProductCategories) {
        if (element["id"] == widget.id) {
          _childCategoryList = element["subcategories"];
          setState(() {});
          return;
        }
      }
    }
  }
}
