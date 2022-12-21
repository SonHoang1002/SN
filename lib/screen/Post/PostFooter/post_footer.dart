import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer_button.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer_information.dart';

class PostFooter extends StatefulWidget {
  const PostFooter({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PostFooterState createState() => _PostFooterState();
}

class _PostFooterState extends State<PostFooter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PostFooterInformation(),
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
        ),
        const PostFooterButton()
      ],
    );
  }
}
