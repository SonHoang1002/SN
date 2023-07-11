import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart'; 
import 'package:market_place/constant/marketPlace_constants.dart';
import 'package:market_place/helpers/format_currency.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/providers/market_place_providers/order_product_provider.dart';
import 'package:market_place/providers/market_place_providers/products_provider.dart';
import 'package:market_place/screens/MarketPlace/screen/buyer_orders/cancelled_return_page.dart';
import 'package:market_place/screens/MarketPlace/screen/buyer_orders/information_order_page.dart';
import 'package:market_place/screens/MarketPlace/screen/buyer_orders/success_order_page.dart';
import 'package:market_place/screens/MarketPlace/screen/main_market_page.dart';
import 'package:market_place/screens/MarketPlace/screen/notification_market_page.dart';
import 'package:market_place/screens/MarketPlace/screen/payment_modules/payment_market_page.dart';
import 'package:market_place/screens/MarketPlace/screen/review_product_page.dart';
import 'package:market_place/screens/MarketPlace/screen/see_review_market.dart';
import 'package:market_place/screens/MarketPlace/screen/transfer_order_page.dart';
import 'package:market_place/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:market_place/screens/MarketPlace/widgets/classify_category_conponent.dart';
import 'package:market_place/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:market_place/apis/market_place_apis/order_product_apis.dart';
import 'package:market_place/screens/MarketPlace/widgets/order_item_widget.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/show_message_dialog_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_button.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/cross_bar.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';
import '../../../../theme/colors.dart';

class MyOrderPage extends ConsumerStatefulWidget {
  const MyOrderPage({super.key});

