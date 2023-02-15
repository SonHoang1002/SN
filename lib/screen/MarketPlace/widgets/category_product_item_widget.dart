import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';

Widget buildCategoryProductItemWidget(String title, String imgPath,
    {double height = 100, double? width}) {
  return Container(
    height: height,
    width: width ?? null,
    margin: const EdgeInsets.only(
      bottom: 10,
    ),
    padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: greyColor, width: 0.6)),
    child: Column(
      children: [
        Container(
            height: 40,
            width: 40,
            // color: red,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(imgPath))),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child:
              buildTextContent(title, true, fontSize: 13, isCenterLeft: false),
        )
      ],
    ),
  );
}
