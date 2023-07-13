import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';

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
      ),
      body: SingleChildScrollView(
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
      ),
    );
  }
}
