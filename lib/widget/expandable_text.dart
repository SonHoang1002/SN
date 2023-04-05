import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpandableTextContent extends StatelessWidget {
  final String content;
  final dynamic styleContent;
  final dynamic linkColor;
  final dynamic hashtagStyle;
  final Function? handleHashtag;
  final int? maxLines;

  const ExpandableTextContent(
      {Key? key,
      required this.content,
      this.styleContent,
      this.linkColor,
      this.hashtagStyle,
      this.handleHashtag,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableText(
      content,
      expandText: 'Xem thêm',
      collapseText: 'Thu gọn',
      style: styleContent,
      linkStyle: const TextStyle(fontWeight: FontWeight.w500),
      maxLines: maxLines ?? 3,
      linkColor: linkColor,
      animation: true,
      collapseOnTextTap: true,
      onHashtagTap: (name) => {handleHashtag!(name)},
      hashtagStyle: hashtagStyle,
      onMentionTap: (username) => {},
      mentionStyle: const TextStyle(
        fontWeight: FontWeight.w500,
      ),
      onUrlTap: (url) async {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          return;
        }
      },
      urlStyle: const TextStyle(color: secondaryColor),
    );
  }
}
