import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';

buildPrepareProductWidget() {
  return Container(
    color: greyColor,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    margin: const EdgeInsets.only(bottom: 10),
    child: Flex(
      direction: Axis.horizontal,
      children: [
        Flexible(
          flex: 6,
          child: Column(
            children: [
              buildTextContent("Đang chuẩn bị hàng", true,
                  fontSize: 17, colorWord: white),
              buildSpacer(height: 10),
              buildTextContent(
                  "Đơn hàng sẽ được giao cho đơn vị vận chuyển trước ngày ${DateFormat("dd-MM-yyyy").format(DateTime.now().add(const Duration(days: 2)))}. Bạn có thể kiểm tra hàng sau khi thanh toán",
                  false,
                  colorWord: white,
                  fontSize: 15),
            ],
          ),
        ),
        const Flexible(
          child: Icon(
            FontAwesomeIcons.bus,
            size: 25,
            color: primaryColor,
          ),
        )
      ],
    ),
  );
}
