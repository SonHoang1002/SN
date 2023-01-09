import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class PostMutipleMediaDetail extends StatelessWidget {
  final dynamic post;
  const PostMutipleMediaDetail({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List medias = post['media_attachments'];
    return Column(children: [
      PostHeader(post: post),
      Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: medias.length,
            itemBuilder: (context, index) =>
                ImageCacheRender(path: medias[index]['url'])),
      )
    ]);
  }
}
