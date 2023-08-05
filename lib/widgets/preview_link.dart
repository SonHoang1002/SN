import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';

class PreviewLink extends StatelessWidget {
  dynamic detailData;
  final bool showImage;
  PreviewLink({required this.detailData, required this.showImage, super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    detailData = detailData[0];
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        width: size.width,
        child: Column(
          children: [
            showImage
                ? detailData != null && detailData["url"] != null
                    ? ImageCacheRender(
                        path: detailData["url"],
                        height: 200.0,
                        width: size.width,
                      )
                    : const SizedBox()
                : const SizedBox(),
            Container(
              color: Colors.grey.withOpacity(0.2),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width - 80,
                        child: Text(
                          detailData["title"] != ""
                              ? detailData["title"]
                              : (detailData["link"].split("//"))[1]
                                  .split("/")
                                  .first
                                  .toString(),
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      SizedBox(
                        width: size.width - 80,
                        child: buildTextContent(
                            detailData['description'] ?? '', false,
                            colorWord: greyColor,
                            fontSize: 12,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
