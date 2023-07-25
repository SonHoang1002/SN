import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/voucher_widget.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';

Widget buildReviewShop(BuildContext context, dynamic pageData) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 10,
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: const ImageCacheRender(
                    path:
                        'https://thumbs.dreamstime.com/z/meat-store-badges-logos-labels-any-use-example-to-design-your-58408646.jpg',
                    height: 60.0,
                    width: 60.0,
                  ),
                ),
                buildSpacer(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.5,
                      child: buildTextContent(pageData?['title'] ?? "--", false,
                          fontSize: 14,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    buildSpacer(height: 5),
                    buildTextContent(pageData?['online'] ?? "Online", false,
                        fontSize: 14,
                        colorWord:
                            pageData?['online'] != null ? Colors.green : red),
                    buildSpacer(height: 5),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.mapLocation,
                          size: 13,
                        ),
                        buildSpacer(width: 5),
                        buildTextContent(
                            pageData?['location']?['title'] ?? "Hà Nội", false,
                            fontSize: 14),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(width: 100, child: buildSingleButton(context, "Xem Shop")),
          ],
        ),
        buildSpacer(height: 10),
        Row(
          children: [
            _buildDescription(100, "sản phẩm"),
            buildSpacer(width: 15),
            _buildDescription(4.8, "đánh giá"),
            buildSpacer(width: 15),
            _buildDescription('96%', "phản hồi chat"),
          ],
        ),
        buildSpacer(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          child: buildNonImageVoucherWidget(
              "Giảm 6%",
              "Đơn tối thiểu ₫${formatCurrency(120000)}. Giảm tối da ₫${formatCurrency(12000088)}",
              DateFormat("dd-MM-yyyy").format(DateTime.now())),
        ),
        buildSpacer(height: 10),
        buildTextContent("* Áp dụng cho tất cả sản phẩm của Shop", false,
            colorWord: greyColor, fontSize: 13)
      ],
    ),
  );
}

Widget buildSingleButton(BuildContext context, String title,
    {double? width, Function? function}) {
  return GestureDetector(
    onTap: () {
      function != null ? function() : null;
    },
    child: Container(
      width: width ?? MediaQuery.sizeOf(context).width * 0.43,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: greyColor, width: 0.4),
        borderRadius: BorderRadius.circular(4),
      ),
      child: buildTextContent(title, false, fontSize: 13, isCenterLeft: false),
    ),
  );
}

Widget _buildDescription(dynamic count, String title) {
  return Row(
    children: [
      buildTextContent(
        count.toString(),
        false,
        fontSize: 12,
        colorWord: red,
      ),
      buildSpacer(width: 5),
      buildTextContent(
        title,
        false,
        fontSize: 12,
      ),
    ],
  );
}
