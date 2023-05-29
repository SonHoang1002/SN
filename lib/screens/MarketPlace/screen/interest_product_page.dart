import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/apis/market_place_apis/follwer_product_api.dart';
import 'package:market_place/constant/get_min_max_price.dart';
import 'package:market_place/constant/marketPlace_constants.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/providers/market_place_providers/interest_product_provider.dart';
import 'package:market_place/screens/MarketPlace/screen/detail_product_page.dart';
import 'package:market_place/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:market_place/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/share_and_search.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/image_cache.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';

import '../../../../theme/colors.dart';

class InterestProductMarketPage extends ConsumerStatefulWidget {
  const InterestProductMarketPage({super.key});

  @override
  ConsumerState<InterestProductMarketPage> createState() =>
      _InterestProductMarketPageState();
}

class _InterestProductMarketPageState
    extends ConsumerState<InterestProductMarketPage> {
  late double width = 0;
  late double height = 0;
  final bgColor = greyColor[300];
  List<dynamic>? _interestProductList;
  List<bool>? _concernList;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () {
    //   if (ref.watch(interestProductsProvider).listInterest.isEmpty) {
    //     final interestProductList =
    //         ref.read(interestProductsProvider.notifier).getFollwerProduct();
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _interestProductList = [];
    _concernList = [];
  }

  Future<int> _initData() async {
    _interestProductList ??= await FollwerProductsApi().getFollwerProductsApi();
    if (_interestProductList!.isNotEmpty) {
      _concernList ??= _interestProductList!.map(
        (e) {
          return true;
        },
      ).toList();
    }
    setState(() {
      _isLoading = false;
    });
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    _initData();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackIconAppbar(),
              AppBarTitle(text: "Quan tâm"),
              Icon(
                FontAwesomeIcons.bell,
                size: 18,
              )
            ],
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: !_isLoading
                ? _interestProductList!.isNotEmpty
                    ? SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: List.generate(_interestProductList!.length,
                              (index) {
                            return _buildInterestComponent(
                                _interestProductList![index], index);
                          }),
                        ),
                      )
                    : buildTextContent("Bạn chưa quan tâm sản phẩm nào", true,
                        isCenterLeft: false, fontSize: 22)
                : buildCircularProgressIndicator()));
  }

  Widget _buildInterestComponent(Map<String, dynamic> data, int index) {
    List<dynamic> prices = getMinAndMaxPrice(data["product_variants"]);
    return InkWell(
      onTap: () {
        pushToNextScreen(context, DetailProductMarketPage(id: data["id"]));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            border: Border.all(width: 0.4, color: greyColor),
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(7)),
        child: Column(
          children: [
            GeneralComponent(
              [
                Text(
                  data["title"],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                buildSpacer(height: 7),
                buildTextContent("Nguyễn Đình Đạt", false, fontSize: 15),
                buildSpacer(height: 7),
                Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.orange[300],
                        borderRadius: BorderRadius.circular(20)),
                    child: prices[0] == prices[1]
                        ? Text("₫${prices[0]}")
                        : Text("₫${prices[0]} - ₫${prices[1]}"))
              ],
              preffixFlexValue: 5,
              prefixWidget: Container(
                margin: const EdgeInsets.only(right: 10),
                child: ImageCacheRender(
                  height: 100.0,
                  width: 150.0,
                  path: data["product_image_attachments"] != null &&
                          data["product_image_attachments"].isNotEmpty
                      ? data["product_image_attachments"][0]["attachment"]
                          ["url"]
                      : "https://snapi.emso.asia/system/media_attachments/files/109/583/844/336/412/733/original/3041cb0fcfcac917.jpeg",
                ),
              ),
              changeBackground: transparent,
              function: () {
                pushToNextScreen(
                    context, DetailProductMarketPage(id: data["id"]));
              },
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                  ),
                  child: buildMarketButton(
                      bgColor:
                          _concernList![index] ? secondaryColor : greyColor,
                      contents: [
                        const Icon(FontAwesomeIcons.star, size: 13),
                        buildSpacer(width: 5),
                        buildTextContent("Quan tâm", false, fontSize: 13),
                      ],
                      width: width * 0.6,
                      function: () async {
                        _concernList![index] = !_concernList![index];
                        setState(() {});
                        if (_concernList![index]) {
                          await FollwerProductsApi()
                              .postFollwerProductsApi(data["id"]);
                        } else {
                          await FollwerProductsApi()
                              .deleteFollwerProductsApi(data["id"]);
                        }
                      }),
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: buildMarketButton(
                      contents: [
                        const Icon(
                          FontAwesomeIcons.ellipsisVertical,
                          size: 13,
                        )
                      ],
                      bgColor: greyColor,
                      width: 30,
                      function: () {
                        showCustomBottomSheet(context, 210,
                            title: "Quan tâm",
                            bgColor: bgColor,
                            widget: ListView.builder(
                                shrinkWrap: true,
                                itemCount: InterestProductMarketConstants
                                    .INTEREST_PRODUCT_BOTTOM_SELECTIONS["data"]
                                    .length,
                                itemBuilder: (context, index) {
                                  final data = InterestProductMarketConstants
                                          .INTEREST_PRODUCT_BOTTOM_SELECTIONS[
                                      "data"];
                                  return Column(
                                    children: [
                                      GeneralComponent(
                                        [
                                          buildTextContent(
                                              data[index]["title"], true,
                                              fontSize: 16)
                                        ],
                                        prefixWidget: Container(
                                          height: 25,
                                          width: 25,
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          child: data[index]["icon"],
                                        ),
                                        suffixFlexValue: 1,
                                        suffixWidget:
                                            data[index]["title"] == "Chia sẻ"
                                                ? const SizedBox(
                                                    height: 25,
                                                    child: Icon(FontAwesomeIcons
                                                        .chevronRight),
                                                  )
                                                : null,
                                        changeBackground: transparent,
                                        padding: const EdgeInsets.all(5),
                                        function: () {
                                          data[index]["title"] == "Chia sẻ"
                                              ? showCustomBottomSheet(
                                                  context, 300,
                                                  title: "Chia sẻ sản phẩm",
                                                  iconData: FontAwesomeIcons
                                                      .chevronLeft,
                                                  bgColor: bgColor,
                                                  isBarrierTransparent: true,
                                                  widget: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          InterestProductMarketConstants
                                                              .INTEREST_PRODUCT_BOTTOM_SHARE_SELECTIONS[
                                                                  "data"]
                                                              .length,
                                                      itemBuilder: (context,
                                                          indexShare) {
                                                        final data =
                                                            InterestProductMarketConstants
                                                                    .INTEREST_PRODUCT_BOTTOM_SHARE_SELECTIONS[
                                                                "data"];
                                                        return Column(
                                                          children: [
                                                            GeneralComponent(
                                                              [
                                                                buildTextContent(
                                                                    data[indexShare]
                                                                        [
                                                                        "title"],
                                                                    true,
                                                                    fontSize:
                                                                        16)
                                                              ],
                                                              prefixWidget:
                                                                  Container(
                                                                height: 25,
                                                                width: 25,
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            10),
                                                                child: data[
                                                                        indexShare]
                                                                    ["icon"],
                                                              ),
                                                              suffixFlexValue:
                                                                  1,
                                                              suffixWidget: data[
                                                                              indexShare]
                                                                          [
                                                                          "title"] ==
                                                                      "Chia sẻ"
                                                                  ? const SizedBox(
                                                                      height:
                                                                          25,
                                                                      child: Icon(
                                                                          FontAwesomeIcons
                                                                              .chevronRight),
                                                                    )
                                                                  : null,
                                                              changeBackground:
                                                                  transparent,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              function: () {
                                                                String title =
                                                                    "";
                                                                Widget body =
                                                                    const SizedBox();
                                                                switch (data[
                                                                        indexShare]
                                                                    ["title"]) {
                                                                  case 'Chia sẻ ngay':
                                                                    break;
                                                                  case 'Chia sẻ lên bảng tin':
                                                                    break;
                                                                  case 'Chia sẻ lên nhóm':
                                                                    title =
                                                                        "Chia sẻ lên nhóm";
                                                                    body = ShareAndSearchWidget(
                                                                        data: InterestProductMarketConstants
                                                                            .INTEREST_PRODUCT_BOTTOM_GROUP_SHARE_SELECTIONS,
                                                                        placeholder:
                                                                            InterestProductMarketConstants.INTEREST_PRODUCT_SEARCH_GROUP_PLACEHOLDER);
                                                                    break;
                                                                  case 'Chia sẻ lên trang cá nhân':
                                                                    title =
                                                                        "Chia sẻ lên trang cá nhân của bạn bè";
                                                                    body = ShareAndSearchWidget(
                                                                        data: InterestProductMarketConstants
                                                                            .INTEREST_PRODUCT_BOTTOM_PERSONAL_PAGE_SELECTIONS,
                                                                        placeholder:
                                                                            InterestProductMarketConstants.INTEREST_PRODUCT_SEARCH_FRIEND_PLACEHOLDER);

                                                                    break;
                                                                  case 'Sao chép liên kết':
                                                                    break;
                                                                  default:
                                                                    break;
                                                                }
                                                                showCustomBottomSheet(
                                                                    context,
                                                                    height *
                                                                        0.7,
                                                                    title:
                                                                        title,
                                                                    bgColor:
                                                                        greyColor[
                                                                            400],
                                                                    isBarrierTransparent:
                                                                        true,
                                                                    widget:
                                                                        body);
                                                              },
                                                            ),
                                                            buildDivider(
                                                                color:
                                                                    greyColor)
                                                          ],
                                                        );
                                                      }))
                                              : null;
                                        },
                                      ),
                                      buildDivider(color: greyColor)
                                    ],
                                  );
                                }));
                      }),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
