import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class PostContent extends StatefulWidget {
  final dynamic post;
  const PostContent({Key? key, this.post}) : super(key: key);

  @override
  State<PostContent> createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  bool isMore = false;

  @override
  Widget build(BuildContext context) {
    renderPostContent() {
      final size = MediaQuery.of(context).size;
      if (widget.post['status_background'] != null) {
        var backgroundObject = widget.post['status_background'];
        return Container(
          width: size.width,
          constraints: const BoxConstraints(minHeight: 320),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(backgroundObject['url']),
                onError: (exception, stackTrace) => const SizedBox(),
                fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                widget.post['content'],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: double.parse(backgroundObject['style']['fontSize']
                            .substring(0, 2)) -
                        10,
                    color: Color(int.parse(backgroundObject['style']
                            ['fontColor']
                        .replaceAll('#', '0xff'))),
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        );
      } else {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpandableText(
                  widget.post['content'],
                  expandText: 'Xem thêm',
                  collapseText: 'Thu gọn',
                  style: const TextStyle(fontSize: 13),
                  maxLines: 5,
                  linkColor: Theme.of(context).textTheme.bodyLarge!.color,
                  linkStyle: const TextStyle(fontWeight: FontWeight.w500),
                  animation: true,
                  collapseOnTextTap: true,
                  onHashtagTap: (name) => {},
                  hashtagStyle: const TextStyle(
                    color: secondaryColor,
                  ),
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
                ),
              ],
            ));
      }
    }

    return renderPostContent();
  }
}
