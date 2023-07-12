import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/constant/marketPlace_constants.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';

Widget iconAndAddImage(String title, {Function? function}) {
  return InkWell(
    onTap: () {
      function != null ? function() : null;
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "${MarketPlaceConstants.PATH_ICON}add_img_file_icon.svg",
          height: 20,
        ),
        buildSpacer(width: 5),
        buildTextContent(title, false, isCenterLeft: false, fontSize: 15),
      ],
    ),
  );
}
