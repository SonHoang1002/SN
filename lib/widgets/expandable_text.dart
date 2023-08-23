import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/custom_expanded_text.dart';
// import 'package:social_network_app_mobile/widgets/custom_expanded_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpandableTextContent extends StatelessWidget {
  final String content;
  final dynamic postData;
  final dynamic styleContent;
  final dynamic linkColor;
  final dynamic hashtagStyle;
  final Function? handleHashtag;
  final int? maxLines;

  const ExpandableTextContent(
      {Key? key,
      required this.content,
      this.postData,
      this.styleContent,
      this.linkColor,
      this.hashtagStyle,
      this.handleHashtag,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomExpandableText(
      changeContentWithMention(),
      expandText: 'Xem thêm',
      collapseText: 'Thu gọn',
      style: styleContent,
      linkStyle: const TextStyle(fontWeight: FontWeight.w500),
      maxLines: maxLines ?? 3,
      linkColor: linkColor,
      animation: true,
      collapseOnTextTap: true,
      onHashtagTap: (name) {
        handleHashtag!(name);
      },
      hashtagStyle: hashtagStyle,
      onMentionTap: (username) {
        
      },
      mentionStyle: const TextStyle(fontWeight: FontWeight.w500, color: red),
      onUrlTap: (url) async {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          return;
        }
      },
      urlStyle:
          const TextStyle(color: secondaryColor, fontWeight: FontWeight.w600),
    );
  }

  String changeContentWithMention() {
    String data = content;
    if (postData != null &&
        postData?['status_tags'] != null &&
        postData?['status_tags'].isNotEmpty) {
      List statusTags = postData['status_tags'];
      for (dynamic tag in statusTags) {
        String oldTag = "[${tag["entity_id"]}]";
        // ignore: prefer_interpolation_to_compose_strings
        String newTag = "@" + tag["name"];
        data = data.replaceAll(oldTag, newTag);
      }
      return data;
    }
    return data;
  }

  void handleChooseMentionTarget() {
    if (postData != null &&
        postData?['status_tags'] != null &&
        postData?['status_tags'].isNotEmpty) {
      List statusTags = postData['status_tags'];
      for (dynamic tag in statusTags) {}
    }
  }

  TextSpan changContentMentionWidget() {
    String data = content;
    if (postData != null &&
        postData?['status_tags'] != null &&
        postData?['status_tags'].isNotEmpty) {
      List statusTags = postData['status_tags'];
      for (dynamic tag in statusTags) {
        String oldTag = "[${tag["entity_id"]}]";
        String newTag = tag["name"];
        data = data.replaceAll(oldTag, newTag);
      }
      return TextSpan();
    }
    return TextSpan();
  }
}
