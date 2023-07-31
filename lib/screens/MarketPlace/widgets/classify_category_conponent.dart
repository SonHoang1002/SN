import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/providers/market_place_providers/products_provider.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'product_item_widget.dart';

Widget buildSuggestListComponent(
    {required BuildContext context,
    required Widget title,
    required List<dynamic> contentList,
    Function? titleFunction,
    ScrollController? controller,
    Axis? axis = Axis.vertical,
    bool? isLoading = false,
    bool? isLoadingMore = false}) {
  final width = MediaQuery.sizeOf(context).width;
  final height = MediaQuery.sizeOf(context).height;

  return axis == Axis.vertical
      ? SingleChildScrollView(
          controller: controller,
          scrollDirection: axis!,
          child: Column(
            children: [
              title,
              GridView.builder(
                  scrollDirection: axis,
                  padding: const EdgeInsets.only(top: 10, left: 7),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 6,
                      crossAxisCount: 2,
                      childAspectRatio: height > 800
                          ? 0.75
                          : (width / (height - 190) > 0
                              ? width / (height - 275)
                              : 0.81)),
                  itemCount: contentList.length,
                  itemBuilder: (context, index) {
                    return buildProductItem(
                        context: context, data: contentList[index]);
                  }),
              _buildLoadingWidget(isLoadingMore, isLoading)
            ],
          ))
      : Column(
          children: [
            title,
            buildSpacer(height: 10),
            SizedBox(
              height: 250,
              width: width,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: contentList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            buildProductItem(
                              context: context,
                              data: contentList[index],
                              // isHaveFlagship: true,
                              // saleBanner: {}
                            ),
                            axis == Axis.horizontal &&
                                    index == contentList.length - 1
                                ? _buildLoadingWidget(isLoadingMore, isLoading)
                                : const SizedBox()
                          ],
                        ));
                  }),
            ),
          ],
        );
}

_buildLoadingWidget(bool? isLoadingMore, bool? isLoading) {
  return isLoadingMore!
      ? isLoading!
          ? buildCircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              child: buildTextContent("Đã hết sản phẩm gợi ý hôm nay rồi", true,
                  isCenterLeft: false),
            )
      : const SizedBox();
}
