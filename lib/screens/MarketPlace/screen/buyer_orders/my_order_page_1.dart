import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/constant/marketPlace_constants.dart';
import 'package:market_place/helpers/format_currency.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/providers/market_place_providers/order_product_provider.dart';
import 'package:market_place/screens/MarketPlace/screen/buyer_orders/success_order._page.dart';
import 'package:market_place/screens/MarketPlace/screen/notification_market_page.dart';
import 'package:market_place/screens/MarketPlace/screen/review_product_page.dart';
import 'package:market_place/screens/MarketPlace/screen/see_review_market.dart';
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

class MyOrderPage1 extends ConsumerStatefulWidget {
  const MyOrderPage1({super.key});

  @override
  ConsumerState<MyOrderPage1> createState() => _MyOrderPage1State();
}

class _MyOrderPage1State extends ConsumerState<MyOrderPage1> {
  late double width = 0;
  late double height = 0;
  // List<dynamic>? _orderData;
  List<dynamic>? _filteredOrderData = [];
  Color? colorTheme;
  bool _isLoading = true;
  bool check = false;
  ScrollController _detailBottomController = ScrollController();
  List<dynamic> initFilterOrderData =
      OrderProductMarketConstant.ORDER_PRODUCT_MARKET_TAB_LIST.map(
    (e) {
      return {"key": e["key"], "open": null, "title": e["title"], "data": []};
    },
  ).toList();

  dynamic _orderTabCount;
  List<dynamic>? _unpaidList;
  List<dynamic>? _deliveredList;
  List<dynamic>? _shippingList;
  List<dynamic>? _finishList;
  List<dynamic>? _canceledList;
  List<dynamic>? _returnList;

