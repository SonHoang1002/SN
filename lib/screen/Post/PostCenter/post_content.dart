import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class PostContent extends StatelessWidget {
  final dynamic post;
  const PostContent({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    renderPostContent() {
      final size = MediaQuery.of(context).size;
      if (post['status_background'] != null) {
        var backgroundObject = post['status_background'];
        return Container(
          width: size.width,
          constraints: const BoxConstraints(minHeight: 320),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(backgroundObject['url']),
                fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                post['content'],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: double.parse(
                        backgroundObject['style']['fontSize'].substring(0, 2)),
                    color: Color(int.parse(backgroundObject['style']
                            ['fontColor']
                        .replaceAll('#', '0xff'))),
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        );
      } else {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Linkify(
              text: post['content'],
              onOpen: (link) async {
                if (await canLaunchUrl(Uri.parse(link.url))) {
                  await launchUrl(Uri.parse(link.url));
                } else {
                  throw 'Không thể mở link!';
                }
              },
              style: const TextStyle(
                  fontSize: 15, overflow: TextOverflow.ellipsis),
              options: const LinkifyOptions(humanize: false),
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
