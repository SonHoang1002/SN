import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/detail_product_api.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/products_api.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/review_product_apis.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/data/market_place_datas/dat_data.dart';
import 'package:social_network_app_mobile/helper/get_min_max_price.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/products_provider.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/screen/detail_product_market_page.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/rating_star_widget.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/review_item_widget.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/information_component_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_message_dialog_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_button.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/video_player.dart';
import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/divider_widget.dart';
import '../../../../widget/back_icon_appbar.dart';
import 'update_market_place.dart';
import 'notification_market_page.dart';

class ManageProductMarketPage extends ConsumerStatefulWidget {
  const ManageProductMarketPage({super.key});

  @override
  ConsumerState<ManageProductMarketPage> createState() =>
      _ManageProductMarketPageState();
}

class _ManageProductMarketPageState
    extends ConsumerState<ManageProductMarketPage> {
  late double width = 0;
  late double height = 0;
  List<dynamic>? _productList;
  Color? colorTheme;

  bool _isDetailLoading = false;
  bool _isMainLoading = true;

  /// detail
  dynamic _detailData;
  List<dynamic> _mediaDetailList = [];
  List<dynamic>? _prices;
  final List<bool> _sizeCheckList = [];
  final List<bool> _colorCheckList = [];
  dynamic _sizeValue;
  dynamic _colorValue;
  int _onMorePart = 0;
  List<dynamic>? _commentData;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final getProduct = ref.read(productsProvider.notifier).getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    colorTheme = ThemeMode.dark == true
        ? Theme.of(context).cardColor
        : const Color(0xfff1f2f5);
    final mainData = Future.wait([_initMainData()]);
    final response = SecureStorage().getKeyStorage("userId");
    print("meControllerProvider: ${response}");
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: greyColor[200],
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackIconAppbar(),
              const AppBarTitle(title: "Quản lý sản phẩm"),
              GestureDetector(
                onTap: () {
                  pushToNextScreen(context, NotificationMarketPage());
                },
                child: const Icon(
                  FontAwesomeIcons.bell,
                  size: 18,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  buildTextContent("Chỉ người bán mới thấy được cái này", true,
                      fontSize: 20, colorWord: red, isCenterLeft: false),
                  SingleChildScrollView(
                    child: Column(
                        children: List.generate(
                      _productList!.length,
                      (index) {
                        return _buildManageComponent(
                            _productList![index], index);
                      },
                    ).toList()),
                  )
                ],
              ),
            ),
            //
          ],
        ));
  }

  Widget _buildManageComponent(dynamic data, int index) {
    List<DataRow> dataRowList = [];
    for (int i = 0; i < data["product_variants"].length; i++) {
      dataRowList.add(
        DataRow(cells: [
          DataCell(Text(data["product_variants"][i]["option1"] == null ||
                  data["product_variants"][i]["option2"] == null
              ? "Không có mô tả"
              : "${data["product_variants"][i]["option1"]} ${data["product_variants"][i]["option2"] != null ? " - ${data["product_variants"][i]["option2"]}" : ""}")),
          DataCell(Text(data["product_variants"][i]["sku"])),
          DataCell(Text(data["product_variants"][i]["price"].toString())),
          DataCell(Text(data["brand"].toString())),
        ]),
      );
    }
    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 5),
      // decoration: BoxDecoration(
      //     color: colorTheme, borderRadius: BorderRadius.circular(7)),
      child: Column(
        children: [
          GeneralComponent(
            [
              buildTextContent(data["title"].toString(), true,
                  fontSize: 13, isCenterLeft: false)
            ],
            preffixFlexValue: 4,
            prefixWidget: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 10),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(7)),
                child: ImageCacheRender(
                  height: 100.0,
                  path: data["product_image_attachments"].isNotEmpty &&
                          data["product_image_attachments"] != null
                      ? data["product_image_attachments"][0]["attachment"]
                          ["url"]
                      : "https://snapi.emso.asia/system/media_attachments/files/109/583/844/336/412/733/original/3041cb0fcfcac917.jpeg",
                ),
              ),
            ),
            borderRadiusValue: 0,
            suffixFlexValue: 5,
            suffixWidget: InkWell(
              onTap: () {
                showBottomSheetCheckImportantSettings(
                    context, 300, "Chọn phương thức",
                    widget: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          ListTile(
                            leading: const Icon(FontAwesomeIcons.pen),
                            title: const Text("Cập nhật"),
                            onTap: () {
                              popToPreviousScreen(context);
                              pushToNextScreen(
                                  context, UpdateMarketPage(data["id"]));
                            },
                          ),
                          ListTile(
                            leading: const Icon(FontAwesomeIcons.copy),
                            title: const Text("Sao chép"),
                            onTap: () {
                              popToPreviousScreen(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Sao chép thành công")));
                            },
                          ),
                          ListTile(
                            leading: const Icon(FontAwesomeIcons.eye),
                            title: const Text("Xem trước"),
                            onTap: () {
                              popToPreviousScreen(context);
                              pushToNextScreen(context,
                                  DetailProductMarketPage(id: data["id"]));
                            },
                          ),
                          ListTile(
                            leading: const Icon(FontAwesomeIcons.trashCan),
                            title: const Text("Xóa"),
                            onTap: () async {
                              popToPreviousScreen(context);
                              buildMessageDialog(context,
                                  'Bạn muốn xóa sản phẩm " ${data["title"]} "',
                                  oKFunction: () {
                                setState(() {
                                  _productList!.removeAt(index);
                                  popToPreviousScreen(context);
                                });
                              });
                              final response = await ProductsApi()
                                  .deleteProductApi(data["id"]);
                            },
                          ),
                        ],
                      ),
                    ));
              },
              child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const Icon(FontAwesomeIcons.ellipsis)),
            ),
            padding: EdgeInsets.zero,
            changeBackground: transparent,
            function: () {
              setState(() {
                _isDetailLoading = true;
              });
              _detailData = null;
              showBottomSheetCheckImportantSettings(
                  context, height * 0.8, "Chi tiết sản phẩm",
                  widget: StatefulBuilder(builder: (context, setStateFull) {
                Future.delayed(Duration.zero, () async {
                  _detailData =
                      await DetailProductApi().getDetailProductApi(data["id"]);
                  _commentData =
                      await ReviewProductApi().getReviewProductApi(data["id"]);
                  _mediaDetailList = [];

                  if (_detailData["product_video"].isNotEmpty &&
                      _detailData["product_video"] != null) {
                    _mediaDetailList.add(_detailData["product_video"]["url"]);
                  }
                  if (_detailData["product_image_attachments"].isNotEmpty &&
                      _detailData["product_image_attachments"] != null) {
                    for (var element
                        in _detailData["product_image_attachments"]) {
                      _mediaDetailList.add(element["attachment"]["url"]);
                    }
                  }
                  _prices = getMinAndMaxPrice(_detailData?["product_variants"]);
                  setState(() {});
                  setStateFull(() {});
                  return 0;
                });
                return _detailData == null || _detailData.isEmpty
                    ? buildCircularProgressIndicator()
                    : Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                    children: List.generate(
                                        _mediaDetailList.length, (index) {
                                  final mediaPath = _mediaDetailList[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: mediaPath.endsWith(".mp4")
                                        ? SizedBox(
                                            height: 200,
                                            width: 300,
                                            child: VideoPlayerRender(
                                                path: mediaPath))
                                        : ImageCacheRender(
                                            path: mediaPath,
                                            height: 200.0,
                                            width: 200.0,
                                          ),
                                  );
                                })),
                              ),
                              // title
                              buildSpacer(height: 10),
                              buildTextContent(_detailData?["title"], true,
                                  fontSize: 17),
                              buildSpacer(height: 10),
                              // prices
                              Row(children: [
                                buildTextContent(
                                  "${_prices![0]}₫",
                                  true,
                                  fontSize: 18,
                                  colorWord: Colors.red,
                                ),
                                _prices![0] != _prices![1]
                                    ? buildTextContent(
                                        "${_prices![1]}₫",
                                        true,
                                        fontSize: 18,
                                        colorWord: Colors.red,
                                      )
                                    : const SizedBox()
                              ]),
                              //rate, selled and heart, share,
                              buildSpacer(height: 20),
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        buildRatingStarWidget(
                                            _detailData?["rating_count"]),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 5),
                                          child: buildTextContent(
                                              "${_detailData?["rating_count"].toString()}",
                                              false,
                                              fontSize: 18),
                                        ),
                                        Container(
                                          width: 2,
                                          color: Colors.red,
                                          height: 15,
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: buildTextContent(
                                              "đã bán ${_detailData?["sold"].round()}",
                                              false,
                                              fontSize: 15),
                                        ),
                                        Container(
                                          height: 20,
                                          width: 20,
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                        ),
                                      ],
                                    ),
                                    const SizedBox()
                                  ],
                                ),
                              ),

                              // color and size (neu co)
                              _detailData?["product_options"] != null &&
                                      _detailData?["product_options"].isNotEmpty
                                  ? Column(
                                      children: [
                                        //color
                                        _buildColorSizeWidget(
                                            "Màu sắc",
                                            _detailData?["product_options"][0]
                                                ["values"]),
                                        // size
                                        _detailData?["product_options"]
                                                    .length ==
                                                2
                                            ? _buildColorSizeWidget(
                                                "Kích cỡ",
                                                _detailData?["product_options"]
                                                    [1]["values"])
                                            : const SizedBox()
                                      ],
                                    )
                                  : const SizedBox(),

                              buildSpacer(height: 10),
                              Column(
                                children: [
                                  Container(
                                    color: Colors.blue,
                                    height: 2,
                                  ),
                                  // tabbar
                                  Row(
                                    children: List.generate(
                                        DetailProductMarketConstants
                                            .DETAIL_PRODUCT_MARKET_CONTENTS
                                            .length,
                                        (index) => GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _onMorePart = index;
                                              });
                                              setStateFull(() {});
                                            },
                                            child: Container(
                                              height: 50,
                                              width: width / 4.25,
                                              color: _onMorePart == index
                                                  ? Colors.blue
                                                  : transparent,
                                              child: buildTextContentButton(
                                                DetailProductMarketConstants
                                                        .DETAIL_PRODUCT_MARKET_CONTENTS[
                                                    index],
                                                false,
                                                isCenterLeft: false,
                                                fontSize: 13,
                                                function: () {
                                                  setState(() {
                                                    _onMorePart = index;
                                                  });
                                                  setStateFull(() {});
                                                },
                                              ),
                                            ))),
                                  ),
                                  buildDivider(height: 10, color: Colors.red),
                                  _onMorePart == 0
                                      ? Column(children: [
                                          buildSpacer(height: 10),
                                          buildTextContent(
                                              "Mô tả sản phẩm", true),
                                          buildSpacer(height: 10),
                                          buildTextContent(
                                              "${_detailData?["description"]}",
                                              false)
                                        ])
                                      : const SizedBox(),
                                  _onMorePart == 1
                                      ? Column(
                                          children: [
                                            Column(
                                              children: _commentData != null &&
                                                      _commentData!.isNotEmpty
                                                  ? List.generate(
                                                      _commentData!.length,
                                                      (index) {
                                                      final data =
                                                          _commentData![index];
                                                      return buildReviewItemWidget(
                                                          context,
                                                          _commentData![index]);
                                                    }).toList()
                                                  : [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10.0),
                                                        child: buildTextContent(
                                                            "Không có bài đánh giá nào",
                                                            true,
                                                            fontSize: 17,
                                                            isCenterLeft:
                                                                false),
                                                      )
                                                    ],
                                            ),
                                          ],
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
              }));
            },
          ),
          const CrossBar(height: 10)
        ],
      ),
    );
  }

  Future _initMainData() async {
    if (_productList == null || _productList!.isEmpty) {
      _productList = ref.watch(productsProvider).list.where((element) {
        return element["account_id"] == simpleDatData["id"];
      }).toList();
    }
    _isMainLoading = false;
    setState(() {});
    return 0;
  }

  Widget _buildColorSizeWidget(String title, List<dynamic> data) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        children: [
          SizedBox(
              width: 80, child: buildTextContent(title, true, fontSize: 18)),
          Expanded(
              child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(data.length, (index) {
              return InkWell(
                onTap: () {
                  if (title == "Màu sắc") {
                    if (_colorCheckList.isNotEmpty) {
                      for (int i = 0; i < _colorCheckList.length; i++) {
                        _colorCheckList[i] = false;
                      }
                      _colorCheckList[index] = true;
                      _colorValue = data[index];
                    }
                  } else {
                    if (_sizeCheckList.isNotEmpty) {
                      for (int i = 0; i < _sizeCheckList.length; i++) {
                        _sizeCheckList[i] = false;
                      }
                      _sizeCheckList[index] = true;
                      _sizeValue = data[index];
                    }
                  }

                  setState(() {});
                },
                child: Container(
                  width: 80,
                  padding: const EdgeInsets.all(10),

                  decoration: BoxDecoration(
                      color: title == "Màu sắc"
                          ? _colorCheckList.isNotEmpty && _colorCheckList[index]
                              ? blueColor
                              : white
                          : _sizeCheckList.isNotEmpty && _sizeCheckList[index]
                              ? blueColor
                              : white,
                      border: Border.all(color: greyColor, width: 0.6),
                      borderRadius: BorderRadius.circular(5)),
                  // margin: EdgeInsets.only(right: 10),
                  child: buildTextContent(data[index], false, fontSize: 14),
                ),
              );
            }),
          ))
        ],
      ),
    );
  }

  Widget buildBetweenContent(String title,
      {Widget? suffixWidget, IconData? iconData}) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTextContent(
            title,
            false,
            fontSize: 15,
            colorWord: greyColor,
          ),
          Row(
            children: [
              suffixWidget ?? const SizedBox(),
              buildSpacer(width: 5),
              iconData != null
                  ? Icon(
                      iconData,
                      color: greyColor,
                      size: 14,
                    )
                  : const SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}
