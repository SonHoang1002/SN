import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/expandable_text.dart';

class PostContent extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    var backgroundObject = post['status_background'];

    return backgroundObject != null
        ? Container(
            width: size.width,
            constraints: const BoxConstraints(minHeight: 320),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      backgroundObject?['url'] ?? linkBannerDefault),
                  onError: (exception, stackTrace) => const SizedBox(),
                  fit: BoxFit.cover),
            ),
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Text(
                  post['content'] ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: backgroundObject?['style'] != null
                          ? (double.parse(backgroundObject?['style']['fontSize']
                                  .substring(0, 2)) -
                              10)
                          : 18,
                      color: backgroundObject?['style'] != null
                          ? Color(int.parse(backgroundObject['style']
                                  ['fontColor']
                              .replaceAll('#', '0xff')))
                          : Theme.of(context).textTheme.bodyLarge!.color,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpandableTextContent(
                  content: post?['content'] ?? '',
                  postData: post,
                  linkColor: textColor ??
                      Theme.of(context).textTheme.bodyLarge!.color ??
                      white,
                  styleContent: TextStyle(fontSize: 15, color: textColor),
                  hashtagStyle: const TextStyle(
                    color: secondaryColor,
                  ),
                )
              ],
            ));
  }
}
