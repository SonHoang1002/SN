import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/expandable_text.dart';

class PostContent extends StatefulWidget {
  final dynamic post;
  final Color? textColor;
  final dynamic type;

  const PostContent({
    Key? key,
    this.post,
    this.textColor,
    this.type,
  }) : super(key: key);

  @override
  State<PostContent> createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  bool isMore = false;

  Widget renderPostContent() {
    final size = MediaQuery.of(context).size;
    if (widget.post?['status_background'] != null) {
      var backgroundObject = widget.post['status_background'];
      return Container(
        width: size.width,
        constraints: const BoxConstraints(minHeight: 320),
        decoration: BoxDecoration(
          image: DecorationImage(
              image:
                  NetworkImage(backgroundObject?['url'] ?? linkBannerDefault),
              onError: (exception, stackTrace) => const SizedBox(),
              fit: BoxFit.cover),
        ),
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Text(
              widget.post['content'] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: backgroundObject?['style'] != null
                      ? (double.parse(backgroundObject?['style']['fontSize']
                              .substring(0, 2)) -
                          10)
                      : 18,
                  color: backgroundObject?['style'] != null
                      ? Color(int.parse(backgroundObject['style']['fontColor']
                          .replaceAll('#', '0xff')))
                      : Theme.of(context).textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
      );
    } else {
      return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpandableTextContent(
                content: widget.post?['content'] ?? '',
                linkColor: widget.textColor ??
                    Theme.of(context).textTheme.bodyLarge!.color ??
                    white,
                styleContent: TextStyle(fontSize: 15, color: widget.textColor),
                hashtagStyle: const TextStyle(
                  color: secondaryColor,
                ),
              )
            ],
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return renderPostContent();
  }
}
