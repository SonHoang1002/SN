import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';

class PostListShare extends StatefulWidget {
  final dynamic post;
  const PostListShare({Key? key, this.post}) : super(key: key);

  @override
  State<PostListShare> createState() => _PostListShareState();
}

class _PostListShareState extends State<PostListShare> {
  List listPost = [];
  bool isMore = true;
  bool isLoading = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (mounted && listPost.isEmpty) {
      setState(() {
        isLoading = true;
      });
      fetchListPostShare({"limit": 5});
    }
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (!isMore) return;
        String maxId = listPost.last['id'];
        fetchListPostShare({"max_id": maxId, "limit": 5});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchListPostShare(params) async {
    var response = await PostApi().getListPostReblog(widget.post['id'], params);
    if (response != null) {
      setState(() {
        isLoading = false;
        isMore = response.length < 5 ? false : true;
        listPost = checkObjectUniqueInList([...listPost, ...response], 'id');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const AppBarTitle(title: "Những người chia sẻ bài viết này"),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: isLoading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    child: const TextDescription(
                        description:
                            "Một số bài viết có thể không xuất hiện ở đây do cài đặt quyền riêng tư"),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: listPost.length,
                      itemBuilder: (context, index) => Post(
                            post: listPost[index],
                            type: postReblog,
                          ))
                ],
              ),
      ),
    );
  }
}
