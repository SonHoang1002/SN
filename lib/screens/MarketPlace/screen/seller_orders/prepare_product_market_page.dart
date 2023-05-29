import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/screens/MarketPlace/screen/notification_market_page.dart';
import 'package:market_place/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:market_place/screens/MarketPlace/widgets/market_button_widget.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/information_component_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';

import '../../../../theme/colors.dart';

class PrepareProductMarketPage extends ConsumerStatefulWidget {
  const PrepareProductMarketPage({
    super.key,
    // this.address
  });

  @override
  ConsumerState<PrepareProductMarketPage> createState() =>
      _PrepareProductMarketPageState();
}

class _PrepareProductMarketPageState
    extends ConsumerState<PrepareProductMarketPage> {
  late double width = 0;
  late double height = 0;
  bool _isLoading = true;
  dynamic address = {
    "id": "7",
    "name": "Khúc Phát",
    "phone_number": "0884465874",
    "addresses": "Hoàng Mai, Hai Bà Trưng, Hà Nội",
    "detail_addresses": "180 Hoàng Mai",
    "address_type": "home",
    "address_default": true,
    "location": {"lat": 22.2872717, "lng": 105.6157884}
  };
  @override
  void initState() {
    super.initState();
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
    _isLoading = false;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  popToPreviousScreen(context);
                },
                child: Icon(
                  FontAwesomeIcons.chevronLeft,
                  color: Theme.of(context).textTheme.displayLarge!.color,
                ),
              ),
              const AppBarTitle(text: "Chuẩn bị hàng"),
              GestureDetector(
                onTap: () async {
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
        body: Stack(
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: _isLoading
                    ? buildCircularProgressIndicator()
                    : Column(
                        children: [_buildPrepareBody()],
                      ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  width: width,
                  child: buildMarketButton(
                    contents: [
                      buildTextContent("Xác nhận", false, fontSize: 13)
                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Widget _buildPrepareBody() {
    return Column(
      children: [
        GeneralComponent(
          [
            buildTextContent("Lấy hàng", true, fontSize: 17),
          ],
          prefixWidget: const Flexible(
            flex: 2,
            child: Icon(
              FontAwesomeIcons.cartPlus,
              size: 18,
            ),
          ),
          changeBackground: transparent,
          isHaveBorder: false,
          padding: EdgeInsets.zero,
        ),
        buildSpacer(height: 7),
        GeneralComponent(
          [
            buildTextContent(
                "Shoppe Express Instant sẽ đến lấy hàng theo địa chỉ lấy hàng mà bạn đã xác nhận",
                false,
                fontSize: 14),
          ],
          prefixWidget: const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: SizedBox(),
          ),
          suffixWidget: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(
                FontAwesomeIcons.check,
                size: 18,
                color: red,
              ),
              SizedBox()
            ],
          ),
          changeBackground: transparent,
          isHaveBorder: false,
          padding: EdgeInsets.zero,
        ),
        GeneralComponent(
          [
            buildSpacer(height: 20),
            buildTextContent("Địa chỉ lấy hàng", false, fontSize: 17),
            buildSpacer(height: 10),
            buildTextContent(address["name"], false, fontSize: 13),
            buildSpacer(height: 7),
            buildTextContent(address["phone_number"], false, fontSize: 13),
            buildSpacer(height: 7),
            buildTextContent(
                address["detail_addresses"] + ", " + address["addresses"],
                false,
                fontSize: 13),
            buildSpacer(height: 7),
            buildDivider(color: greyColor),
            buildSpacer(height: 7),
            InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildTextContent(
                    "Chọn vị trí",
                    false,
                  ),
                  const Icon(
                    FontAwesomeIcons.locationArrow,
                    size: 20,
                    color: red,
                  ),
                ],
              ),
            )
          ],
          prefixWidget: const Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: SizedBox(),
          ),
          changeBackground: transparent,
          isHaveBorder: false,
          padding: EdgeInsets.zero,
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          height: 150,
          width: width,
          color: greyColor,
          child: buildTextContent("Bản đồ ở đây", false,
              isCenterLeft: false, fontSize: 12),
        )
      ],
    );
  }
}
