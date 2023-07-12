import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/product_categories_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/search_product_provider.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/screen/detail_product_page.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/screen/search_modules/category_search_page.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/cart_widget.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/search_product_api.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/general_component.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_button.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';
import '../../../../theme/colors.dart';

class SearchMarketPage extends ConsumerStatefulWidget {
  const SearchMarketPage({super.key});

  @override
  ConsumerState<SearchMarketPage> createState() => _SearchMarketPageState();
}

class _SearchMarketPageState extends ConsumerState<SearchMarketPage> {
  late double width = 0;
  late double height = 0;
  List _filteredProductList = [];
  List _historyProductList = [];
  final TextEditingController _searchController =
      TextEditingController(text: "");
  FocusNode _focusNode = FocusNode();
  bool _isExpand = false;
  var paramConfig = {"entity_type": "Product", "limit": 10};
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _focusNode.requestFocus();
      final a = await ref
          .read(searchedHistoryProvider.notifier)
          .getHistorySearch(paramConfig);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        final listSearched = ref.watch(searchedHistoryProvider).listSearched;
        if (listSearched.isNotEmpty) {
          setState(() {
            _historyProductList =
                ref.watch(searchedHistoryProvider).listSearched;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _filteredProductList = [];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            Expanded(child: _customSearchInput(context, _searchController)),
            const SizedBox(
              width: 10,
            ),
            CartWidget(
                iconColor: Theme.of(context).textTheme.displayLarge!.color),
          ],
        ),
      ),
      body: Stack(
        children: [categoryBodyWidget()],
      ),
    );
  }

  Future _filterSearchList(
    dynamic searchValue,
  ) async {
    if (searchValue == null || searchValue == "") {
      callSearchApi({"limit": 6});
      setState(() {});
      return;
    }
    EasyDebounce.debounce('my-debouncer', const Duration(milliseconds: 100),
        () {
      callSearchApi({"q": searchValue, "limit": 6});
    });
  }

  callSearchApi(dynamic data) async {
    final response = await SearchProductsApi().searchProduct(data);
    if (response != null) {
      setState(() {
        _filteredProductList = response;
      });
    }
  }

  Widget _customSearchInput(
      BuildContext context, TextEditingController searchController) {
    return Container(
        width: double.infinity,
        height: 45,
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border.all(width: 0.2, color: greyColor),
            borderRadius: BorderRadius.circular(5)),
        child: TextFormField(
            focusNode: _focusNode,
            controller: searchController,
            onChanged: (value) {
              _filterSearchList(value);
            },
            cursorColor: Theme.of(context).textTheme.displayLarge?.color,
            decoration: InputDecoration(
                hintText: "Tìm kiếm trên Marketplace",
                hintStyle: const TextStyle(fontSize: 13),
                contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                border: InputBorder.none,
                prefixIcon: InkWell(
                  onTap: () {},
                  child: Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Theme.of(context).textTheme.displayLarge?.color,
                    size: 14,
                  ),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    searchController.text.trim().isNotEmpty
                        ? InkWell(
                            onTap: () {
                              _searchController.text = "";
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                  color: transparent, shape: BoxShape.circle),
                              child: Icon(
                                FontAwesomeIcons.xmark,
                                size: 16,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        FontAwesomeIcons.camera,
                        size: 16,
                        color: Theme.of(context).textTheme.displayLarge!.color,
                      ),
                    )
                  ],
                ))));
  }

  Widget categoryBodyWidget() {
    return GestureDetector(
      onTap: (() {
        FocusManager.instance.primaryFocus!.unfocus();
      }),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(children: [
                // tim kiem gan day
                _filteredProductList.isEmpty
                    ? _historyProductList.isNotEmpty
                        ? Column(
                            children: List.generate(
                                _isExpand ? _historyProductList.length : 3,
                                (index) {
                              return Column(children: [
                                _buildSearchItem(_historyProductList[index]),
                                buildDivider(color: greyColor, height: 10),
                                ((!_isExpand && index == 2) ||
                                            (_isExpand && index == 8)) &&
                                        _historyProductList.isNotEmpty
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: buildTextContentButton(
                                            _isExpand ? "Thu gọn" : "Xem thêm",
                                            false,
                                            fontSize: 13,
                                            isCenterLeft: false, function: () {
                                          setState(() {
                                            _isExpand = !_isExpand;
                                          });
                                        }),
                                      )
                                    : const SizedBox()
                              ]);
                            }),
                          )
                        : Container(
                            margin: const EdgeInsets.only(top: 20),
                            height: 40,
                            width: double.infinity,
                            child: buildCircularProgressIndicator())
                    : Column(
                        children: [
                          Column(
                            children: List.generate(
                                _filteredProductList.length,
                                (index) => Column(
                                      children: [
                                        _buildSearchItem(
                                            _filteredProductList[index]),
                                        buildDivider(
                                            color: greyColor, height: 10)
                                      ],
                                    )),
                          )
                        ],
                      ),
                buildSpacer(height: 10),
                // hang muc tim kiem
                buildTextContent("Hạng mục tìm kiếm", true, fontSize: 20),
                buildSpacer(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                        children: List.generate(
                      ref.watch(parentCategoryController).parentList.length,
                      (index) {
                        final data =
                            ref.watch(parentCategoryController).parentList;
                        return GeneralComponent(
                          [
                            buildTextContent(
                              data[index]["text"],
                              false,
                            )
                          ],
                          changeBackground: transparent,
                          prefixWidget: Container(
                              height: 30,
                              width: 30,
                              margin: const EdgeInsets.only(right: 5),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(data[index]["icon"]))),
                          function: () async {
                            pushToNextScreen(
                                context,
                                CategorySearchPage(
                                    title: data[index]["text"],
                                    categoryObject: data[index]));
                          },
                        );
                      },
                    )),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchItem(dynamic data, {bool isHaveClose = false}) {
    return InkWell(
      onTap: () {
        // if (data["id"] != null) {
        //   pushToNextScreen(context,
        //       DetailProductMarketPage(simpleData: data, id: data["id"]));
        // }
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: isHaveClose ? width * 0.69 : width * 0.79,
              child: buildTextContent(
                "${data["keyword"] ?? data["name"]}",
                false,
                fontSize: 17,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
