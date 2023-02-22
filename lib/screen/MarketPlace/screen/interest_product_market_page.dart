import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/interest_product_provider.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/products_provider.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/detail_product_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/button_for_market_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/share_and_search_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/divider_widget.dart';
import '../../../../widget/back_icon_appbar.dart';
import '../../../helper/push_to_new_screen.dart';

class InterestProductMarketPage extends ConsumerStatefulWidget {
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
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final interestProductList =
          ref.read(suggestProductsProvider.notifier).getSuggestProducts();
      // final interestList =
      //     ref.read(interestProductsProvider.notifier).addInterestProducts({});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    _initData();
    _initConcernList();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackIconAppbar(),
              AppBarTitle(title: "Quan tâm"),
              Icon(
                FontAwesomeIcons.bell,
                size: 18,
                // color: Colors.black,
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _interestProductList!.isEmpty
                    ? buildTextContent("Bạn chưa quan tâm sản phẩm nào", true,
                        isCenterLeft: false, fontSize: 22)
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: List.generate(_interestProductList!.length,
                              (index) {
                            return _buildInterestComponent(
                                _interestProductList![index], index);
                          }),
                        ),
                      ),
              ),
            ),
            //
          ],
        ));
  }

  _initData() {
    _interestProductList = ref.watch(interestProductsProvider).listInterest;
    setState(() {});
  }

  _initConcernList() {
    if (_interestProductList!.isNotEmpty) {
      if (_concernList == null) {
        _concernList = _interestProductList!.map(
          (e) {
            return false;
          },
        ).toList();
        setState(() {});
      }
    } else {
      return;
    }
  }

  _buildInterestComponent(Map<String, dynamic> data, int index) {
    return InkWell(
      onTap: () {
        pushToNextScreen(context, DetailProductMarketPage(id: data["id"]));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            border: Border.all(width: 0.4, color: greyColor),
            color: greyColor[100],
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
                buildTextContent("Chi Phat - nguoi quan tam", false,
                    fontSize: 15),
                buildSpacer(height: 7),
                Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.orange[300],
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                        "₫ ${_getMinximumPriceOfProduct(data["product_variants"]).toString()}"))
              ],
              preffixFlexValue: 5,
              prefixWidget: Container(
                // width: 150,
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
                  child: buildButtonForMarketWidget(
                      bgColor:
                          _concernList![index] ? blueColor : secondaryColor,
                      title: "Quan tâm",
                      iconData: FontAwesomeIcons.star,
                      width: width * 0.6,
                      function: () {
                        _concernList![index] = !_concernList![index];
                        setState(() {});
                      }),
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: buildButtonForMarketWidget(
                      iconData: FontAwesomeIcons.ellipsisVertical,
                      width: 30,
                      function: () {
                        showBottomSheetCheckImportantSettings(
                            context, 210, "Quan tâm",
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
                                                ? Container(
                                                    height: 25,
                                                    // width: 25,
                                                    child: const Icon(
                                                        FontAwesomeIcons
                                                            .chevronRight),
                                                  )
                                                : null,
                                        changeBackground: transparent,
                                        padding: const EdgeInsets.all(5),
                                        function: () {
                                          data[index]["title"] == "Chia sẻ"
                                              ? showBottomSheetCheckImportantSettings(
                                                  context,
                                                  300,
                                                  "Chia sẻ sản phẩm",
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
                                                                  ? Container(
                                                                      height:
                                                                          25,
                                                                      // width: 25,
                                                                      child: const Icon(
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
                                                                showBottomSheetCheckImportantSettings(
                                                                    context,
                                                                    height *
                                                                        0.7,
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

  _getMinximumPriceOfProduct(List<dynamic> product_variants) {
    double min = product_variants[0]["price"];
    product_variants.forEach((element) {
      if (element["price"] < min) {
        min = element["price"];
      }
    });
    return min;
  }
}
