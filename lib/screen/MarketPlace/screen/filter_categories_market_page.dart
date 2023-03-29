import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/data/market_place_datas/product_categories_data.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/search_modules/category_search_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/category_product_item_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

import '../../../../constant/marketPlace_constants.dart';
import '../../../../widget/GeneralWidget/spacer_widget.dart';
import '../../../../widget/GeneralWidget/text_content_widget.dart';

class FilterCategoriesPage extends ConsumerStatefulWidget {
  const FilterCategoriesPage({super.key});

  @override
  ConsumerState<FilterCategoriesPage> createState() =>
      _FilterCategoriesPageState();
}

class _FilterCategoriesPageState extends ConsumerState<FilterCategoriesPage> {
  late double width = 0;
  late double height = 0;
  List<dynamic>? parentCategoriesList;
  List<dynamic>? data;
  List<dynamic>? childCategoriesList;
  @override
  void initState() {
    if (!mounted) {
      return;
    }
    super.initState();
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
    if (data == null || data!.isEmpty) {
      data = demoProductCategories;
    }
    _getParentCategoriesList();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
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
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: List.generate(parentCategoriesList!.length,
                            (index) {
                          return buildCategoryProductItemWidget(
                              context,
                              parentCategoriesList![index]["title"],
                              parentCategoriesList![index]["icon"],
                              function: () {
                            _getChildCategoriesList(
                                data![index]["subcategories"]);
                          });
                        }),
                      )),
                ),
                buildSpacer(width: 20),
                Expanded(
                    child: Container(
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
                                              crossAxisCount: 3,
                                              childAspectRatio: 0.65),
                                      itemCount: childCategoriesList?.length,
                                      itemBuilder: (context, index) {
                                        return buildCategoryProductItemWidget(
                                            context,
                                            childCategoriesList?[index]["title"]
                                                as String,
                                            childCategoriesList?[index]["icon"],
                                            function: () {
                                          pushAndReplaceToNextScreen(
                                              context,
                                              CategorySearchPage(
                                                  title: childCategoriesList?[
                                                      index]["title"]));
                                        });
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

  void _getParentCategoriesList() {
    List<dynamic> primaryProductCategories = data!.map((e) {
      return {
        "title": e["text"],
        "icon": e["icon"] != ""
            ? e["icon"]
            : "${MarketPlaceConstants.PATH_IMG}Bách hóa Online.png"
      };
    }).toList();
    parentCategoriesList = primaryProductCategories;
    setState(() {});
  }

  void _getChildCategoriesList(List<dynamic> subcategories) {
    List<dynamic> primaryList = [];
    for (int i = 0; i < subcategories.length; i++) {
      primaryList.add({
        "title": subcategories[i]["text"],
        "icon": subcategories[i]["icon"] != ""
            ? subcategories[i]["icon"]
            : "${MarketPlaceConstants.PATH_IMG}Bách hóa Online.png"
      });
    }
    childCategoriesList = primaryList;
    setState(() {});
  }
}
