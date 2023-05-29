import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/apis/market_place_apis/category_product_apis.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/providers/market_place_providers/product_categories_provider.dart';
import 'package:market_place/screens/MarketPlace/screen/search_modules/category_search_page.dart';
import 'package:market_place/screens/MarketPlace/widgets/category_product_item.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';

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
  bool _isLoading = true;
  List<dynamic>? childCategoriesList;
  int parentSelectionIndex = 0;
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
    parentCategoriesList = [];
    childCategoriesList = [];
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
          children: const [
            BackIconAppbar(),
            AppBarTitle(text: "Lọc theo hạng mục"),
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
                          return Container(
                            decoration: index == parentSelectionIndex
                                ? BoxDecoration(
                                    border: Border.all(
                                        color: secondaryColor, width: 1))
                                : null,
                            child: buildCategoryProductItem(
                                context,
                                parentCategoriesList![index]["text"],
                                parentCategoriesList![index]["icon"] != null &&
                                        parentCategoriesList![index]["icon"] !=
                                            ""
                                    ? parentCategoriesList![index]["icon"]
                                    : "https://media.emso.vn/sn/Category%20MKP/ThoiTrangNu.png",
                                function: () {
                              parentSelectionIndex = index;
                              _getChildCategoriesList(
                                  parentCategoriesList![parentSelectionIndex]
                                      ["id"]);
                              setState(() {});
                            }),
                          );
                        }),
                      )),
                ),
                buildSpacer(width: 20),
                Expanded(
                    child: Container(
                        child: childCategoriesList != null &&
                                childCategoriesList!.isNotEmpty
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
                                        return buildCategoryProductItem(
                                            context,
                                            childCategoriesList?[index]["text"]
                                                as String,
                                                
                                            childCategoriesList![index]
                                                            ["icon"] !=
                                                        null &&
                                                    childCategoriesList![index]
                                                            ["icon"] !=
                                                        ""
                                                ? childCategoriesList![index]
                                                    ["icon"]
                                                : "https://media.emso.vn/sn/Category%20MKP/ThoiTrangNu.png",
                                                titleSize: 10,
                                            function: () {
                                          pushAndReplaceToNextScreen(
                                              context,
                                              CategorySearchPage(
                                                  title: childCategoriesList?[
                                                      index]["text"]));
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

  Future _initData() async {
    if (parentCategoriesList == null || parentCategoriesList!.isEmpty) {
      parentCategoriesList = ref.watch(parentCategoryController).parentList;
    }
    if (childCategoriesList == null || childCategoriesList!.isEmpty) {
      childCategoriesList = await getChildCategoryList(
          parentCategoriesList![parentSelectionIndex]["id"]);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future _getChildCategoriesList(dynamic parentId) async {
    setState(() {
      _isLoading = true;
    });
    print(
        "parentCategoriesList ${parentCategoriesList![parentSelectionIndex]}");
    childCategoriesList = await getChildCategoryList(
        parentCategoriesList![parentSelectionIndex]["id"]);
    setState(() {
      _isLoading = false;
    });
  }

  Future<dynamic> getChildCategoryList(dynamic id) async {
    final response =
        await CategoryProductApis().getChildCategoryProductApi(int.parse(id));
    return response;
  }
}
