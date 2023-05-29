import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/constant/marketPlace_constants.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/providers/market_place_providers/search_product_provider.dart';
import 'package:market_place/screens/MarketPlace/screen/cart_market_page.dart';
import 'package:market_place/screens/MarketPlace/screen/detail_product_page.dart';
import 'package:market_place/screens/MarketPlace/screen/search_modules/category_search_page.dart';
import 'package:market_place/screens/MarketPlace/widgets/cart_widget.dart';
import 'package:market_place/apis/market_place_apis/search_product_api.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_button.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/image_cache.dart';
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
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _focusNode.requestFocus();
      final a = ref.read(searchedHistoryProvider.notifier).getHistorySearch();
    });
    // Future.wait([_initData()]);
  }

  @override
  void dispose() {
    super.dispose();
    _filteredProductList = [];
  }

  Future _initData() async {
    if (_historyProductList == null || _historyProductList.isEmpty) {
      setState(() {
        _historyProductList = ref.watch(searchedHistoryProvider).listSearched;
      });
    }
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
                _filteredProductList == null || _filteredProductList.isEmpty
                    ? Column(
                        children: List.generate(
                            _isExpand ? _historyProductList.length : 3,
                            (index) {
                          return Column(children: [
                            _buildSearchItem(_historyProductList.isNotEmpty &&
                                    _historyProductList[index]
                                            ["search_params"] !=
                                        null
                                ? _historyProductList[index]
                                : {
                                    "id": null,
                                    "search_params": "Không có dữ liệu"
                                  }),
                            buildDivider(color: greyColor, height: 10),
                            !_isExpand && index == 2
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: buildTextContentButton(
                                        "Xem thêm", false,
                                        fontSize: 13,
                                        isCenterLeft: false, function: () {
                                      setState(() {
                                        _isExpand = true;
                                      });
                                    }),
                                  )
                                : const SizedBox()
                          ]);
                        }),
                      )
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
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                        children: List.generate(
                      MainMarketPageConstants
                          .MAIN_MARKETPLACE_BODY_CATEGORY_SELECTIONS["data"]
                          .length,
                      (index) {
                        final data = MainMarketPageConstants
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
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(data[index]["icon"]))),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          function: () async {
                            pushToNextScreen(
                                context,
                                CategorySearchPage(
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
        if (data["id"] != null) {
          pushToNextScreen(context,
              DetailProductMarketPage(simpleData: data, id: data["id"]));
        }
      },
      child: Container(
        width: width,
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
                  width: isHaveClose ? width * 0.69 : width * 0.79,
                  child: buildTextContent(
                    "${data["title"] ?? data["search_params"]} ",
                    false,
                    fontSize: 17,
                    overflow: TextOverflow.ellipsis,
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
