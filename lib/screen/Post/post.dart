import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_center.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

class Post extends StatefulWidget {
  final dynamic post;
  const Post({Key? key, this.post}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostHeader(post: widget.post),
        PostCenter(post: widget.post),
        PostFooter(post: widget.post),
        const CrossBar(),
      ],
    );
  }
}
