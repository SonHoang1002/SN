import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/get_min_max_price.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/screen/detail_product_page.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/rating_star_widget.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';

class PostProduct extends StatefulWidget {
  final dynamic post;
  final dynamic type;
  const PostProduct({Key? key, this.post, this.type}) : super(key: key);

  @override
  State<PostProduct> createState() => _PostProductState();
}

class _PostProductState extends State<PostProduct> {
  bool isScrollToLimit = true;
  dynamic product;
  @override
  void initState() {
    super.initState();
    product = widget.post['shared_product'];
  }

  @override
  Widget build(BuildContext context) {
    product ??= widget.post['shared_product'];
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        widget.type != 'edit_post' ? null : null;
        pushCustomCupertinoPageRoute(
            context,
            DetailProductMarketPage(
              simpleData: product,
              id: product['id'],
            ));
      },
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          SizedBox(
              height: 250,
              child: buildCarousel(
                product["product_image_attachments"],
              )),
          Container(
              width: size.width,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background),
              child: Row(
                children: [
                  SizedBox(
                    width: size.width - 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextContent(
                          "${(product["page"]?["title"]) ?? ""}",
                          false,
                          fontSize: 13,
                          maxLines: 1,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        buildTextContent(
                          product?['title'] ?? "",
                          true,
                          fontSize: 15,
                          maxLines: 2,
                          fontWeight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }

  Widget buidlFlexWidget(dynamic product, Size size) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Flexible(
            flex: 1,
            child: ExtendedImage.network(
              (product['product_image_attachments']?[0]['attachment']
                      ?['url']) ??
                  (product['product_image_attachments']?[0]['attachment']
                      ?['preview_url']) ??
                  linkBannerDefault,
              height: 250,
              width: size.width,
              fit: BoxFit.cover,
            )),
        Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildTextContent(
                    product['title'],
                    true,
                    fontSize: 15,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                  buildSpacer(height: 10),
                  buildTextContent(
                    "${getMinAndMaxPrice(product['product_variants'])[0].toString()}₫ - ${getMinAndMaxPrice(product['product_variants'])[1].toString()}₫",
                    true,
                    fontSize: 16,
                    colorWord: red,
                  ),
                  buildSpacer(height: 10),
                  Row(
                    children: [
                      buildRatingStarWidget(product["rating"]),
                      buildTextContent(
                        "(${product['rating_count']} đánh giá)",
                        true,
                        fontSize: 13,
                      ),
                    ],
                  )
                ],
              ),
            )),
      ],
    );
  }

  Widget buildCarousel(
    List imageList,
  ) {
    final size = MediaQuery.sizeOf(context);
    return imageList.length == 1
        ? ExtendedImage.network(
            (imageList[0]['attachment']?['url']) ??
                (imageList[0]['attachment']?['preview_url']) ??
                linkBannerDefault,
            height: 250,
            width: size.width,
            fit: BoxFit.cover,
          )
        : CarouselSlider(
            items: imageList.map((child) {
              int index = imageList.indexOf(child);
              return Container(
                height: 250,
                width: 250,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                    border: Border.all(color: greyColor, width: 0.3)),
                child: ExtendedImage.network(
                  imageList[index]['attachment']?['preview_url'] ??
                      linkBannerDefault,
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
            options: CarouselOptions(
                padEnds: !isScrollToLimit,
                // enlargeStrategy:CenterPageEnlargeStrategy.zoom,
                enableInfiniteScroll: false,
                viewportFraction: 0.65,
                height: 250,
                scrollPhysics: const BouncingScrollPhysics(),
                onPageChanged: (value, reason) {
                  if (value == 0 || value == imageList.length) {
                    setState(() {
                      isScrollToLimit = true;
                    });
                    return;
                  }
                  if (isScrollToLimit) {
                    isScrollToLimit = false;
                  }
                }),
          );
  }
}
