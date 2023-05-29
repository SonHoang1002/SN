import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/data/market_datas/dat_data.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:market_place/screens/MarketPlace/widgets/review_item_widget.dart';
import 'package:market_place/apis/market_place_apis/review_product_apis.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/image_cache.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';

class SeeReviewShopMarketPage extends ConsumerStatefulWidget {
  final List<dynamic>? reviewData;
  final dynamic reviewId;
  const SeeReviewShopMarketPage(
      {super.key, required this.reviewId, required this.reviewData});
  @override
  ConsumerState<SeeReviewShopMarketPage> createState() =>
      _SeeReviewShopMarketPageComsumerState();
}

class _SeeReviewShopMarketPageComsumerState
    extends ConsumerState<SeeReviewShopMarketPage> {
  late double width = 0;
  late double height = 0;
  int mediaIndex = 0;
  bool _isMainLoading = true;
  bool _isDetailLoading = false;
  List<dynamic>? mediaList;
  List<dynamic>? reviewList = [];
  dynamic _imgChildLink;
  @override
  void initState() {
    if (!mounted) {
      return;
    }
    super.initState();
    Future.wait([_initData()]);
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
    // Future<int> a = _initData();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackIconAppbar(),
              AppBarTitle(text: "Đánh giá Shop của bạn"),
              Icon(
                FontAwesomeIcons.bell,
                size: 18,
                color: Colors.black,
              )
            ],
          ),
        ),
        body: !_isMainLoading
            ? _buildReviewBody()
            : buildCircularProgressIndicator());
  }

  Future<int> _initData() async {
    if (reviewList!.isEmpty) {
      List<dynamic> newList =
          await Future.wait(widget.reviewData!.map((element) async {
        List<dynamic> response = await ReviewProductApi()
            .getReviewProductApi(element["product_variant"]["product_id"]);
        return response;
      }).toList());
      List<dynamic> filterReviewList = [];
      for (var reviewItem in newList) {
        newList[newList.indexOf(reviewItem)] = reviewItem
            .where((child) => child["comment"]["id"] == simpleDatData["id"])
            .toList();
      }
      reviewList = newList;
    }
    // load xong
    _isMainLoading = false;
    setState(() {});
    return 0;
  }

  Widget _buildReviewBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: List.generate(widget.reviewData!.length, (index) {
                final data = widget.reviewData![index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          ImageCacheRender(
                            path: widget.reviewData![index]["product_variant"]
                                        ["image"] !=
                                    null
                                ? widget.reviewData![index]["product_variant"]
                                    ["image"]["url"]
                                : "https://kynguyenlamdep.com/wp-content/uploads/2022/01/hinh-anh-meo-con-sieu-cute-700x467.jpg",
                            width: 100.0,
                            height: 100.0,
                          ),
                          buildSpacer(width: 15),
                          Expanded(
                            child: Column(
                              children: [
                                buildTextContent(
                                    data["product_variant"]["title"], false),
                                buildSpacer(width: 15),
                                buildTextContent(
                                    data["product_variant"]["option1"] !=
                                                null ||
                                            data["product_variant"]
                                                    ["option2"] !=
                                                null
                                        ? "Phân loại hàng: ${data["product_variant"]["option1"] ?? ""} ${data["product_variant"]["option2"] ?? ""}"
                                        : "",
                                    false,
                                    isItalic: true,
                                    fontSize: 14,
                                    colorWord: greyColor),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    buildSpacer(height: 20),
                    reviewList!.isEmpty
                        ? buildCircularProgressIndicator()
                        : reviewList?[index].isNotEmpty
                            ? Column(
                                children: List.generate(
                                    reviewList?[index].length, (childIndex) {
                                  return buildReviewItemWidget(
                                      context, reviewList?[index][childIndex],
                                      updateFunction: () {
                                    showCustomBottomSheet(context, 200,
                                        widget: SingleChildScrollView(
                                          child: ListBody(
                                            children: [
                                              ListTile(
                                                leading: const Icon(
                                                    FontAwesomeIcons.pen),
                                                title: const Text("Cập nhật"),
                                                onTap: () {
                                                  popToPreviousScreen(context);
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                    FontAwesomeIcons.trashCan),
                                                title: const Text("Xóa"),
                                                onTap: () async {
                                                  setState(() {
                                                    reviewList?[index]
                                                        .removeAt(childIndex);
                                                  });
                                                  popToPreviousScreen(context);
                                                  final response =
                                                      await ReviewProductApi()
                                                          .deleteReviewProductApi(
                                                              widget.reviewId,
                                                              reviewList?[index]
                                                                      [
                                                                      childIndex]
                                                                  ["id"]);
                                                },
                                              ),
                                            ],
                                          ),
                                        ));
                                  });
                                }),
                              )
                            : buildTextContent("Không có đánh giá !!", false,
                                isCenterLeft: false, fontSize: 18)
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
