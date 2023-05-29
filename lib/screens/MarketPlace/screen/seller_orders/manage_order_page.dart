import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/constant/marketPlace_constants.dart';
import 'package:market_place/helpers/format_currency.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/providers/market_place_providers/page_list_provider.dart';
import 'package:market_place/screens/MarketPlace/screen/review_product_page.dart';
import 'package:market_place/screens/MarketPlace/screen/see_review_market.dart';
import 'package:market_place/screens/MarketPlace/screen/seller_orders/prepare_product_market_page.dart';
import 'package:market_place/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:market_place/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:market_place/apis/market_place_apis/order_product_apis.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_message_dialog_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_button.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/cross_bar.dart';
import 'package:market_place/widgets/image_cache.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';
import '../../../../theme/colors.dart';

class ManageOrderMarketPage extends ConsumerStatefulWidget {
  const ManageOrderMarketPage({super.key});

  @override
  ConsumerState<ManageOrderMarketPage> createState() =>
      _OrderProductMarketPageState();
}

class _OrderProductMarketPageState
    extends ConsumerState<ManageOrderMarketPage> {
  late double width = 0;
  late double height = 0;
  List<dynamic>? _orderData;
  List<dynamic>? _filteredOrderData;
  Color? colorTheme;
  bool _isLoading = true;
  bool check = false;
  List<dynamic> _pageList = [];
  dynamic _selectedPage;
  int indexx = 0;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final a = await ref.read(pageListProvider.notifier).getPageList();
    });
    _filteredOrderData =
        OrderProductMarketConstant.ORDER_PRODUCT_MARKET_TAB_LIST.map(
      (e) {
        return {"key": e["key"], "title": e["title"], "data": []};
      },
    ).toList();
  }

  @override
  void dispose() {
    super.dispose();
    _orderData = [];
    _filteredOrderData = [];
  }

  Future<int> _initData() async {
    if (_pageList.isEmpty) {
      _pageList = await ref.watch(pageListProvider).listPage;
    }
    if (_selectedPage == null) {
      if (_pageList.isNotEmpty) {
        _selectedPage = await _pageList[0];
      }
    }
    if (_selectedPage != null && _selectedPage!.isNotEmpty) {
      if (_orderData == null) {
        _orderData = await OrderApis().getSellerOrderApi(_selectedPage["id"]);
        // loc cac trang thai cua don hang
        _filteredOrderData =
            OrderProductMarketConstant.ORDER_PRODUCT_MARKET_TAB_LIST.map(
          (e) {
            return {"key": e["key"], "title": e["title"], "data": []};
          },
        ).toList();
        _orderData?.forEach((_orderDataElement) {
          dynamic openOrderDataElement = _orderDataElement;
          openOrderDataElement["open"] =
              _orderDataElement["order_items"].length > 1 ? false : null;
          for (dynamic _filteredOrderDataElement in _filteredOrderData!) {
            if (_filteredOrderDataElement["key"] ==
                _orderDataElement["status"]) {
              _filteredOrderData![_filteredOrderData!
                      .indexOf(_filteredOrderDataElement)]['data']
                  .add(openOrderDataElement);
            }
          }
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
    return 0;
  }

  Future _initPageList() async {
    if (_pageList.isEmpty) {
      _pageList = await ref.watch(pageListProvider).listPage;
    }
    if (_selectedPage == null || _selectedPage!.isEmpty) {
      if (_pageList.isEmpty) {
        _selectedPage = [];
      } else {
        _selectedPage = _pageList[0];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    colorTheme = ThemeMode.dark == true
        ? Theme.of(context).cardColor
        : const Color(0xfff1f2f5);
    Color colorWord = ThemeMode.dark == true
        ? white
        : true == ThemeMode.light
            ? blackColor
            : greyColor;
    Future.wait([_initData()]);
    return DefaultTabController(
        length: OrderProductMarketConstant.ORDER_PRODUCT_MARKET_TAB_LIST.length,
        initialIndex: 0,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackIconAppbar(),
                  const AppBarTitle(text: "Danh sách đơn hàng"),
                  GestureDetector(
                    onTap: () {
                      // pushToNextScreen(context, PrepareProductMarketPage());
                    },
                    child:
                        Icon(FontAwesomeIcons.bell, size: 18, color: colorWord),
                  )
                ],
              ),
              bottom: TabBar(
                isScrollable: true,
                tabs: OrderProductMarketConstant.ORDER_PRODUCT_MARKET_TAB_LIST
                    .map((e) {
                  return Tab(
                      icon: e["icon"] != null
                          ? Image.asset(
                              e["icon"],
                              height: 20,
                            )
                          : Icon(FontAwesomeIcons.searchengin,
                              color: colorWord),
                      child: SizedBox(
                          width: 65,
                          child: buildTextContent(
                              e["title"] +
                                  " (" +
                                  _filteredOrderData?[OrderProductMarketConstant
                                          .ORDER_PRODUCT_MARKET_TAB_LIST
                                          .indexOf(e)]["data"]
                                      .length
                                      .toString() +
                                  ")",
                              false,
                              isCenterLeft: false,
                              colorWord: colorWord,
                              fontSize: 11)));
                }).toList(),
              ),
            ),
            body: Stack(
              children: [
                !_isLoading && _orderData != null
                    ? _orderData!.isNotEmpty
                        ? TabBarView(
                            children: [
                              _buildPendingBody(),
                              _buildDeliveredBody(),
                              _buildShippingBody(),
                              _buildFinishBody(),
                              _buildCancelBody(),
                              _buildReturnBody(),
                            ],
                          )
                        : buildTextContent("Bạn chưa có đơn hàng nào", false,
                            fontSize: 18, isCenterLeft: false)
                    : buildCircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: filterPage(context, "Page", "Chọn Page"),
                ),
              ],
            )));
  }

  Widget filterPage(
    BuildContext context,
    String title,
    String titleForBottomSheet,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Column(
        children: [
          GeneralComponent(
            [
              buildTextContent(title, false,
                  colorWord: greyColor, fontSize: 14),
              const SizedBox(height: 5),
              _selectedPage != null
                  ? buildTextContent(_selectedPage["title"], true, fontSize: 16)
                  : buildTextContent("-", true, fontSize: 16)
            ],
            prefixWidget: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                  height: 35,
                  width: 35,
                  child: _selectedPage != null
                      ? ImageCacheRender(
                          path: _selectedPage["avatar_media"]["url"])
                      : Container(
                          color: greyColor,
                        )),
            ),
            suffixWidget: const SizedBox(
              height: 40,
              width: 40,
              child: Icon(
                FontAwesomeIcons.caretDown,
                size: 18,
              ),
            ),
            changeBackground: transparent,
            padding: const EdgeInsets.all(5),
            isHaveBorder: true,
            function: () {
              showCustomBottomSheet(context, 500,
                  title: titleForBottomSheet,
                  widget: SizedBox(
                    height: 400,
                    child: FutureBuilder<void>(
                        future: _initPageList(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return _pageList.isNotEmpty
                                ? ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: _pageList.length,
                                    itemBuilder: (context, index) {
                                      final data = _pageList[index];
                                      if (data.length == 0) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            buildTextContent(
                                                "Bạn chưa sở hữu trang nào, vui lòng tạo page trước",
                                                false),
                                          ],
                                        );
                                      }
                                      return Column(
                                        children: [
                                          GeneralComponent(
                                            [
                                              buildTextContent(
                                                  data["title"], false)
                                            ],
                                            changeBackground: transparent,
                                            prefixWidget: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              child: Container(
                                                height: 35,
                                                width: 35,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                ),
                                                child: data["avatar_media"] !=
                                                        null
                                                    ? ImageCacheRender(
                                                        path:
                                                            data["avatar_media"]
                                                                ["url"])
                                                    : null,
                                              ),
                                            ),
                                            function: () {
                                              popToPreviousScreen(context);
                                              setState(() {
                                                _selectedPage = data;
                                                _orderData = null;
                                                _isLoading = true;
                                              });
                                            },
                                          ),
                                          buildDivider(color: greyColor)
                                        ],
                                      );
                                    })
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildTextContent(
                                          "Bạn chưa sở hữu page nào", false,
                                          isCenterLeft: false, fontSize: 18),
                                      buildSpacer(height: 10),
                                      buildMarketButton(contents: [
                                        buildTextContent("Tạo Page", false,
                                            fontSize: 13)
                                      ], width: width * 0.4)
                                    ],
                                  );
                          }
                          return buildCircularProgressIndicator();
                        }),
                  ));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPendingBody() {
    return _buildBaseBody(_buildOrderComponent(0));
  }

  Widget _buildDeliveredBody() {
    return _buildBaseBody(_buildOrderComponent(1));
  }

  Widget _buildShippingBody() {
    return _buildBaseBody(_buildOrderComponent(2));
  }

  Widget _buildFinishBody() {
    return _buildBaseBody(_buildOrderComponent(3));
  }

  Widget _buildCancelBody() {
    return _buildBaseBody(_buildOrderComponent(4));
  }

  Widget _buildReturnBody() {
    return _buildBaseBody(_buildOrderComponent(5));
  }

  void _showDetailDialog(dynamic data) {
    // List<DataRow> rowList = <DataRow>[];
    // if (data["delivery_address"] != null &&
    //     data["delivery_address"].isNotEmpty) {
    //   for (int i = 0; i < data["order_items"].length; i++) {
    //     rowList.add(DataRow(cells: [
    //       DataCell(Text((i + 1).toString())),
    //       DataCell(Text(data["order_items"][i]["product_variant"]["title"])),
    //       DataCell(Text(data["order_items"][i]["product_variant"]["sku"])),
    //       DataCell(Text(
    //           data["order_items"][i]["product_variant"]["price"].toString())),
    //       DataCell(Text(data["order_items"][i]["quantity"].toString())),
    //       DataCell(Text((data["order_items"][i]["product_variant"]["price"] *
    //               data["order_items"][i]["quantity"])
    //           .toString())),
    //     ]));
    //   }
    // }
  }

  Widget _getStatus(dynamic key) {
    Color wordColor = blackColor;
    String title = "";
    switch (key) {
      case "pending":
        wordColor = Colors.orange;
        title = "Chờ xử lý";
        break;
      case "delivered":
        wordColor = Colors.grey;
        title = "Vận chuyển";
        break;
      case "shipping":
        wordColor = Colors.green;
        title = "Đang giao";
        break;
      case "finish":
        wordColor = Colors.blue;
        title = "Hoàn thành";
        break;
      case "cancelled":
        wordColor = Colors.red;
        title = "Đã hủy";
        break;
      case "return":
        wordColor = Colors.purple;
        title = "Trả hàng/ Hoàn tiền";
        break;
      default:
        break;
    }
    return buildTextContent(title, true, fontSize: 16, colorWord: wordColor);
  }
