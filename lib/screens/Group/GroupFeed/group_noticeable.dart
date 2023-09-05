import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';

class GroupNoticeable extends StatefulWidget {
  final dynamic data;
  const GroupNoticeable({super.key, this.data});

  @override
  State<GroupNoticeable> createState() => _GroupNoticeableState();
}

class _GroupNoticeableState extends State<GroupNoticeable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text('Đáng chú ý'),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              FontAwesomeIcons.chevronLeft,
              size: 21,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          )),
      body: widget.data.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  return Post(
                    type: postPageUser,
                    post: widget.data[index],
                  );
                },
              ),
            )
          : Center(
              child: buildTextContent(
                  "Không có bài viết đáng chú ý nào !!", false,
                  fontSize: 20, isCenterLeft: false)),
    );
  }
}
