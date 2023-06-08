import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';

Widget buildTitleAndSeeAll(String title,
    {Widget? suffixWidget, IconData? iconData}) {
  return Container(
    margin: const EdgeInsets.only(
      bottom: 10,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildTextContent(
          title,
          true,
          fontSize: 17,
        ),
        Row(
          children: [
            suffixWidget ?? const SizedBox(),
            buildSpacer(width: 5),
            iconData != null
                ? Icon(
                    iconData,
                    color: greyColor,
                    size: 14,
                  )
                : const SizedBox()
          ],
        ),
      ],
    ),
  );
}
