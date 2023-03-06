import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/a_test/test.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/order_product_apis.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/order_product_provider.dart';
import 'package:social_network_app_mobile/screen/MarketPlace/widgets/button_for_market_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_message_dialog_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/divider_widget.dart';
import '../../../../widget/back_icon_appbar.dart';
import '../../../helper/push_to_new_screen.dart';
import 'notification_market_page.dart';
import 'review_product_market_page.dart';
import 'see_review_shop_market.dart';

class OrderProductMarketPage extends ConsumerStatefulWidget {
  const OrderProductMarketPage({super.key});

  @override
  ConsumerState<OrderProductMarketPage> createState() =>
      _OrderProductMarketPageState();
}

class _OrderProductMarketPageState
    extends ConsumerState<OrderProductMarketPage> {
  late double width = 0;
  late double height = 0;
  List<dynamic>? _orderData = [];
  List<dynamic>? _filteredOrderData;
  Color? colorTheme;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final orderData = await ref.read(orderProvider.notifier).getOrder();
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
    Color colorWord = ThemeMode.dark == true
        ? white
        : true == ThemeMode.light
            ? blackColor
            : blackColor;
    Future.wait([_initData()]);
    return DefaultTabController(
        length: 7,
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
                  const AppBarTitle(title: "Danh sách đơn hàng"),
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
                      icon:
                          Icon(FontAwesomeIcons.searchengin, color: colorWord),
                      child: Text(
                          e["title"] +
                              " (" +
                              _filteredOrderData?[OrderProductMarketConstant
                                      .ORDER_PRODUCT_MARKET_TAB_LIST
                                      .indexOf(e)]["data"]
                                  .length
                                  .toString() +
                              ")",
                          style: TextStyle(color: colorWord)));
                }).toList(),
              ),
            ),
            body: _orderData != null && _orderData!.isNotEmpty
                ? TabBarView(
                    children: [
                      _buildAllBody(),
                      _buildPendingBody(),
                      _buildDeliveredBody(),
                      _buildShippingBody(),
                      _buildFinishBody(),
                      _buildCancelBody(),
                      _buildReturnBody(),
                    ],
                  )
                : const Center(
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        strokeWidth: 3,
                      ),
                    ),
                  )));
  }

  Future<int> _initData() async {
    if (_orderData == null || _orderData!.isEmpty) {
      Future.delayed(Duration.zero, () async {
        final orderData = await ref.read(orderProvider.notifier).getOrder();
      });
      _filteredOrderData =
          OrderProductMarketConstant.ORDER_PRODUCT_MARKET_TAB_LIST.map(
        (e) {
          return {"key": e["key"], "title": e["title"], "data": []};
        },
      ).toList();

      _orderData = ref.watch(orderProvider).order;

//  _filterAndSort(_orderData);
      _orderData?.forEach((_orderDataElement) {
        for (var _filteredOrderDataElement in _filteredOrderData!) {
          if (_filteredOrderDataElement["key"] == _orderDataElement["status"]) {
            _filteredOrderData![_filteredOrderData!
                    .indexOf(_filteredOrderDataElement)]['data']
                .add(_orderDataElement);
          }
        }
      });
      _filteredOrderData![0]["data"] = _orderData;
    }
    _isLoading = false;
    setState(() {});
    return 0;
  }

  Widget _buildAllBody() {
    return _buildBaseBody(_buildOrderComponent(_filteredOrderData![0]));
  }

  Widget _buildPendingBody() {
    return _buildBaseBody(_buildOrderComponent(_filteredOrderData![1]));
  }

  Widget _buildDeliveredBody() {
    return _buildBaseBody(_buildOrderComponent(_filteredOrderData![2]));
  }

  Widget _buildShippingBody() {
    return _buildBaseBody(_buildOrderComponent(_filteredOrderData![3]));
  }

  Widget _buildFinishBody() {
    return _buildBaseBody(_buildOrderComponent(_filteredOrderData![4]));
  }

  Widget _buildCancelBody() {
    return _buildBaseBody(_buildOrderComponent(_filteredOrderData![5]));
  }

  Widget _buildReturnBody() {
    return _buildBaseBody(_buildOrderComponent(_filteredOrderData![6]));
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
    showBottomSheetCheckImportantSettings(
        bgColor: colorTheme,
        context,
        height * 0.75,
        "Chi tiết đơn hàng",
        iconData: FontAwesomeIcons.chevronLeft,
        widget: data["delivery_address"] != null &&
                data["delivery_address"].isNotEmpty
            ? Expanded(
                child: ListView(children: [
                  _buildBetweenContent(
                      "Người nhận", data["delivery_address"]["name"],
                      titleColor: greyColor),
                  _buildBetweenContent(
                      "Số điện thoại", data["delivery_address"]["phone_number"],
                      titleColor: greyColor),
                  _buildBetweenContent(
                      "Địa chỉ nhận hàng",
                      data["delivery_address"]["detail_addresses"] +
                          ", " +
                          "Địa chỉ nhận hàng" +
                          data["delivery_address"]["addresses"],
                      titleColor: greyColor),
                  _buildBetweenContent("Thông tin vận chuyển", "Kiện hàng 1",
                      titleColor: greyColor),
                  buildDivider(color: red, top: 5, bottom: 5),
                  // thong tin thanh toán
                  buildTextContent("Thông tin thanh toán", true,
                      fontSize: 22, isCenterLeft: false),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: DataTable(columns: const [
                        DataColumn(
                            label: Text('STT',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Sản phẩm',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Sku phân loại',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Đơn giá',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Số lượng',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Thành tiền',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))),
                      ], rows: rowList),
                    ),
                  ),
                  _buildBetweenContent(
                    "Tổng tiền sản phẩm",
                    data["subtotal"].toString(),
                  ),
                  _buildBetweenContent(
                    "Phí vận chuyển",
                    data["delivery_fee"].toString(),
                  ),
                  _buildBetweenContent(
                    "Doanh thu đơn hàng",
                    data["order_total"].toString(),
                    titleBold: true,
                  ),
                  buildSpacer(height: 5),
                  buildDivider(color: red),
                  // thanh toan của người mua
                  buildTextContent("Thanh toán của người mua", true,
                      fontSize: 22, isCenterLeft: false),
                  buildSpacer(height: 10),
                  _buildBetweenContent(
                      "Tổng tiền sản phẩm", data["subtotal"].toString()),
                  _buildBetweenContent(
                      "Phí vận chuyển", data["delivery_fee"].toString()),
                  _buildBetweenContent(
                      "Tổng tiền thanh toán", data["order_total"].toString(),
                      titleBold: true, titleColor: blackColor),
                  buildSpacer(height: 10)
                ]),
              )
            : const SizedBox());
  }

  Widget _getStatus(dynamic key) {
    Color wordColor = blackColor;
    String title = "";
    switch (key) {
      case "pending":
        wordColor = Colors.orange;
        title = "Chờ thanh toán";
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

  Widget _buildOrderComponent(dynamic filterData) {
    return filterData["data"].length != 0
        ? Column(
            children: List.generate(filterData["data"].length, (index) {
            final data = filterData["data"][index];
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    _showDetailDialog(data);
                  },
                  child: Column(children: [
                    index != 0 ? buildSpacer(height: 10) : const SizedBox(),
                    const CrossBar(
                      height: 10,
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
                        data["order_items"].length,
                        (index) {
                          return _buildOrderItem(data["order_items"][index]);
                        },
                      ),
                    ),
                    buildDivider(color: red),
                    _buildBetweenContent(
                        "Tổng tiền", data["subtotal"].toString(),
                        titleSize: 13, contentSize: 15, haveIcon: false),
                    _buildBetweenContent(
                        "Phí ship", data["delivery_fee"].toString(),
                        titleSize: 13, contentSize: 15, haveIcon: false),
                    _buildBetweenContent(
                        "Thành tiền", data["order_total"].toString(),
                        titleSize: 14,
                        contentSize: 16,
                        haveIcon: false,
                        contentBold: true),
                    _buildButtons(data)
                  ]),
                ),
              ],
            );
          }))
        : buildTextContent("Bạn không có đơn hàng nào !!", false,
            isCenterLeft: false);
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
                    child: buildTextContent(
                        childfilterData["product_variant"]["title"], false,
                        fontSize: 15),
                  ),
                ],
              )),
          buildSpacer(height: 5),
          _buildBetweenContent(
              "Phân loại hạng",
              childfilterData["product_variant"]["option1"] == null &&
                      childfilterData["product_variant"]["option2"] == null
                  ? "Không phân loại"
                  : childfilterData["product_variant"]["option1"] != null
                      ? childfilterData["product_variant"]["option1"]
                      : "" + childfilterData["product_variant"]["option2"] !=
                              null
                          ? childfilterData["product_variant"]["option2"]
                          : "",
              titleColor: greyColor[700],
              titleSize: 13,
              contentSize: 15),
          buildSpacer(height: 5),
          _buildBetweenContent(
              "Số lượng", childfilterData["quantity"].toString(),
              titleColor: greyColor[700], titleSize: 13, contentSize: 15),
          buildSpacer(height: 5),
          _buildBetweenContent(
              "Đơn giá", childfilterData["product_variant"]["price"].toString(),
              titleColor: greyColor[700], titleSize: 13, contentSize: 15),
        ],
      )
    ]);
    // index == length - 1 ? const SizedBox() : buildDivider(color: red),
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

  Widget _payButton(dynamic data) {
    return buildButtonForMarketWidget(
        width: width * 0.4,
        title: "Thanh toán",
        function: () {
          // _showDetailDialog(data);
        });
  }

  Widget _contactWithSellerButton(dynamic data) {
    return buildButtonForMarketWidget(
        width: width * 0.4,
        title: "Liên hệ",
        bgColor: blueColor,
        function: () {
          // _showDetailDialog(data);
        });
  }

  Widget _cancelOrderButton(dynamic data) {
    return buildButtonForMarketWidget(
        width: width * 0.4,
        title: "Hủy đơn hàng",
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
            _filterAndSort(primaryOrderList);

            // chua co api huy don hang tu phia nguoi mua
            // final response = await OrderApis()
            // .verifyFinishOrderApi(data["id"], {"status": "cancelled"});
            setState(() {
              _isLoading = false;
            });
            popToPreviousScreen(context);
          });
        });
  }

  Widget _reBuyButton(dynamic data) {
    return buildButtonForMarketWidget(
        width: width * 0.4,
        title: "Mua lại",
        bgColor: blueColor,
        function: () {
          // _showDetailDialog(data);
        });
  }

  Widget _reviewButton(dynamic data) {
    return buildButtonForMarketWidget(
        width: width * 0.4,
        title: "Đánh giá",
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
    return buildButtonForMarketWidget(
        width: width * 0.4,
        title: "Đánh giá shop",
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
    return buildButtonForMarketWidget(
        width: width * 0.4,
        title: "Đã nhận hàng",
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
          _filterAndSort(primaryOrderList);
          final response = await OrderApis()
              .verifyFinishOrderApi(data["id"], {"status": "finish"});
          setState(() {
            _isLoading = false;
          });
        });
  }

  Future _filterAndSort(List<dynamic>? primaryOrderList) async {
    //resst list
    _filteredOrderData = [];
    _filteredOrderData =
        await OrderProductMarketConstant.ORDER_PRODUCT_MARKET_TAB_LIST.map(
      (e) {
        return {"key": e["key"], "title": e["title"], "data": []};
      },
    ).toList();

    primaryOrderList?.forEach((primaryOrderElement) {
      for (var filteredOrderDataElement in _filteredOrderData!) {
        if (filteredOrderDataElement["key"] == primaryOrderElement["status"]) {
          _filteredOrderData![
                  _filteredOrderData!.indexOf(filteredOrderDataElement)]['data']
              .add(primaryOrderElement);
        }
      }
    });
    _filteredOrderData![0]["data"] = primaryOrderList;
    setState(() {});
  }
}

Widget _buildBaseBody(Widget widget) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 10),
    child: Expanded(
      child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [widget],
          )),
    ),
  );
}

Widget _buildBetweenContent(
  String title,
  String contents, {
  IconData? iconData,
  bool haveIcon = false,
  bool titleBold = false,
  bool contentBold = false,
  double? titleSize,
  double? contentSize,
  Color? contentColor,
  Color? titleColor,
}) {
  return Container(
    margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
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
