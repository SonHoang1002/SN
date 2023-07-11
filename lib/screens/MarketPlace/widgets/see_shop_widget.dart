import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/divider_widget.dart';
import 'package:market_place/widgets/GeneralWidget/spacer_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/cross_bar.dart';

/// Transfer order data
///
/// Include two part: shop name (page name) and button see shop
buildSeeShopWidget(BuildContext context, dynamic data) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: buildTextContent(data['page']['title'], true,
                  fontSize: 14, overflow: TextOverflow.ellipsis, maxLines: 1),
            ),
            GestureDetector(
              onTap: () {
                // push to see shop screen
              },
              child: Row(
                children: [
                  buildTextContent(
                    "Xem shop",
                    true,
                    fontSize: 15,
                  ),
                  buildSpacer(width: 5),
                  Icon(
                    FontAwesomeIcons.chevronRight,
                    size: 12,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  )
                ],
              ),
            )
          ],
        ),
      ),
      buildSpacer(height: 7)
    ],
  );
}
