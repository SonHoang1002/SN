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
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

import '../../../../constant/marketPlace_constants.dart';
import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/divider_widget.dart';
import '../../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../../widget/GeneralWidget/text_content_widget.dart';
import '../widgets/product_item_widget.dart';

class FilterCategoriesPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<FilterCategoriesPage> createState() =>
      _FilterCategoriesPageState();
}

class _FilterCategoriesPageState extends ConsumerState<FilterCategoriesPage> {
  late double width = 0;

  late double height = 0;
  List<String>? parentCategoriesList;
  List<ProductCategoriesItem>? data;
  List<String>? childCategoriesList;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    data = ref.watch(productCategoriesProvider).list;
    _getParentCategoriesList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackIconAppbar(),
            AppBarTitle(title: "Lọc theo hạng mục"),
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
            // color: Colors.grey,
            child: Row(
              children: [
                Container(
                  width: 80,
                  child: SingleChildScrollView(
                      child: Column(
                    children:
                        List.generate(parentCategoriesList!.length, (index) {
                      return InkWell(
                        onTap: () {
                          _getChildCategoriesFromParentCategoriesList(
                              data![index].subcategories);
                        },
                        child: buildCategoryProductItemWidget(
                            parentCategoriesList![index],
                            MarketPlaceConstants.PATH_IMG +
                                "Bách hóa Online.png"),
                      );
                    }),
                  )),
                ),
                buildSpacer(width: 20),
                // Container(
                //   color: red,
                //   width: 10,
                //   margin: EdgeInsets.symmetric(horizontal: 5),
                // ),
                Expanded(
                    child: Container(
                        // color: red,
                        child: childCategoriesList != null
                            ? Container(
                              alignment: Alignment.topCenter,
                              child: SingleChildScrollView(
                                  padding: EdgeInsets.zero,
                                  child: GridView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisSpacing: 10,
                                              // mainAxisSpacing: 5,
                                              crossAxisCount: 3,
                                              // childAspectRatio: 0.79),
                                              childAspectRatio: 0.65),
                                      itemCount: childCategoriesList?.length,
                                      // shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return buildCategoryProductItemWidget(
                                            childCategoriesList?[index] as String,
                                            MarketPlaceConstants.PATH_IMG +
                                                "Bách hóa Online.png",
                                            );
                                      }),
                                ),
                            )
                            : buildTextContent(
                                "Mời bạn chọn một hạng mục", true,
                                isCenterLeft: false)))
              ],
            ),
          ),
        ),
      ]),
    );
  }

  _getParentCategoriesList() {
    List<String> primary_product_categories = [];
    for (int i = 0; i < data!.length; i++) {
      primary_product_categories.add(data![i].text);
    }

    parentCategoriesList = primary_product_categories;
    setState(() {});
  }

  _getChildCategoriesFromParentCategoriesList(
      List<ProductCategoriesItem> subcategories) {
    List<String> primaryList = [];

    for (int i = 0; i < subcategories.length; i++) {
      primaryList.add(subcategories[i].text);
    }
    childCategoriesList = primaryList;
    setState(() {});
  }

  
}