  bool? _unpaidLoading = true;
  bool? _deliveredLoading = true;
  bool? _shippingLoading = true;
  bool? _finishLoading = true;
  bool? _canceledLoading = true;
  bool? _returnLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final orderData =
          await ref.read(orderSellerProvider.notifier).getBuyerOrder();
    });
    _filteredOrderData =
        OrderProductMarketConstant.ORDER_PRODUCT_MARKET_TAB_LIST.map(
      (e) {
        return {"key": e["key"], "open": null, "title": e["title"], "data": []};
      },
    ).toList();
  }

  @override
  void dispose() {
    super.dispose();
    _filteredOrderData = [];
  }

  Future<int> _initData() async {
    _orderTabCount ??= await OrderApis().getOrderCount();
    if (_unpaidList == null) {
      _unpaidList = await OrderApis().getPaymentStatusBuyerApi();
      _unpaidList = formatDataList(_unpaidList!);
    }
    if (_deliveredList == null) {
      _deliveredList = await OrderApis().getStatusBuyerApi("delivered");
      _deliveredList = formatDataList(_deliveredList!);
    }
    if (_shippingList == null) {
      _shippingList = await OrderApis().getStatusBuyerApi("shipping");
      _shippingList = formatDataList(_shippingList!);
    }
    if (_finishList == null) {
      _finishList = await OrderApis().getStatusBuyerApi("finish");
      _finishList = formatDataList(_finishList!);
    }
    if (_canceledList == null) {
      _canceledList = await OrderApis().getStatusBuyerApi("canceled");
      _canceledList = formatDataList(_canceledList!);
    }
    if (_returnList == null) {
      _returnList = await OrderApis().getStatusBuyerApi("return");
      _returnList = formatDataList(_returnList!);
    }

    // _unpaidList = formatDataList(_unpaidList!);
    // _deliveredList = formatDataList(_deliveredList!);
    // _shippingList = formatDataList(_shippingList!);
    // _finishList = formatDataList(_finishList!);
    // _canceledList = formatDataList(_canceledList!);
    // _returnList = formatDataList(_returnList!);

    // if (_orderData == null) {
    //   // _orderData = ref.watch(orderBuyerProvider).buyerOrder;
    //   _orderData = await OrderApis().getBuySellerOrderApi();
    //   _filteredOrderData =
    //       OrderProductMarketConstant.ORDER_PRODUCT_MARKET_TAB_LIST.map(
    //     (e) {
    //       return {
    //         "key": e["key"],
    //         "open": null,
    //         "title": e["title"],
    //         "data": []
    //       };
    //     },
    //   ).toList();
    //   _orderData?.forEach((_orderDataElement) {
    //     dynamic openOrderDataElement = _orderDataElement;
    //     openOrderDataElement["open"] =
    //         _orderDataElement["order_items"].length > 1 ? false : null;
    //     for (dynamic _filteredOrderDataElement in _filteredOrderData!) {
    //       if (_filteredOrderDataElement["key"] == _orderDataElement["status"]) {
    //         _filteredOrderData![_filteredOrderData!
    //                 .indexOf(_filteredOrderDataElement)]['data']
    //             .add(openOrderDataElement);
    //       }
    //     }
    //   });
    // }
    setState(() {
      _isLoading = false;
    });
    print(_unpaidList!.length);
    print(_deliveredList!.length);
    print(_shippingList!.length);
    print(_finishList!.length);
    print(_canceledList!.length);
    print(_returnList!.length);
    return 0;
  }

  dynamic formatDataList(List<dynamic> dataList) {
    if (dataList.isEmpty) {
      return [];
    } else {
      List<dynamic> primaryList = dataList.map((element) {
        return {
          "status": element["status"],
          "payment_status": element["payment_status"],
          "open": element["open"],
          "data": element
        };
      }).toList();
      primaryList.forEach((element) {
        if (element["data"]["order_items"].length > 1) {
          element["open"] = false;
        }
      });
      return primaryList;
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
                  const AppBarTitle(text: "Danh sách đơn mua"),
                  GestureDetector(
                    onTap: () {
                      pushToNextScreen(context, NotificationMarketPage());
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
                                  _getOrderCount(e["key"]).toString() +
                                  ")",
                              false,
                              isCenterLeft: false,
                              colorWord: colorWord,
                              fontSize: 11)));
                }).toList(),
              ),
            ),
            body: TabBarView(
              children: [
                _unpaidList != null
                    ? _unpaidList!.isNotEmpty
                        ? _buildPendingBody()
                        : buildTextContent("Bạn chưa có đơn hàng nào", false,
                            fontSize: 18, isCenterLeft: false)
                    : buildCircularProgressIndicator(),
                _deliveredList != null
                    ? _deliveredList!.isNotEmpty
                        ? _buildDeliveredBody()
                        : buildTextContent("Bạn chưa có đơn hàng nào", false,
                            fontSize: 18, isCenterLeft: false)
                    : buildCircularProgressIndicator(),
                _shippingList != null
                    ? _shippingList!.isNotEmpty
                        ? _buildShippingBody()
                        : buildTextContent("Bạn chưa có đơn hàng nào", false,
                            fontSize: 18, isCenterLeft: false)
                    : buildCircularProgressIndicator(),
                _finishList != null
                    ? _finishList!.isNotEmpty
                        ? _buildFinishBody()
                        : buildTextContent("Bạn chưa có đơn hàng nào", false,
                            fontSize: 18, isCenterLeft: false)
                    : buildCircularProgressIndicator(),
                _canceledList != null
                    ? _canceledList!.isNotEmpty
                        ? _buildCancelBody()
                        : buildTextContent("Bạn chưa có đơn hàng nào", false,
                            fontSize: 18, isCenterLeft: false)
                    : buildCircularProgressIndicator(),
                _returnList != null
                    ? _returnList!.isNotEmpty
                        ? _buildReturnBody()
                        : buildTextContent("Bạn chưa có đơn hàng nào", false,
                            fontSize: 18, isCenterLeft: false)
                    : buildCircularProgressIndicator(),
              ],
            )));
  }

  Widget _buildPendingBody() {
    return _buildBaseBody(_buildOrderComponent(_unpaidList!));
  }

  Widget _buildDeliveredBody() {
    return _buildBaseBody(_buildOrderComponent(_deliveredList!));
  }

  Widget _buildShippingBody() {
    return _buildBaseBody(_buildOrderComponent(_shippingList!));
  }

  Widget _buildFinishBody() {
    return _buildBaseBody(_buildOrderComponent(_finishList!, function: () {
      pushToNextScreen(context, const SuccessOrderPage());
    }));
  }

  Widget _buildCancelBody() {
    return _buildBaseBody(_buildOrderComponent(_canceledList!));
  }

  Widget _buildReturnBody() {
    return _buildBaseBody(_buildOrderComponent(_returnList!));
  }

  void _showDetailDialog(dynamic data) {
    List<DataRow> rowList = <DataRow>[];
    if (data["delivery_address"] != null &&
        data["delivery_address"].isNotEmpty) {
      for (int i = 0; i < data["order_items"].length; i++) {
        rowList.add(DataRow(cells: [
          DataCell(Text((i + 1).toString())),
          DataCell(Text(data["order_items"][i]["product_variant"]["title"])),
          DataCell(Text(data["order_items"][i]["product_variant"]["sku"])),
          DataCell(Text(
              data["order_items"][i]["product_variant"]["price"].toString())),
          DataCell(Text(data["order_items"][i]["quantity"].toString())),
          DataCell(Text((data["order_items"][i]["product_variant"]["price"] *
                  data["order_items"][i]["quantity"])
              .toString())),
        ]));
      }
    }
    showCustomBottomSheet(
        bgColor: colorTheme,
        context,
        height - 50,
        title: "Chi tiết đơn hàng",
        iconData: FontAwesomeIcons.chevronLeft,
        widget: data["delivery_address"] != null &&
                data["delivery_address"].isNotEmpty
            ? Expanded(
                child: SingleChildScrollView(
                  controller: _detailBottomController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(children: [
                    GeneralComponent(
                      [
                        buildTextContent("Chờ lấy hàng", false, fontSize: 17),
                        buildSpacer(height: 7),
                        buildTextContent(
                            "Chúng tôi đề xuất chỉ giao đơn COD sau 2 tiếng sau khi đơn hàng được đặt. Phần lớn việc hủy hàng xảy ra trong 2 tiếng đầu tiên sau khi hàng được đặt. Bạn có thể bấm 'Chuẩn bị hàng' sau 2 tiếng. ",
                            false,
                            fontSize: 14),
                      ],
                      prefixWidget: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(
                            FontAwesomeIcons.cartPlus,
                            size: 18,
                          ),
                          SizedBox()
                        ],
                      ),
                      changeBackground: transparent,
                      isHaveBorder: false,
                      padding: EdgeInsets.zero,
                    ),
                    const CrossBar(
                      height: 5,
                    ),
                    GeneralComponent(
                      [
                        buildTextContent(
                            "Xác nhận mua hàng vào ngày 66/66/666 Xác nhận mua hàng vào ngày 66/66/666",
                            false,
                            fontSize: 15),
                      ],
                      prefixWidget: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(
                            FontAwesomeIcons.cartPlus,
                            size: 18,
                          ),
                          SizedBox()
                        ],
                      ),
                      changeBackground: transparent,
                      isHaveBorder: false,
                      padding: EdgeInsets.zero,
                    ),
                    const CrossBar(
                      height: 5,
                    ),
                    GeneralComponent(
                      [
                        buildTextContent(
                            "Lịch sử nhận hàng của người mua", true,
                            fontSize: 17),
                        buildSpacer(height: 7),
                        buildTextContent(
                            "Với người mua có tỉ lệ giao hàng thành công thấp,nnnnnnnnnnnnnnnnnnnnn",
                            false,
                            fontSize: 13,
                            colorWord: greyColor),
                        buildSpacer(height: 7),
                        buildTextContent(
                            "Chưa có đơn hàng giao thành công", false,
                            fontSize: 15),
                      ],
                      changeBackground: transparent,
                      isHaveBorder: false,
                      padding: const EdgeInsets.only(left: 10),
                    ),
                    const CrossBar(
                      height: 5,
                    ),
                    GeneralComponent(
                      [
                        buildTextContent("Địa chỉ nhận hàng", true,
                            fontSize: 17),
                        const SizedBox(
                          height: 7,
                        ),
                        buildTextContent(
                            data["delivery_address"]["name"], false,
                            fontSize: 13),
                        buildSpacer(height: 5),
                        buildTextContent(
                            data["delivery_address"]["phone_number"], false,
                            fontSize: 13),
                        buildSpacer(height: 5),
                        buildTextContent(
                            data["delivery_address"]["detail_addresses"], false,
                            fontSize: 13),
                      ],
                      prefixWidget: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(
                            FontAwesomeIcons.cartPlus,
                            size: 18,
                          ),
                          SizedBox()
                        ],
                      ),
                      changeBackground: transparent,
                      isHaveBorder: false,
                      padding: EdgeInsets.zero,
                    ),
                    const CrossBar(
                      height: 5,
                    ),
                    GeneralComponent(
                      [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTextContent("Thông tin vận chuyển", true,
                                fontSize: 17),
                            buildTextContent("Xem", true,
                                fontSize: 17, colorWord: greyColor),
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        buildTextContent("Hỏa tốc", false, fontSize: 13),
                        buildSpacer(height: 5),
                        buildTextContent("Express Viet Nam", false,
                            fontSize: 13),
                      ],
                      prefixWidget: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(
                            FontAwesomeIcons.cartPlus,
                            size: 18,
                          ),
                          SizedBox()
                        ],
                      ),
                      changeBackground: transparent,
                      isHaveBorder: false,
                      padding: EdgeInsets.zero,
                    ),
                    const CrossBar(
                      height: 5,
                    ),
                    GeneralComponent(
                      [
                        buildTextContent("Thông tin thanh toán", true,
                            fontSize: 17),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTextContent("Tổng tiền sản phẩm", false,
                                fontSize: 13),
                            buildTextContent("đ${data["subtotal"]}", false,
                                fontSize: 13, colorWord: greyColor),
                          ],
                        ),
                        buildSpacer(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTextContent(
                                "Phí vận chuyển(không tính trợ giá)", false,
                                fontSize: 13),
                            buildTextContent("đ${data["delivery_fee"]}", false,
                                fontSize: 13, colorWord: greyColor),
                          ],
                        ),
                        buildSpacer(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTextContent("Phí giao dịch", false,
                                fontSize: 13),
                            buildTextContent("đ15.000", false,
                                fontSize: 13, colorWord: greyColor),
                          ],
                        ),
                        buildSpacer(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTextContent("Tổng tiền thanh toán", false,
                                fontSize: 13),
                            buildTextContent(
                                data["order_total"].toString(), false,
                                fontSize: 13, colorWord: greyColor),
                          ],
                        ),
                      ],
                      prefixWidget: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(
                            FontAwesomeIcons.cartPlus,
                            size: 18,
                          ),
                          SizedBox()
                        ],
                      ),
                      changeBackground: transparent,
                      isHaveBorder: false,
                      padding: EdgeInsets.zero,
                    ),
                  ]),
                ),
              )
            : const SizedBox());
  }

  dynamic _getOrderCount(dynamic title) {
    switch (title) {
      case "pending":
        return _orderTabCount == null
            ? "0"
            : _orderTabCount!["pending_count"].toString() ?? "0";
      case "delivered":
        return _orderTabCount == null
            ? "0"
            : _orderTabCount!["delivered_count"].toString() ?? "0";
      case "shipping":
        return _orderTabCount == null
            ? "0"
            : _orderTabCount!["shipping_count"].toString() ?? "0";
      case "finish":
        return _orderTabCount == null
            ? "0"
            : _orderTabCount!["finish_count"].toString() ?? "0";
      case "cancelled":
        return _orderTabCount == null
            ? "0"
            : _orderTabCount!["cancelled_count"].toString() ?? "0";
      case "return":
        return _orderTabCount == null
            ? "0"
            : _orderTabCount!["return_count"].toString();
      default:
        return "0";
    }
  }

  Widget _getStatus(dynamic status, {dynamic paymentStatus}) {
    Color wordColor = blackColor;
    String title = "";
    switch (status) {
      case "pending":
        wordColor = Colors.orange;
        if (paymentStatus == "unpaid") {
          title = "Chờ xử lý - chưa thanh toán";
        } else {
          title = "Chờ xử lý - đã thanh toán";
        }
        break;
      case "delivered":
        wordColor = Colors.grey;
        if (paymentStatus == "unpaid") {
          title = "Vận chuyển - chưa thanh toán";
        } else {
          title = "Vận chuyển - đã thanh toán";
        }
        break;
      case "shipping":
        wordColor = Colors.green;
        if (paymentStatus == "unpaid") {
          title = "Đang giao - chưa thanh toán";
        } else {
          title = "Đang giao - đã thanh toán";
        }
        break;
      case "finish":
        wordColor = Colors.blue;
        if (paymentStatus == "unpaid") {
          title = "Hoàn thành - chưa thanh toán";
        } else {
          title = "Hoàn thành - đã thanh toán";
        }
        break;
      case "cancelled":
        wordColor = Colors.red;
        if (paymentStatus == "unpaid") {
          title = "Đã hủy - chưa thanh toán";
        } else {
          title = "Đã hủy - đã thanh toán";
        }
        break;
      case "return":
        wordColor = Colors.purple;
        if (paymentStatus == "unpaid") {
          title = "Trả hàng/ Hoàn tiền - chưa thanh toán";
        } else {
          title = "Trả hàng/ Hoàn tiền - đã thanh toán";
        }
        break;
      default:
        break;
    }
    return buildTextContent(title, true, fontSize: 16, colorWord: wordColor);
  }