  @override
  ConsumerState<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends ConsumerState<MyOrderPage> {
  late double width = 0;
  late double height = 0;
  List<dynamic>? _filteredOrderData = [];
  Color? colorTheme;
  bool _isLoading = true;
  List<dynamic> initFilterOrderData =
      OrderProductMarketConstant.ORDER_PRODUCT_MARKET_TAB_LIST.map(
    (e) {
      return {"key": e["key"], "open": null, "title": e["title"], "data": []};
    },
  ).toList();

  /// cac list duoi day co dang :
  /// {
  /// "key": e["key"],
  /// "open": null,
  /// "title": e["title"],
  /// "data":  order data from api
  /// }
  /// CHÚ Ý: KHI TRUYỀN DATA SANG CÁC MÀN HÌNH CẦN CHÚ Ý ORDERDATA
  /// /// ///
  List<dynamic>? _allList;
  List<dynamic>? _pendingList;
  List<dynamic>? _deliveredList;
  List<dynamic>? _shippingList;
  List<dynamic>? _finishList;
  List<dynamic>? _canceledList;
  List<dynamic>? _returnList;
  late ScrollController _allScrollController;
  late ScrollController _pendingScrollController;
  late ScrollController _deliveredScrollController;
  late ScrollController _shippingScrollController;
  late ScrollController _finishScrollController;
  late ScrollController _canceledScrollController;
  late ScrollController _returnScrollController;
  late ScrollController _suggestScrollController;

  List? listSuggestProduct;
  // bool? _allListLoading = true;
  // bool? _pendingLoading = true;
  // bool? _deliveredLoading = true;
  // bool? _shippingLoading = true;
  // bool? _finishLoading = true;
  // bool? _canceledLoading = true;
  // bool? _returnLoading = true;

  @override
  void initState() {
    super.initState();
    _allScrollController = ScrollController();
    _pendingScrollController = ScrollController();
    _deliveredScrollController = ScrollController();
    _shippingScrollController = ScrollController();
    _finishScrollController = ScrollController();
    _canceledScrollController = ScrollController();
    _returnScrollController = ScrollController();
    _suggestScrollController = ScrollController();
    Future.delayed(Duration.zero, () async {
      await ref.read(orderSellerProvider.notifier).getBuyerOrder();
    });
    _filteredOrderData =
        OrderProductMarketConstant.ORDER_PRODUCT_MARKET_TAB_LIST.map(
      (e) {
        return {"key": e["key"], "open": null, "title": e["title"], "data": []};
      },
    ).toList();
    listSuggestProduct = ref.read(productsProvider).list;
    if (mounted) {
      _allScrollController.addListener(() async {
        await _loadMoreFunction(_allScrollController.offset,
            _allScrollController.position.maxScrollExtent, "all");
      });
      _pendingScrollController.addListener(() async {
        await _loadMoreFunction(_pendingScrollController.offset,
            _pendingScrollController.position.maxScrollExtent, "pending");
      });
      _deliveredScrollController.addListener(() async {
        await _loadMoreFunction(_deliveredScrollController.offset,
            _deliveredScrollController.position.maxScrollExtent, "delivered");
      });
      _shippingScrollController.addListener(() async {
        await _loadMoreFunction(_shippingScrollController.offset,
            _shippingScrollController.position.maxScrollExtent, "shipping");
      });
      _finishScrollController.addListener(() {
        _loadMoreFunction(_finishScrollController.offset,
            _finishScrollController.position.maxScrollExtent, "finish");
      });
      _canceledScrollController.addListener(() {
        _loadMoreFunction(_canceledScrollController.offset,
            _canceledScrollController.position.maxScrollExtent, "canceled");
      });
      _returnScrollController.addListener(() {
        _loadMoreFunction(_returnScrollController.offset,
            _returnScrollController.position.maxScrollExtent, "return");
      });
      _suggestScrollController.addListener(() {
        if (_suggestScrollController.offset ==
            _suggestScrollController.position.maxScrollExtent) {
          ref.read(productsProvider.notifier).getProductsSearch({
            "offset": listSuggestProduct!.length,
            ...paramConfigProductSearch
          });
          listSuggestProduct = ref.watch(productsProvider).list;
          setState(() {});
        }
      });
    }
  }

  Future _loadMoreFunction(
      double currentOffset, double maxOffset, dynamic key) async {
    if (currentOffset == maxOffset) {
      switch (key) {
        case "all":
          final response = await getBuyerStatusApi(
              maxId: _allList!.last['data']['id'], limit: 10);
          _allList = formatDataList(
              [..._allList!.map((e) => e['data']).toList(), ...response]);
          setState(() {});
          return;
        case "pending":
          final response = await getBuyerStatusApi(
              maxId: _pendingList!.last['data']['id'], limit: 10, status: key);
          _pendingList = formatDataList(
              [..._pendingList!.map((e) => e['data']).toList(), ...response]);
          return;
        case "delivered":
          final response = await getBuyerStatusApi(
              maxId: _deliveredList!.last['data']['id'],
              limit: 10,
              status: key);
          _deliveredList = formatDataList(
              [..._deliveredList!.map((e) => e['data']).toList(), ...response]);
          return;
        case "shipping":
          final response = await getBuyerStatusApi(
              maxId: _shippingList!.last['data']['id'], limit: 10, status: key);
          _shippingList = formatDataList(
              [..._shippingList!.map((e) => e['data']).toList(), ...response]);
          return;
        case "finish":
          final response = await getBuyerStatusApi(
              maxId: _finishList!.last['data']['id'], limit: 10, status: key);
          _finishList = formatDataList(
              [..._finishList!.map((e) => e['data']).toList(), ...response]);
          return;
        case "canceled":
          final response = await getBuyerStatusApi(
              maxId: _canceledList!.last['data']['id'], limit: 10, status: key);
          _canceledList = formatDataList(
              [..._canceledList!.map((e) => e['data']).toList(), ...response]);
          return;
        case "return":
          final response = await getBuyerStatusApi(
              maxId: _returnList!.last['data']['id'], limit: 10, status: key);
          _returnList = formatDataList(
              [..._returnList!.map((e) => e['data']).toList(), ...response]);
          return;
        default:
          return;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _allList = [];
    _pendingList = [];
    _deliveredList = [];
    _shippingList = [];
    _finishList = [];
    _canceledList = [];
    _returnList = [];
    _filteredOrderData = [];
    _allScrollController.dispose();
    _pendingScrollController.dispose();
    _deliveredScrollController.dispose();
    _shippingScrollController.dispose();
    _finishScrollController.dispose();
    _canceledScrollController.dispose();
    _returnScrollController.dispose();
    listSuggestProduct = null;
  }

  Future<List<dynamic>> getBuyerStatusApi(
      {dynamic status,
      dynamic limit,
      dynamic paymentStatus,
      dynamic maxId}) async {
    final response = await OrderApis().getBuyerOrdersApi(
            status: status,
            limit: limit,
            payment_status: paymentStatus,
            maxId: maxId) ??
        [];
    return response;
  }

  Future<int> _initData() async {
    // _orderTabCount ??= await OrderApis().getOrderCount();
    if (_allList == null) {
      _allList = await getBuyerStatusApi();
      _allList = formatDataList(_allList!);
    }
    if (_pendingList == null) {
      _pendingList = await getBuyerStatusApi(status: "pending");
      _pendingList = formatDataList(_pendingList!);
    }
    if (_deliveredList == null) {
      _deliveredList = await getBuyerStatusApi(status: "delivered");
      _deliveredList = formatDataList(_deliveredList!);
    }
    if (_shippingList == null) {
      _shippingList = await getBuyerStatusApi(status: "shipping");
      _shippingList = formatDataList(_shippingList!);
    }
    if (_finishList == null) {
      _finishList = await getBuyerStatusApi(status: "finish");
      _finishList = formatDataList(_finishList!);
    }
    if (_canceledList == null) {
      _canceledList = await getBuyerStatusApi(status: "canceled");
      _canceledList = formatDataList(_canceledList!);
    }
    if (_returnList == null) {
      _returnList = await getBuyerStatusApi(status: "return");
      _returnList = formatDataList(_returnList!);
    }
    setState(() {
      _isLoading = false;
    });
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

  void resetOrderList() {
    setState(() {
      _allList = null;
      _pendingList = null;
      _deliveredList = null;
      _shippingList = null;
      _finishList = null;
      _canceledList = null;
      _returnList = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    // if (_returnList != null && _returnList!.isEmpty) {
    //   _returnList!.add(abc);
    // }
    // ignore: unrelated_type_equality_checks
    colorTheme = ThemeMode.dark == true
        ? Theme.of(context).cardColor
        : const Color(0xfff1f2f5);
    // ignore: unrelated_type_equality_checks
    Color colorWord = ThemeMode.dark == true
        ? white
        // ignore: unrelated_type_equality_checks
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
                  const AppBarTitle(title: "Danh sách đơn mua"),
                  GestureDetector(
                    onTap: () {
                      resetOrderList();
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
                _allList != null
                    ? _allList!.isNotEmpty
                        ? _buildAllBody()
                        : _buildEmptyMessageAndSuggestList()
                    : buildCircularProgressIndicator(),
                _pendingList != null
                    ? _pendingList!.isNotEmpty
                        ? _buildPendingBody()
                        : _buildEmptyMessageAndSuggestList()
                    : buildCircularProgressIndicator(),
                _deliveredList != null
                    ? _deliveredList!.isNotEmpty
                        ? _buildDeliveredBody()
                        : _buildEmptyMessageAndSuggestList()
                    : buildCircularProgressIndicator(),
                _shippingList != null
                    ? _shippingList!.isNotEmpty
                        ? _buildShippingBody()
                        : _buildEmptyMessageAndSuggestList()
                    : buildCircularProgressIndicator(),
                _finishList != null
                    ? _finishList!.isNotEmpty
                        ? _buildFinishBody()
                        : _buildEmptyMessageAndSuggestList()
                    : buildCircularProgressIndicator(),
                _canceledList != null
                    ? _canceledList!.isNotEmpty
                        ? _buildCancelBody()
                        : _buildEmptyMessageAndSuggestList()
                    : buildCircularProgressIndicator(),
                _returnList != null
                    ? _returnList!.isNotEmpty
                        ? _buildReturnBody()
                        : _buildEmptyMessageAndSuggestList()
                    : buildCircularProgressIndicator(),
              ],
            )));
  }

  Widget _buildAllBody() {
    return _buildOrderComponent(_allList!, _allScrollController);
  }

  Widget _buildPendingBody() {
    return _buildOrderComponent(_pendingList!, _pendingScrollController);
  }

  Widget _buildDeliveredBody() {
    return _buildOrderComponent(_deliveredList!, _deliveredScrollController);
  }

  Widget _buildShippingBody() {
    return _buildOrderComponent(_shippingList!, _shippingScrollController);
  }

  Widget _buildFinishBody() {
    return _buildOrderComponent(_finishList!, _finishScrollController,
        function: (dynamic orderItemData) {
      resetOrderList();
      pushToNextScreen(
          context,
          SuccessOrderPage(
            orderData: orderItemData,
          ));
    });
  }

  Widget _buildCancelBody() {
    return _buildOrderComponent(_canceledList!, _canceledScrollController);
  }

  Widget _buildReturnBody() {
    return _buildOrderComponent(_returnList!, _returnScrollController);
  }

  dynamic _getOrderCount(dynamic title) {
    switch (title) {
      case "all":
        return _allList != null && _allList!.isNotEmpty
            ? _allList!.length.toString()
            : "0";
      case "pending":
        return _pendingList != null && _pendingList!.isNotEmpty
            ? _pendingList!.length.toString()
            : "0";
      case "delivered":
        return _deliveredList != null && _deliveredList!.isNotEmpty
            ? _deliveredList!.length.toString()
            : "0";
      case "shipping":
        return _shippingList != null && _shippingList!.isNotEmpty
            ? _shippingList!.length.toString()
            : "0";
      case "finish":
        return _finishList != null && _finishList!.isNotEmpty
            ? _finishList!.length.toString()
            : "0";
      case "cancelled":
        return _canceledList != null && _canceledList!.isNotEmpty
            ? _canceledList!.length.toString()
            : "0";
      case "return":
        return _returnList != null && _returnList!.isNotEmpty
            ? _returnList!.length.toString()
            : "0";
      default:
        return "0";
    }
  }

  Widget _getStatus(dynamic status, {dynamic paymentStatus, dynamic data}) {
    Color wordColor = blackColor;
    String title = "";
    switch (status) {
      case "pending":
        wordColor = Colors.orange;
        if (paymentStatus == "unpaid") {
          title = "Chờ - Chưa thanh toán";
        } else if (paymentStatus == "paid") {
          title = "Chờ - Đã thanh toán";
        } else {
          title = "Chờ - ${paymentStatus}";
        }
        break;
      case "delivered":
        wordColor = Colors.grey;
        if (paymentStatus == "unpaid") {
          title = "Vận chuyển - chưa thanh toán";
        } else if (paymentStatus == "paid") {
          title = "Vận chuyển - Đã thanh toán";
        } else {
          title = "Vận chuyển - ${paymentStatus}";
        }
        break;
      case "shipping":
        wordColor = Colors.green;
        if (paymentStatus == "unpaid") {
          title = "Đang giao - chưa thanh toán";
        } else if (paymentStatus == "paid") {
          title = "Đang giao - Đã thanh toán";
        } else {
          title = "Đang giao - ${paymentStatus}";
        }
        break;
      case "finish":
        wordColor = Colors.blue;
        if (paymentStatus == "unpaid") {
          title = "Hoàn thành - chưa thanh toán";
        } else if (paymentStatus == "paid") {
          title = "Hoàn thành - đã thanh toán";
        } else {
          title = "Hoàn thành - ${paymentStatus}";
        }
        break;
      case "cancelled":
        wordColor = Colors.red;
        if (paymentStatus == "unpaid") {
          title = "Đã hủy - chưa thanh toán";
        } else if (paymentStatus == "paid") {
          title = "Đã hủy - đã thanh toán";
        } else {
          title = "Đã hủy - ${paymentStatus}";
        }
        break;
      case "return":
        wordColor = Colors.purple;
        if (paymentStatus == "unpaid") {
          title = "Trả hàng/ Hoàn tiền - chưa thanh toán";
        } else if (paymentStatus == "paid") {
          title = "Trả hàng/ Hoàn tiền - đã thanh toán";
        } else {
          title = "Trả hàng/ Hoàn tiền";
        }
        break;
      default:
        break;
    }
    return buildTextContent("$title ${data?['shipping_method_id'] ?? ""}", true,
        fontSize: 16, colorWord: wordColor);
  }

  Widget _buildOrderComponent(
    List<dynamic> dataList,
    ScrollController scrollController, {
    Function? function,
  }) {
    return dataList.isNotEmpty
        ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            controller: scrollController,
            itemCount: dataList.length,
            itemBuilder: (ctx, index) {
              final data = dataList[index];
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      if (function == null) {
                        resetOrderList();
                        switch (data['status']) {
                          case "shipping":
                            pushToNextScreen(
                                context,
                                TransferOrderPage(
                                  orderData: data['data'],
                                ));
                            return;
                          case "cancelled":
                            pushToNextScreen(
                                context,
                                CancelledReturnOrderPage(
                                  orderData: data['data'],
                                ));
                            return;
                          case "pending":
                          case "finish":
                          case "conplete":
                          case "delivered":
                          case "all":
                            pushToNextScreen(
                                context,
                                OrderInformationPage(
                                  orderData: data['data'],
                                ));
                            return;
                          case "return":
                            pushToNextScreen(
                                context,
                                CancelledReturnOrderPage(
                                  orderData: data['data'],
                                ));
                            return;
                          default:
                            return;
                        }
                      } else {
                        function(data[['data']]);
                      }
                    },
                    child: Column(children: [
                      index != 0 ? buildSpacer(height: 5) : const SizedBox(),
                      const CrossBar(
                        height: 7,
                        opacity: 0.2,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, right: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            //status
                            _getStatus(data["status"],
                                paymentStatus: data["payment_status"],
                                data: data['data'])
                          ],
                        ),
                      ),
                      buildDivider(color: greyColor),
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
                            return buildOrderItem(
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
                          margin: const EdgeInsets.only(
                              top: 5, right: 10, left: 10),
                          haveIcon: false,
                          contentBold: true),
                      buildDivider(color: greyColor, top: 5),
                      data['data']['status'] == "shipping"
                          ? _buildTransferStatus()
                          : const SizedBox(),
                      _buildButtons(data),
                    ]),
                  ),
                ],
              );
            })
        : Container(
            margin: const EdgeInsets.only(top: 60),
            child: buildTextContent("Bạn không có đơn hàng nào !!", false,
                isCenterLeft: false),
          );
  }

  Widget _buildEmptyMessageAndSuggestList() {
    return listSuggestProduct != null && listSuggestProduct!.isNotEmpty
        ? buildSuggestListComponent(
            context: context,
            controller: _suggestScrollController,
            isLoading: true,
            isLoadingMore: ref.watch(productsProvider).isMore,
            title: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 30),
                  child: buildTextContent("Bạn chưa có đơn hàng nào", false,
                      fontSize: 18, isCenterLeft: false),
                ),
                Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: Container(
                          color: greyColor,
                          width: width,
                          height: 1,
                        )),
                    buildTextContent("Có thể bạn cũng thích", false,
                        fontSize: 14),
                    Flexible(
                        flex: 1,
                        child: Container(
                          color: greyColor,
                          width: width,
                          height: 1,
                        )),
                  ],
                ),
                buildSpacer(height: 20)
              ],
            ),
            contentList: listSuggestProduct!)
        : Center(
            child: buildCircularProgressIndicator(),
          );
  }

  Widget _buildTransferStatus() {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 5, left: 10),
      child: Column(
        children: [
          Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Image.asset(
                      "assets/icons/chat_product_icon.png",
                      height: 18,
                      color: red,
                    ),
                    buildSpacer(width: 5),
                    Flexible(
                      child: buildTextContent(
                          "[VIETNAM]Đã điều phối giao hàng/ Đang giao hàng.",
                          false,
                          fontSize: 12,
                          colorWord: Colors.green),
                    )
                  ],
                ),
              ),
              buildTextContent(
                  DateFormat("hh:mm dd-MM-yyyy").format(DateTime.now()), false,
                  fontSize: 12, colorWord: greyColor)
            ],
          ),
          buildDivider(color: greyColor, top: 5),
        ],
      ),
    );
  }

  Widget buttonChangePaymentMethod(dynamic data, {double? buttonWidth}) {
    return buildMarketButton(
        width: buttonWidth ?? width * 0.9,
        height: 35,
        colorText: Theme.of(context).textTheme.bodyMedium!.color,
        contents: [
          buildTextContent("Đổi phương thức thanh toán", false, fontSize: 13)
        ],
        function: () async {
          resetOrderList();
          // push to new screen;
        });
  }

  Widget _buildButtons(dynamic data) {
    List<Widget> buttonList = [];
    switch (data["status"]) {
      case "pending":
        buttonList.add(data['payment_status'] == "unpaid"
            ? SizedBox(
                width: width * 0.6,
                child: buildTextContent(
                    "Thanh toán trước ngày ${DateFormat("dd-MM-yyyy HH:mm").format(DateTime.now())} bằng Tài khoản ngân hàng đã liên kết với ví ....",
                    false,
                    colorWord: greyColor,
                    fontSize: 13),
              )
            : const SizedBox());
        buttonList.add(data['payment_status'] == "unpaid"
            ? _buttonPayment(data)
            : const SizedBox());
        break;
      case "delivered":
        // buttonList.add(_buttonCancel(data));
        buttonList.add(Container(
          padding: const EdgeInsets.only(bottom: 15),
          width: width * 0.6,
          child: buildTextContent(
              "Đơn hàng sẽ được chuẩn bị và chuyển đi trước ${DateFormat("dd-MM-yyyy").format(DateTime.now())}",
              false,
              colorWord: greyColor,
              fontSize: 13),
        ));

        buttonList.add(_buttonContactWithSeller(data));
        break;
      case "shipping":
        buttonList.add(Container(
          padding: const EdgeInsets.only(bottom: 15),
          width: width * 0.6,
          child: buildTextContent(
              "Nhận sản phẩm và thanh toán muộn nhất vào ${DateFormat("dd-MM-yyyy").format(DateTime.now())}",
              false,
              colorWord: greyColor,
              fontSize: 13),
        ));
        buttonList.add(_buttonGotOrder(data));
        break;
      case "finish":
        // thoi gian ma hang duoi 1 thang(danh gia, mua lai)
        // tren 1 thang (xem shop,quan ly qua trinh van chuyen,lien he nguoi ban, mua lai)

        if (data['data']['finish_time'] != null) {
          bool isOneMonthAgo;
          DateTime currentDateTime = DateTime.now();
          DateTime finishTime = DateTime.parse(data['data']?['finish_time']);
          DateTime oneMonthAgo =
              currentDateTime.subtract(const Duration(days: 30));
          if (finishTime.isBefore(oneMonthAgo)) {
            isOneMonthAgo = true;
          } else {
            isOneMonthAgo = false;
          }
          if (isOneMonthAgo) {
            buttonList.add(_buttonRebuy(data));
            buttonList.add(_buttonContactWithSeller(data));
          }
        } else {
          buttonList.add(_buttonReview(data));
          buttonList.add(_buttonRebuy(data));
        }
        break;
      case "cancelled":
        buttonList.add(Container(
          padding: const EdgeInsets.only(bottom: 15),
          width: width * 0.6,
          child: buildTextContent("Đã hủy bởi bạn", false,
              colorWord: greyColor, fontSize: 13),
        ));
        buttonList.add(_buttonCancel(data));
        break;
      case "return":
        buttonList.add(const SizedBox());
        buttonList.add(_buttonReturn(data));
        break;
      default:
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: buttonList.length > 2
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: buttonList.sublist(0, 2),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: buttonList.sublist(2, buttonList.length),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: buttonList),
    );
  }

  Widget _buttonReturn(dynamic data, {double? buttonWidth}) {
    return buildMarketButton(
        width: buttonWidth ?? width * 0.49,
        bgColor: red,
        contents: [
          buildTextContent("Chi tiết trả hàng/hoàn tiền", false, fontSize: 13)
        ],
        function: () {});
  }

  Widget _buttonPayment(dynamic data, {double? buttonWidth}) {
    return buildMarketButton(
        width: buttonWidth ?? width * 0.3,
        contents: [buildTextContent("Thanh toán", false, fontSize: 13)],
        function: () {
          List listProduct = [];
          listProduct.add({
            "page_id": data['data']['page']['id'],
            "title": data['data']['page']['title'],
            "avatar_id": data['data']['page']['avatar_media'],
            "username": data['data']['page']['username'],
            "items": data['data']['order_items']
                .map((e) => {"check": true, ...e})
                .toList(),
          });
          pushToNextScreen(
              context,
              PaymentMarketPage(
                  productDataList: listProduct,
                  addressData: data['data']['delivery_address']));
        });
  }

  Widget _buttonContactWithSeller(dynamic data, {double? buttonWidth}) {
    return buildMarketButton(
        width: buttonWidth ?? width * 0.3,
        contents: [buildTextContent("Liên hệ", false, fontSize: 13)],
        bgColor: primaryColor,
        function: () {});
  }

  Widget _buttonCancel(dynamic data, {double? buttonWidth}) {
    return buildMarketButton(
        width: buttonWidth ?? width * 0.32,
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

  Widget _buttonRebuy(dynamic data, {double? buttonWidth}) {
    return buildMarketButton(
        width: buttonWidth ?? width * 0.3,
        contents: [buildTextContent("Mua lại", false, fontSize: 13)],
        bgColor: primaryColor,
        function: () {});
  }

  Widget _buttonReview(dynamic data, {double? buttonWidth}) {
    return buildMarketButton(
        width: buttonWidth ?? width * 0.3,
        contents: [buildTextContent("Đánh giá", false, fontSize: 13)],
        bgColor: primaryColor,
        function: () {
          resetOrderList();
          pushToNextScreen(
              context,
              ReviewProductMarketPage(
                reviewId: data["id"],
                completeProductList: data['data']["order_items"],
              ));
        });
  }

  Widget _buttonReviewShop(dynamic data, {double? buttonWidth}) {
    return buildMarketButton(
        width: buttonWidth ?? width * 0.31,
        contents: [buildTextContent("Đánh giá shop", false, fontSize: 13)],
        bgColor: primaryColor,
        function: () {
          resetOrderList();

          pushToNextScreen(
              context,
              SeeReviewShopMarketPage(
                reviewId: data["id"],
                reviewData: data["order_items"],
              ));
        });
  }

  Widget _buttonGotOrder(dynamic data, {double? buttonWidth}) {
    return buildMarketButton(
        width: buttonWidth ?? width * 0.3,
        contents: [buildTextContent("Đã nhận hàng", false, fontSize: 13)],
        bgColor: primaryColor,
        function: () async {
          setState(() {
            _isLoading = true;
          });
          data["status"] = "finish";
          setState(() {
            _isLoading = false;
          });
          final response = await OrderApis().postBuyerVerifyOrderApi(
              data['data']["id"], {"status": "finish"});
        });
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
      EdgeInsets? margin =
          const EdgeInsets.only(top: 10, left: 10, right: 10)}) {
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
}
