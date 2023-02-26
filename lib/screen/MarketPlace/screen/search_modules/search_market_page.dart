import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/search_product_api.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/search_product_provider.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/cart_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/detail_product_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/search_modules/category_search_page.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/information_component_widget.dart';
import '../../../../widget/back_icon_appbar.dart';

class SearchMarketPage extends ConsumerStatefulWidget {
  const SearchMarketPage({super.key});

  @override
  ConsumerState<SearchMarketPage> createState() => _SearchMarketPageState();
}

class _SearchMarketPageState extends ConsumerState<SearchMarketPage> {
  late double width = 0;
  late double height = 0;
  List filteredProductList = [];
  final TextEditingController _searchController =
      TextEditingController(text: "");
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    print("search filteredProductList :$filteredProductList");
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
            InkWell(
              onTap: () {
                pushToNextScreen(context, const CartMarketPage());
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Icon(
                  FontAwesomeIcons.cartArrowDown,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            )
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
        filteredProductList = response;
      });
    }
  }

  Widget _customSearchInput(
      BuildContext context, TextEditingController searchController) {
    return Container(
        width: double.infinity,
        height: 40,
        padding: const EdgeInsets.only(top: 2, left: 5, bottom: 5),
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border.all(width: 0.2, color: greyColor),
            borderRadius: BorderRadius.circular(20)),
        child: TextFormField(
            controller: searchController,
            onChanged: (value) {
              _filterSearchList(value);
            },
            cursorColor: Theme.of(context).textTheme.displayLarge?.color,
            decoration: InputDecoration(
                hintText: "Tìm kiếm trên Marketplace",
                hintStyle: const TextStyle(fontSize: 13),
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                prefixIcon: InkWell(
                  onTap: () {},
                  child: Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Theme.of(context).textTheme.displayLarge?.color,
                    size: 17,
                  ),
                ),
                suffixIcon: searchController.text.trim().isNotEmpty
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
                            size: 15,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                      )
                    : const SizedBox())));
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
                filteredProductList == null || filteredProductList.isEmpty
                    ? Column(
                        children: [
                          Column(
                            children: List.generate(
                                1,
                                (index) => Column(
                                      children: [
                                        _buildSearchItem(
                                          {"title": "Không có dữ liệu "},
                                        ),
                                        buildDivider(
                                            color: greyColor, height: 10)
                                      ],
                                    )),
                          )
                        ],
                      )
                    : Column(
                        children: [
                          Column(
                            children: List.generate(
                                filteredProductList.length,
                                (index) => Column(
                                      children: [
                                        _buildSearchItem(
                                            filteredProductList[index]),
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
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                        children: List.generate(
                      MainMarketBodyConstants
                          .MAIN_MARKETPLACE_BODY_CATEGORY_SELECTIONS["data"]
                          .length,
                      (index) {
                        final data = MainMarketBodyConstants
                            .MAIN_MARKETPLACE_BODY_CATEGORY_SELECTIONS["data"];
                        return GeneralComponent(
                          [
                            buildTextContent(
                              data[index]["title"],
                              false,
                            )
                          ],
                          changeBackground: transparent,
                          prefixWidget: Container(
                              height: 40,
                              width: 40,
                              margin: const EdgeInsets.only(right: 5),
                              // padding: const EdgeInsets.all(5),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(data[index]["icon"]))),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          function: () async {
                            // Future.wait(
                            //   [_filterSearchList(data[index]["title"])],
                            // );
                            // await _filterSearchList(data[index]["title"]);
                            pushToNextScreen(
                                context,
                                CategorySearchPage(
                                    // categoryList: filteredProductList,
                                    title: data[index]["title"]));
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
        pushToNextScreen(context, DetailProductMarketPage(id: data["id"]));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  height: 30,
                  width: 30,
                  padding: const EdgeInsets.all(5),
                  child: data["product_image_attachments"] != null &&
                          data["product_image_attachments"].isNotEmpty
                      ? ImageCacheRender(
                          path: data["product_image_attachments"][0]
                              ["attachment"]["url"])
                      : const Icon(
                          FontAwesomeIcons.clock,
                          size: 18,
                        ),
                ),
                SizedBox(
                  width: isHaveClose ? width * 0.7 : width * 0.8,
                  child: InkWell(
                    onTap: () {
                      () {
                        pushToNextScreen(
                            context, DetailProductMarketPage(id: data["id"]));
                      };
                    },
                    child: buildTextContent(
                      "${data["title"]}",
                      false,
                      fontSize: 17,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            isHaveClose
                ? Container(
                    height: 30,
                    width: 30,
                    padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                    child: const Icon(
                      FontAwesomeIcons.close,
                      size: 18,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
