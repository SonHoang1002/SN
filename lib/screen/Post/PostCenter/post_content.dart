import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/expandable_text.dart';

class PostContent extends StatefulWidget {
  final dynamic post;
  final Color? textColor;
  const PostContent({Key? key, this.post, this.textColor}) : super(key: key);

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
          child: Container(
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
        return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpandableTextContent(
                  content: widget.post['content'],
                  linkColor: widget.textColor ??
                      Theme.of(context).textTheme.bodyLarge!.color ??
                      white,
                  styleContent:
                      TextStyle(fontSize: 15, color: widget.textColor),
                  hashtagStyle: const TextStyle(
                    color: secondaryColor,
                  ),
                )
              ],
            ));
      }
    }

    return renderPostContent();
  }
}
