import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_content.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class PostMutipleMediaDetail extends StatelessWidget {
  final dynamic post;
  const PostMutipleMediaDetail({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List medias = post['media_attachments'];
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 12.0,
        ),
        PostHeader(post: post, type: postMultipleMedia),
        const SizedBox(
          height: 12.0,
        ),
        PostContent(post: post),
        const SizedBox(
          height: 12.0,
        ),
        PostFooter(
          post: post,
          type: postMultipleMedia,
        ),
        const SizedBox(
          height: 12.0,
        ),
        Column(
          children: List.generate(
              medias.length,
              (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageCacheRender(path: medias[index]['url']),
                      PostFooter(
                        post: post,
                        type: postMultipleMedia,
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                    ],
                  )),
        )
      ]),
    );
  }
}
