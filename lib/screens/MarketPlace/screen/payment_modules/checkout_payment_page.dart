import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/providers/market_place_providers/products_provider.dart';
import 'package:market_place/screens/MarketPlace/screen/buyer_orders/my_order_page_1.dart';
import 'package:market_place/screens/MarketPlace/screen/main_market_page.dart';
import 'package:market_place/screens/MarketPlace/widgets/cart_widget.dart';
import 'package:market_place/screens/MarketPlace/widgets/classify_category_conponent.dart';
import 'package:market_place/screens/MarketPlace/widgets/voucher_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/cross_bar.dart';

import 'package:market_place/helpers/routes.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';

import '../../../../theme/colors.dart';

class CheckoutPaymentPage extends ConsumerStatefulWidget {
  final dynamic paymentKey;
  const CheckoutPaymentPage({required this.paymentKey, super.key});

  @override
  ConsumerState<CheckoutPaymentPage> createState() =>
      _CheckoutPaymentPageState();
}

class _CheckoutPaymentPageState extends ConsumerState<CheckoutPaymentPage> {
  late double width = 0;
  late double height = 0;
  // Trong đó shipping_method_id : 0 -> COD, 1 -> ECOIN
  bool? isCodMethod;

  Future _initData() async {
    if (isCodMethod == null) {
      if (widget.paymentKey == 0) {
        isCodMethod = true;
      } else {
        isCodMethod = false;
      }
      setState(() {});
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
            children: [const BackIconAppbar(), CartWidget()],
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(children: [
                _buildTitle(),
                buildSpacer(height: 20),
                buildTextContent(
                    'Cùng Emso bảo vệ quyền lợi của bạn - Thường xuyên kiểm tra tin nhắn từ Người bán tại Emso Chat/ Chỉ nhận và thanh toán khi đơn hàng ở trạng thái "Đang giao hàng"',
                    false,
                    isCenterLeft: false,
                    fontSize: 11),
                buildSpacer(height: 30),
                _buildButtons(),
              ]),
            ),
            buildSpacer(height: 10),
            const CrossBar(
              height: 5,
            ),
            buildSpacer(height: 20),
            buildTextContent("Tặng bạn mã giảm giá cao cấp", true,
                fontSize: 18, isCenterLeft: false),
            buildSpacer(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: buildVoucherWidget(),
            ),
            buildSpacer(height: 10),
            const CrossBar(
              height: 5,
            ),
            buildSpacer(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: buildClassifyCategoryComponent(
                  context: context,
                  title: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
                          flex: 1,
                          child: Container(
                            color: greyColor,
                            width: width,
                            height: 1,
                          )),
                      Flexible(
                        flex: 2,
                        child: buildTextContent("Có thể bạn cũng thích", false,
                            fontSize: 13, isCenterLeft: false),
                      ),
                      Flexible(
                          flex: 1,
                          child: Container(
                            color: greyColor,
                            width: width,
                            height: 1,
                          ))
                    ],
                  ),
                  contentList: ref.watch(productsProvider).list),
            )
          ],
        )));
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          FontAwesomeIcons.thumbsUp,
          size: 16,
        ),
        buildSpacer(width: 10),
        isCodMethod!
            ? buildTextContent("Đang chờ thanh toán", true, fontSize: 18)
            : buildTextContent("Thanh toán thành công", true, fontSize: 18),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSingleButton("Trang chủ", function: () {
          pushAndReplaceToNextScreen(context, const MainMarketPage());
        }),
        buildSpacer(width: 10),
        _buildSingleButton("Đơn mua", function: () {
          pushAndReplaceToNextScreen(context, const MyOrderPage1());
        })
      ],
    );
  }

  Widget _buildSingleButton(String title, {Function? function}) {
    return GestureDetector(
      onTap: () {
        function != null ? function() : null;
      },
      child: Container(
        width: width * 0.43,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: greyColor, width: 0.4),
          borderRadius: BorderRadius.circular(4),
        ),
        child:
            buildTextContent(title, false, fontSize: 17, isCenterLeft: false),
      ),
    );
  }
}