// general

  Widget _buildOrderComponent(int orderIndex) {
    return _filteredOrderData![orderIndex]["data"].length != 0
        ? Column(
            children: List.generate(
                _filteredOrderData![orderIndex]["data"].length, (index) {
            final data = _filteredOrderData![orderIndex]["data"][index];
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    _showDetailDialog(data);
                  },
                  child: Column(children: [
                    orderIndex != 3
                        ? index != 0
                            ? buildSpacer(height: 5)
                            : const SizedBox()
                        : const SizedBox(),
                    const CrossBar(
                      height: 5,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5, right: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          //status
                          _getStatus(data["status"])
                        ],
                      ),
                    ),
                    buildDivider(color: red),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.shop,
                                size: 20,
                              ),
                              buildSpacer(width: 10),
                              SizedBox(
                                width: width * 0.7,
                                child: buildTextContent(
                                  data["page"]["title"],
                                  false,
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox()
                        ],
                      ),
                    ),
                    Column(
                      children: List.generate(
                        data["open"] == true ? data["order_items"].length : 1,
                        (index) {
                          return _buildOrderItem(data["order_items"][index]);
                        },
                      ),
                    ),
                    data["open"] != null && data["open"] == false
                        ? Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: buildTextContentButton(
                                "Xem thêm sản phẩm", false,
                                fontSize: 14,
                                isCenterLeft: false,
                                colorWord: greyColor, function: () {
                              final newOrderData =
                                  _filteredOrderData![orderIndex];
                              newOrderData["data"][index]["open"] = true;
                              setState(() {});
                            }),
                          )
                        : const SizedBox(),
                    _buildBetweenContent(
                        "${data["order_items"].length} sản phẩm",
                        "Tổng thanh toán: ₫${formatCurrency(data["order_total"]).toString()}",
                        titleSize: 14,
                        contentSize: 16,
                        haveIcon: false,
                        contentBold: false),
                    buildSpacer(height: 5),
                    buildDivider(color: red),
                    _buildButtons(data),
                    orderIndex == 3
                        ? Column(
                            children: [
                              buildSpacer(height: 10),
                              buildDivider(color: red)
                            ],
                          )
                        : const SizedBox(),
                    orderIndex == 3
                        ? _buildBetweenContent("Mã đơn hàng", "#76346364863",
                            titleSize: 14,
                            contentSize: 16,
                            haveIcon: false,
                            contentBold: true,
                            margin: const EdgeInsets.only(
                                top: 5, left: 10, right: 10, bottom: 0))
                        : const SizedBox(),
                  ]),
                ),
              ],
            );
          }))
        : Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: buildTextContent("Bạn không có đơn hàng nào !!", false,
                isCenterLeft: false),
          );
  }

  Widget _buildOrderItem(dynamic childfilterData) {
    return Column(children: [
      // cac san pham
      buildDivider(color: greyColor[700], right: 40, left: 40),
      Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  ImageCacheRender(
                    height: 100.0,
                    width: 100.0,
                    path: childfilterData["product_variant"] != null &&
                            childfilterData["product_variant"].isNotEmpty
                        ? childfilterData["product_variant"]["image"] != null
                            ? childfilterData["product_variant"]["image"]["url"]
                            : "https://kynguyenlamdep.com/wp-content/uploads/2022/01/hinh-anh-meo-con-sieu-cute-700x467.jpg"
                        : "https://kynguyenlamdep.com/wp-content/uploads/2022/01/hinh-anh-meo-con-sieu-cute-700x467.jpg",
                  ),
                  buildSpacer(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTextContent(
                            childfilterData["product_variant"]["title"], false,
                            fontSize: 15,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        buildSpacer(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTextContent(
                              childfilterData["product_variant"]["option1"] ==
                                          null &&
                                      childfilterData["product_variant"]
                                              ["option2"] ==
                                          null
                                  ? "Không phân loại"
                                  : childfilterData["product_variant"]
                                          ["option1"] ??
                                      ("" +
                                                  childfilterData[
                                                          "product_variant"]
                                                      ["option2"] !=
                                              null
                                          ? childfilterData["product_variant"]
                                              ["option2"]
                                          : ""),
                              false,
                              colorWord: greyColor[700],
                              fontSize: 13,
                            ),
                            buildTextContent(
                              "x${childfilterData["quantity"].toString()}",
                              false,
                              colorWord: greyColor[700],
                              fontSize: 13,
                            ),
                          ],
                        ),
                        buildSpacer(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            buildTextContent(
                              "₫${formatCurrency(childfilterData["product_variant"]["price"])}",
                              false,
                              colorWord: greyColor[700],
                              fontSize: 13,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      )
    ]);
  }

  Widget _buildButtons(dynamic data) {
    List<Widget> buttonList = [];

    switch (data["status"]) {
      case "pending":
        buttonList.add(_cancelOrderButton(data));
        buttonList.add(_prepareButton(data));
        break;
      case "delivered":
        buttonList.add(_cancelOrderButton(data));
        // buttonList.add(_cancelOrderButton(data));
        // buttonList.add(_contactWithSellerButton(data));
        break;
      case "shipping":
        buttonList.add(_gotOrder(data));

        break;
      case "finish":
        buttonList.add(_reviewButton(data));
        // buttonList.add(_reBuyButton(data));
        buttonList.add(_seeReviewButton(data));
        break;
      case "cancelled":
        buttonList.add(_contactWithSellerButton(data));
        buttonList.add(_reBuyButton(data));
        // buttonList.add(_detailCanceledButton(data));
        break;
      case "return":
        break;
      default:
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: buttonList.length > 1
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: buttonList,
      ),
    );
  }

  Widget _prepareButton(dynamic data) {
    return buildMarketButton(
        width: width * 0.4,
        contents: [buildTextContent("Chuẩn bị hàng", false, fontSize: 13)],
        function: () {
          pushToNextScreen(context, PrepareProductMarketPage());
        });
  }

  Widget _contactWithSellerButton(dynamic data) {
    return buildMarketButton(
        width: width * 0.4,
        contents: [buildTextContent("Liên hệ", false, fontSize: 13)],
        bgColor: blueColor,
        function: () {
          // _showDetailDialog(data);
        });
  }

  Widget _cancelOrderButton(dynamic data) {
    return buildMarketButton(
        width: width * 0.4,
        contents: [buildTextContent("Hủy đơn hàng", false, fontSize: 13)],
        bgColor: red,
        function: () async {
          buildMessageDialog(context,
              'Bạn muốn xóa đơn hàng từ shop " ${data["page"]["title"]} "',
              oKFunction: () async {
            setState(() {
              _isLoading = true;
            });
            data["status"] = "cancelled";
            List<dynamic> primaryOrderList = _orderData!;
            for (int i = 0; i < primaryOrderList.length; i++) {
              if (primaryOrderList[i]["id"] == data["id"]) {
                primaryOrderList[i] = data;
              }
            }
            setState(() {
              _isLoading = false;
              // _orderData = [];
            });
            popToPreviousScreen(context);
          });
        });
  }

  Widget _reBuyButton(dynamic data) {
    return buildMarketButton(
        width: width * 0.4,
        contents: [buildTextContent("Mua lại", false, fontSize: 13)],
        bgColor: blueColor,
        function: () {});
  }

  Widget _reviewButton(dynamic data) {
    return buildMarketButton(
        width: width * 0.4,
        contents: [buildTextContent("Đánh giá", false, fontSize: 13)],
        bgColor: blueColor,
        function: () {
          pushToNextScreen(
              context,
              ReviewProductMarketPage(
                reviewId: data["id"],
                completeProductList: data["order_items"],
              ));
        });
  }

  Widget _seeReviewButton(dynamic data) {
    return buildMarketButton(
        width: width * 0.4,
        contents: [buildTextContent("Đánh giá shop", false, fontSize: 13)],
        bgColor: blueColor,
        function: () {
          pushToNextScreen(
              context,
              SeeReviewShopMarketPage(
                reviewId: data["id"],
                reviewData: data["order_items"],
              ));
        });
  }

  Widget _gotOrder(dynamic data) {
    return buildMarketButton(
        width: width * 0.4,
        contents:[
          buildTextContent("Đã nhận hàng", false,fontSize: 13)
        ] ,
        bgColor: blueColor,
        function: () async {
          setState(() {
            _isLoading = true;
          });
          data["status"] = "finish";
          List<dynamic> primaryOrderList = _orderData!;
          for (int i = 0; i < primaryOrderList.length; i++) {
            if (primaryOrderList[i]["id"] == data["id"]) {
              primaryOrderList[i] = data;
            }
          }
          final response = await OrderApis()
              .verifyBuyerOrderApi(data["id"], {"status": "finish"});

          setState(() {
            _isLoading = false;
            _orderData = [];
          });
        });
  }

  Widget _buildBaseBody(Widget widget) {
    return Column(
      children: [
        const SizedBox(
          height: 70,
        ),
        Expanded(
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [widget],
              )),
        ),
      ],
    );
  }
}

Widget _buildBetweenContent(String title, String contents,
    {IconData? iconData,
    bool haveIcon = false,
    bool titleBold = false,
    bool contentBold = false,
    double? titleSize,
    double? contentSize,
    Color? contentColor,
    Color? titleColor,
    EdgeInsets? margin = const EdgeInsets.only(top: 10, left: 10, right: 10)}) {
  return Container(
    margin: margin,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            haveIcon
                ? Column(
                    children: [
                      Icon(
                        iconData ?? FontAwesomeIcons.locationPin,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  )
                : const SizedBox(),
            buildTextContent(title, titleBold,
                fontSize: titleSize ?? 14, colorWord: titleColor),
          ],
        ),
        const SizedBox(
          width: 30,
        ),
        Expanded(
          // flex: 10,
          child: Wrap(
            alignment: WrapAlignment.end,
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  contents,
                  textAlign: TextAlign.left,
                  maxLines: 10,
                  style: TextStyle(
                      color: contentColor,
                      fontSize: contentSize,
                      fontWeight:
                          contentBold ? FontWeight.bold : FontWeight.normal),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
