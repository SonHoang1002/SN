import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/product_categories_provider.dart';
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
    Future.delayed(Duration.zero, () {
      final primaryData = ref
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
            // color: Colors.grey,
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: SingleChildScrollView(
                      child: Column(
                    children:
                        List.generate(parentCategoriesList!.length, (index) {
                      return InkWell(
                          onTap: () {
                            _getChildCategoriesList(
                                data![index]["subcategories"]);
                          },
                          child: buildCategoryProductItemWidget(
                            parentCategoriesList![index]["title"],
                            parentCategoriesList![index]["icon"],
                          ));
                    }),
                  )),
                ),
                buildSpacer(width: 20),
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
                                          childCategoriesList?[index]["title"]
                                              as String,
                                          childCategoriesList?[index]["icon"],
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