// general

  Widget _buildOrderComponent(List<dynamic> dataList, {Function? function}) {
    return dataList.isNotEmpty
        ? Column(
            children: List.generate(dataList.length, (index) {
            final data = dataList[index];
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    function == null ? _showDetailDialog(data) : function();
                  },
                  child: Column(children: [
                    index != 0 ? buildSpacer(height: 5) : const SizedBox(),
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
                          _getStatus(data["status"],
                              paymentStatus: data["payment_status"])
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
                                  data["data"]["page"]["title"],
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
                        data["open"] == true
                            ? data["data"]["order_items"].length
                            : 1,
                        (index) {
                          return _buildOrderItem(
                              data["data"]["order_items"][index]);
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
                              dataList[index]["open"] = true;
                              setState(() {});
                            }),
                          )
                        : const SizedBox(),
                    _buildBetweenContent(
                        "${data["data"]["order_items"].length} sản phẩm",
                        "Thành tiền: ₫${formatCurrency(data["data"]["order_total"]).toString()}",
                        titleSize: 14,
                        contentSize: 16,
                        haveIcon: false,
                        contentBold: true),
                    buildSpacer(height: 5),
                    buildDivider(color: red),
                    // orderIndex == 3
                    //     ? Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Container(
                    //             margin: const EdgeInsets.only(left: 10),
                    //             width: width * 0.5,
                    //             child: buildTextContent(
                    //                 "Hãy đánh giá Người mua trước ngày 13/3/2023 Shop nhé",
                    //                 false,
                    //                 overflow: TextOverflow.ellipsis,
                    //                 maxLines: 2,
                    //                 colorWord: greyColor,
                    //                 fontSize: 12),
                    //           ),
                    //           _buildButtons(data),
                    //         ],
                    //       )
                    //     : _buildButtons(data),
                    // orderIndex == 3
                    //     ? Column(
                    //         children: [
                    //           buildSpacer(height: 10),
                    //           buildDivider(color: red),
                    //         ],
                    //       )
                    //     : const SizedBox(),
                    // orderIndex == 3
                    //     ? _buildBetweenContent("Mã đơn hàng", "#76346364863",
                    //         titleSize: 14,
                    //         contentSize: 16,
                    //         haveIcon: false,
                    //         contentBold: true,
                    //         margin: const EdgeInsets.only(
                    //           top: 5,
                    //           left: 10,
                    //           right: 10,
                    //         ))
                    //     : const SizedBox(),
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
                                              ["option1"] !=
                                          null
                                      ? childfilterData["product_variant"]
                                          ["option1"]
                                      : "" +
                                                  childfilterData[
                                                          "product_variant"]
                                                      ["option2"] !=
                                              null
                                          ? childfilterData["product_variant"]
                                              ["option2"]
                                          : "",
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
        buttonList.add(_payButton(data));
        // buttonList.add(_seeDetailButton(data));
        break;
      case "delivered":
        buttonList.add(_cancelOrderButton(data));
        buttonList.add(_contactWithSellerButton(data));
        break;
      case "shipping":
        buttonList.add(_gotOrder(data));

        break;
      case "finish":
        buttonList.add(_reviewButton(data));
        // buttonList.add(_reBuyButton(data));
        // buttonList.add(_seeReviewButton(data));
        break;
      case "cancelled":
        buttonList.add(_contactWithSellerButton(data));
        // buttonList.add(_reBuyButton(data));
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

  Widget _payButton(dynamic data) {
    return buildMarketButton(
        width: width * 0.4,
        contents: [buildTextContent("Thanh toán", false, fontSize: 13)],
        function: () {
          // _showDetailDialog(data);
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
            // List<dynamic> primaryOrderList = _orderData!;
            // for (int i = 0; i < primaryOrderList.length; i++) {
            //   if (primaryOrderList[i]["id"] == data["id"]) {
            //     primaryOrderList[i] = data;
            //   }
            // }
            // _filterAndSort(primaryOrderList);

            // chua co api huy don hang tu phia nguoi mua
            // final response = await OrderApis()
            // .verifyFinishOrderApi(data["id"], {"status": "cancelled"});
            setState(() {
              _isLoading = false;
              // _filteredOrderData = primaryOrderList;
            });
            popToPreviousScreen(context);
          });
        });
  }

  Widget _reBuyButton(dynamic data) {
    return buildMarketButton(
        width: width * 0.3,
        contents: [buildTextContent("Mua lại", false, fontSize: 13)],
        bgColor: blueColor,
        function: () {});
  }

  Widget _reviewButton(dynamic data) {
    return buildMarketButton(
        width: width * 0.4,
        contents: [buildTextContent("Đánh gia", false, fontSize: 13)],
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
        contents: [buildTextContent("Đã nhận hàng", false, fontSize: 13)],
        bgColor: blueColor,
        function: () async {
          setState(() {
            _isLoading = true;
          });
          data["status"] = "finish";
          // List<dynamic> primaryOrderList = _orderData!;
          // for (int i = 0; i < primaryOrderList.length; i++) {
          //   if (primaryOrderList[i]["id"] == data["id"]) {
          //     primaryOrderList[i] = data;
          //   }
          // }
          // _filterAndSort(primaryOrderList);
          // final response = await OrderApis()
          //     .verifyBuyerOrderApi(data["id"], {"status": "finish"});

          setState(() {
            _isLoading = false;
            // _orderData = [];
          });
        });
  }

  Future _filterAndSort(List<dynamic>? primaryOrderList) async {
    _filteredOrderData = await initFilterOrderData;

    primaryOrderList?.forEach((primaryOrderElement) {
      for (var filteredOrderDataElement in _filteredOrderData!) {
        if (filteredOrderDataElement["key"] == primaryOrderElement["status"]) {
          _filteredOrderData![
                  _filteredOrderData!.indexOf(filteredOrderDataElement)]['data']
              .add(primaryOrderElement);
          if (primaryOrderElement["order_items"].length > 1) {
            _filteredOrderData![_filteredOrderData!
                .indexOf(filteredOrderDataElement)]['open'] = false;
          }
        } //
      }
    });

    setState(() {});
  }
}

Widget _buildBaseBody(Widget widget) {
  return SingleChildScrollView(
      // padding: const EdgeInsets.only(top: 20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [widget],
      ));
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
