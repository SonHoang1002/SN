import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/divider_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/WebView/my_web_view.dart';

// ignore: must_be_immutable
class PostCard extends StatelessWidget {
  final dynamic post;
  Axis axis;
  Border? border;
  final dynamic type;
  PostCard(
      {Key? key, this.post, this.axis = Axis.vertical, this.border, this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isVertical = (axis == Axis.vertical);
    var card = post['card'];
    var size = MediaQuery.sizeOf(context);
    var linkTitle =
        ((card['link'] ?? card['url']).split("//"))[1].split("/").first;

    return card != null
        ? (card['provider_name'] != null && card['provider_name'] != 'GIPHY') ||
                card['link'] != null
            // ? card['provider_name'] != null && card['provider_name'] != 'GIPHY'
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), border: border),
                margin: const EdgeInsets.only(
                  top: 8,
                ),
                child: InkWell(
                  onTap: () {
                    if (type != "edit_post") {
                      pushCustomCupertinoPageRoute(
                          context,
                          MyWebView(
                            title: linkTitle ?? 'Liên kết ngoài',
                            selectedUrl: card['link'] ?? card['url'],
                            post: post,
                            type: type,
                          ));
                    }
                  },
                  child: isVertical
                      ? Column(
                          children: [
                            ExtendedImage.network(
                                card['image'] ??
                                    card['url'] ??
                                    card['link'] ??
                                    linkBannerDefault,
                                height: 250,
                                fit: BoxFit.fitWidth,
                                width: size.width),
                            BlockTextCard(
                                size: size, linkTitle: linkTitle, card: card),
                          ],
                        )
                      : Row(
                          children: [
                            ImageCard(card: card),
                            ContentCard(size: size, card: card),
                          ],
                        ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    buildDivider(color: greyColor),
                    ClipRect(
                      child: ExtendedImage.network(
                        card?['link'] ?? linkBannerDefault,
                        width: size.width,
                      ),
                    ),
                  ],
                ),
              )
        : const SizedBox();
  }
}

class BlockTextCard extends StatelessWidget {
  const BlockTextCard({
    super.key,
    required this.size,
    required this.linkTitle,
    required this.card,
  });

  final Size size;
  final String linkTitle;
  final dynamic card;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              linkTitle,
              style: const TextStyle(
                  fontSize: 12,
                  color: greyColor,
                  overflow: TextOverflow.ellipsis),
            ),
            Text(
              card['title'] ?? "",
              maxLines: 2,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis),
            ),
            card['description'] != null && card['description'] != ""
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: buildTextContent(card['description'], false,
                        fontSize: 12,
                        colorWord: greyColor,
                        overflow: TextOverflow.ellipsis),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class ContentCard extends StatelessWidget {
  const ContentCard({
    super.key,
    required this.size,
    required this.card,
  });

  final Size size;
  final dynamic card;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        padding: const EdgeInsets.symmetric(vertical: 8),
        height: 80.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildTextContent(
                card['url'].split("//")[1].split("/").first,
                true,
                fontSize: 14,
                colorWord: greyColor,
                overflow: TextOverflow.ellipsis,
              ),
              card['title'] != null || card['title'] != ""
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: buildTextContent(card['title'], false,
                          fontSize: 14, overflow: TextOverflow.ellipsis),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({
    super.key,
    required this.card,
  });

  final dynamic card;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
      child: ExtendedImage.network(
          card['image'] ?? card['url'] ?? card['link'] ?? linkBannerDefault,
          // fit: BoxFit.cover,
          height: 80.0,
          width: 80.0),
    );
  }
}
