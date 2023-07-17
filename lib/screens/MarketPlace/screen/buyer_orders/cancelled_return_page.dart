import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:market_place/constant/common.dart';
import 'package:market_place/helpers/format_currency.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/screens/MarketPlace/screen/buyer_orders/information_order_page.dart';
import 'package:market_place/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/order_item_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/see_shop_widget.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/cross_bar.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import '../../../../theme/colors.dart';
import '../../../../widgets/messenger_app_bar/app_bar_title.dart';

class CancelledReturnOrderPage extends ConsumerStatefulWidget {
  final dynamic orderData;
  const CancelledReturnOrderPage({super.key, required this.orderData});

  @override
  ConsumerState<CancelledReturnOrderPage> createState() =>
      _CancelledReturnOrderPageState();
}

class _CancelledReturnOrderPageState
    extends ConsumerState<CancelledReturnOrderPage> {
  late double width = 0;
  late double height = 0;
  String timeMessage = "";

  Future _initData() async {}
  @override
  void initState() {
    super.initState();
    if ((widget.orderData?['cancelled_time']) != null) {
      timeMessage = DateFormat("hh-mm dd-MM-yyyy")
          .format(DateTime.parse((widget.orderData['cancelled_time'])));
    } else {
      timeMessage = DateFormat("hh-mm dd-MM-yyyy").format(DateTime.now());
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
              AppBarTitle(
                  title: widget.orderData['status'] == "cancelled"
                      ? "Chi tiết đơn hủy"
                      : "Chi tiết Trả hàng/Hoàn tiền"),
              const SizedBox()
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              // padding: const EdgeInsets.only(top: 10),
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildDivider(
                color: greyColor,
              ),
              GeneralComponent([
                buildTextContent(
                    widget.orderData['status'] == "cancelled"
                        ? "Đã hủy đơn hàng"
                        : "Đã hoàn tiền",
                    true,
                    fontSize: 15,
                    colorWord: red),
                buildSpacer(height: 10),
                widget.orderData['status'] == "cancelled"
                    ? buildTextContent(
                        "vào lúc  $timeMessage",
                        false,
                        fontSize: 13,
                      )
                    : const SizedBox(),
                widget.orderData['status'] == "return"
                    ? buildTextContent(
                        "Yêu cầu hoàn tiền được chấp nhận. Chúng tôi sẽ hoàn ${calculateTotalMoney()} vào ví VNPAY của bạn trong vòng 24 giờ",
                        false,
                        fontSize: 13,
                      )
                    : const SizedBox(),
              ],
                  suffixFlexValue: 8,
                  suffixWidget: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Image.asset(
                      "assets/icons/check_circle_icon.png",
                      height: 30.0,
                      width: 30.0,
                    ),
                  ),
                  changeBackground: transparent),
              buildSpacer(height: 3),
              const CrossBar(
                height: 7,
                opacity: 0.2,
                margin: 0,
              ),
              buildSpacer(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTextContent("LỊCH SỬ CHAT VỚI CHÚNG TÔI", false,
                        fontSize: 15),
                    Icon(
                      FontAwesomeIcons.chevronRight,
                      size: 12,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    )
                  ],
                ),
              ),
              buildSpacer(height: 10),
              const CrossBar(
                height: 7,
                opacity: 0.2,
                margin: 0,
              ),
              buildSpacer(height: 10),
              buildSeeShopWidget(context, widget.orderData),
              buildDivider(color: greyColor, bottom: 5),
              Column(
                children: List.generate(
                  widget.orderData["order_items"].length,
                  (index) {
                    return buildOrderItem(
                        widget.orderData["order_items"][index]);
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    widget.orderData['status'] == "cancelled"
                        ? _buildBetweenWidget("Yêu cầu bởi", "Người mua")
                        : const SizedBox(),
                    widget.orderData['status'] == "cancelled"
                        ? _buildBetweenWidget("Yêu cầu vào", timeMessage)
                        : const SizedBox(),
                    widget.orderData['status'] == "cancelled"
                        ? _buildBetweenWidget("Lý do",
                            "https://snapi.emso.asia/api/v1/accounts/108786718361607198/statuses")
                        : const SizedBox(),
                    widget.orderData['status'] == "cancelled"
                        ? _buildBetweenWidget(
                            "Phương thức thanh toán",
                            buildPaymentMessage(
                                widget.orderData['payment_status'],
                                widget.orderData['shipping_method_id']))
                        : const SizedBox(),
                    widget.orderData['status'] == "return"
                        ? _buildBetweenWidget(
                            "Số tiền hoàn lại", calculateTotalMoney())
                        : const SizedBox(),
                    widget.orderData['status'] == "return"
                        ? _buildBetweenWidget(
                            "Hoàn tiền vào",
                            buildReturnWalletTitle(
                                widget.orderData['shipping_method_id']))
                        : const SizedBox(),
                    widget.orderData['status'] == "return"
                        ? _buildBetweenWidget(
                            "Thời gian chấp nhận trả hàng/hoàn tiền",
                            timeMessage)
                        : const SizedBox(),
                    widget.orderData['status'] == "return"
                        ? _buildBetweenWidget("Mã trả hàng", "S343434SDRFS")
                        : const SizedBox(),
                    widget.orderData['status'] == "return"
                        ? _buildBetweenWidget(
                            "Lý do trả hàng", "Thiết lập nhầm địa chỉ")
                        : const SizedBox(),
                  ],
                ),
              ),
              widget.orderData['status'] != "cancelled"
                  ? buildMarketButton(
                      width: width * 0.9,
                      height: 20,
                      bgColor: transparent,
                      isHaveBoder: true,
                      contents: [
                        buildTextContent(
                          "Chi tiết đơn hàng",
                          false,
                          fontSize: 13,
                          colorWord:
                              Theme.of(context).textTheme.bodyMedium!.color,
                        )
                      ],
                      function: () async {
                        pushToNextScreen(
                            context,
                            OrderInformationPage(
                              orderData: widget.orderData,
                            ));
                      })
                  : const SizedBox()
            ],
          )),
        ));
  }

  String calculateTotalMoney() {
    double total = 0;
    for (var child in widget.orderData['order_items']) {
      total += child['quantity'] * child['product_variant']['price'];
    }

    return "₫${formatCurrency(total)}";
  }

  String buildPaymentMessage(paymentStatus, shippingMethodStatus) {
    String message = '';
    if (paymentStatus == "unpaid") {
      message = "Chưa thanh toán";
    } else {
      switch (shippingMethodStatus) {
        case cod:
          message = "Thanh toán khi nhận hàng";
          break;
        case vnpay:
          message = "Thanh toán qua VNPAY";
          break;
        case vtcpay:
          message = "Thanh toán qua VTCPAY";
          break;
        case momo:
          message = "Thanh toán qua MOMO";
          break;
        default:
          break;
      }
    }
    return message;
  }

  String buildReturnWalletTitle(shippingMethodStatus) {
    String message = "Ví VNPAY";

    switch (shippingMethodStatus) {
      case cod:
        message = "Ví VNPAY";
        break;
      case vnpay:
        message = "Ví VNPAY";
        break;
      case vtcpay:
        message = "Ví VTCPAY";
        break;
      case momo:
        message = "Ví MOMO";
        break;
      default:
        break;
    }

    return message;
  }

  Widget _buildBetweenWidget(String title, String content) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTextContent(title, false, fontSize: 13, colorWord: greyColor),
          buildSpacer(width: 10),
          Flexible(
            child: Text(
              content,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: greyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
