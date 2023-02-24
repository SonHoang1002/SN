import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/linkify.dart';
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
                ClipRect(
                  child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: isMore ? 1 : 0.3,
                      child: Linkify(
                        text: widget.post['content'] ?? '',
                        onOpen: (link) async {
                          if (await canLaunchUrl(Uri.parse(link.url))) {
                            await launchUrl(Uri.parse(link.url));
                          } else {
                            return;
                          }
                        },
                        style: const TextStyle(
                            fontSize: 15, overflow: TextOverflow.ellipsis),
                        options: const LinkifyOptions(humanize: false),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMore = !isMore;
                    });
                  },
                  child: Text(
                    isMore ? "Thu gọn" : "Xem thêm",
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                )
              ],
            )
            // Text(
            //   post['content'],
            //   style: const TextStyle(fontSize: 15),
            // ),
            );
      }
    }

    return renderPostContent();
  }
}
