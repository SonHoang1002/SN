import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/market_place_apis/order_product_apis.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/show_message_dialog_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_button.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

import '../../../../widget/back_icon_appbar.dart';
import '../../../helper/push_to_new_screen.dart';
import 'notification_market_page.dart';

class ManageOrderMarketPage extends ConsumerStatefulWidget {
  const ManageOrderMarketPage({super.key});
  @override
  ConsumerState<ManageOrderMarketPage> createState() =>
      _ManageOrderMarketPageState();
}

List<Map<String, dynamic>> actionList = [
  {"key": "pending", "title": "Chuẩn bị hàng"},
  {"key": "shipping", "title": "Đang giao"},
  {"key": "delivered", "title": "Đã nhận hàng"},
  {"key": "finish", "title": "Hoàn thành"},
];
List<Map<String, dynamic>> nextActionList = [
  {"key": "pending", "title": "Đang giao"},
  {"key": "shipping", "title": "Đã giao"},
];

class _ManageOrderMarketPageState extends ConsumerState<ManageOrderMarketPage> {
  late double width = 0;
  late double height = 0;
  List<dynamic>? _orderData;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.wait([_initManageOrder()]);
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
    Future.wait([_initManageOrder()]);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackIconAppbar(),
              const AppBarTitle(title: "Quản lý đơn hàng"),
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
                  !_isLoading
                      ? _orderData!.isEmpty
                          ? Center(
                              child: buildTextContent(
                                  "Bạn chưa có đơn hàng nào !!", true,
                                  fontSize: 19, isCenterLeft: false),
                            )
                          : _buildManageOrderComponent()
                      : buildCircularProgressIndicator()
                ],
              ),
            ),
          ],
        ));
  }

  Future _initManageOrder() async {
    if (_orderData == null || _orderData!.isEmpty) {
      _orderData = await OrderApis().getOrderApi();
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildManageOrderComponent() {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: DataTable(
            showBottomBorder: true,
            columns: const [
              DataColumn(
                  label: Text('Sản phẩm',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Số lượng',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Tổng đơn hàng',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Trạng thái',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Đơn vị vận chuyển',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Thao tác',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
            ],
            rows: _buildDataRow()),
      ),
    );
  }

  List<DataRow> _buildDataRow() {
    List<DataRow> dataRowList = [];
    for (int i = 0; i < _orderData!.length; i++) {
      dataRowList.add(
        DataRow(cells: [
          DataCell(Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: ImageCacheRender(
                  height: 30.0,
                  width: 30.0,
                  path:
                      "https://snapi.emso.asia/system/media_attachments/files/109/583/844/336/412/733/original/3041cb0fcfcac917.jpeg",
                ),
              ),
              buildSpacer(width: 5),
              buildTextContent(
                  _orderData![i]["delivery_address"] != null
                      ? _orderData![i]["delivery_address"]["name"]
                      : "nguoi vo danh",
                  true),
            ],
          )),
          const DataCell(SizedBox()),
          const DataCell(SizedBox()),
          const DataCell(SizedBox()),
          const DataCell(SizedBox()),
          DataCell(Row(
            children: [
              buildTextContent("Mã đơn hàng: ", false, isItalic: true),
              buildTextContent("${_orderData![i]["id"]}", true, isItalic: true),
            ],
          )),
        ]),
      );

      for (int j = 0; j < _orderData![i]["order_items"].length; j++) {
        dataRowList.add(
          DataRow(cells: [
            DataCell(
              Text(
                _orderData![i]["order_items"][j]["product_variant"]["title"],
                overflow: TextOverflow.ellipsis,
                maxLines: 100,
              ),
            ),
            DataCell(Text("x${_orderData![i]["order_items"][j]["quantity"]}")),
            DataCell(j == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_orderData![i]["order_total"].toString()),
                      buildSpacer(height: 5),
                      Text(_orderData![i]["shipping_method_id"].toString()),
                    ],
                  )
                : const SizedBox()),
            DataCell(j == 0
                ? buildTextContent(
                    _orderData![i]["payment_status"] == "paid"
                        ? "Đã thanh toán"
                        : "Chờ thanh toán",
                    true,
                    fontSize: 16)
                : const SizedBox()),
            DataCell(j == 0 ? const Text("ExpressVN") : const SizedBox()),
            DataCell(j == 0
                ? _checkActionWidget(_orderData![i]["status"], i)
                : const SizedBox()),
          ]),
        );
      }
    }
    return dataRowList;
  }

  Widget _checkActionWidget(dynamic key, int index) {
    String value = "";
    Color wordColor = Colors.black87;
    List<Map<String, dynamic>> actionList = [
      {"key": "pending", "title": "Chuẩn bị hàng"},
      {"key": "shipping", "title": "Đang giao"},
      {"key": "delivered", "title": "Đã giao"},
      {"key": "finish", "title": "Hoàn thành"},
      {"key": "cancelled", "title": "Đã hủy"},
      {"key": "return", "title": "Trả lại"},
    ];
    switch (key) {
      case "pending":
        value = actionList[0]["title"];
        // wordColor = Colors.yellow;
        break;
      case "shipping":
        value = actionList[1]["title"];
        // wordColor = Colors.grey;

        break;
      case "delivered":
        value = actionList[2]["title"];
        // wordColor = Colors.orange;

        break;
      case "finish":
        value = actionList[3]["title"];
        // wordColor = Colors.yellow;

        break;
      case "cancelled":
        value = actionList[4]["title"];
        wordColor = Colors.red;

        break;
      case "return":
        value = actionList[5]["title"];
        wordColor = Colors.purple;

        break;
      default:
        value = key;
        break;
    }
    return buildTextContentButton(value, true,
        colorWord: wordColor, fontSize: 19, function: () {
      _showMessage(_orderData![index]["status"], index);
    });
  }

  String _changeActionValue(dynamic key, int index) {
    switch (key) {
      case "pending":
        return nextActionList[0]["title"];
      case "shipping":
        return nextActionList[1]["title"];
      default:
        return "none";
    }
  }

  _changeStatus(dynamic key, int index) async {
    String nextStatus = "";
    if (key == "pending") {
      nextStatus = "shipping";
      _orderData![index]["status"] = nextStatus;
      setState(() {});
      final response = await OrderApis().updateStatusOrderApi(
          _orderData![index]["id"], {"status": nextStatus});
    }
    if (key == "shipping") {
      nextStatus = "delivered";
      _orderData![index]["status"] = nextStatus;
      setState(() {});
      final response = await OrderApis().updateStatusOrderApi(
          _orderData![index]["id"], {"status": nextStatus});
    }
    setState(() {});
  }

  _showMessage(dynamic key, int index) {
    if (key == "pending" || key == "shipping") {
      final nextStatus = _changeActionValue(key, index);
      buildMessageDialog(context, "Xác nhận chuyển trạng thái ${nextStatus}",
          oKFunction: () async {
        popToPreviousScreen(context);
        await _changeStatus(key, index);
      });
    }
  }
}
