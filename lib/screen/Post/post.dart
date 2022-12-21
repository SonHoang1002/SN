import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [PostHeader()],
    );
  }
}
