import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_content.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/screen/Post/post_one_media_detail.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/feed_video.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/flick_multiple_manager.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class PostMutipleMediaDetail extends StatefulWidget {
  final dynamic post;
  const PostMutipleMediaDetail({Key? key, this.post}) : super(key: key);

  @override
  State<PostMutipleMediaDetail> createState() => _PostMutipleMediaDetailState();
}

class _PostMutipleMediaDetailState extends State<PostMutipleMediaDetail> {
  late FlickMultiManager flickMultiManager;
  bool isShowImage = false;
  int? imgIndex;
  @override
  void initState() {
    super.initState();
    flickMultiManager = FlickMultiManager();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List medias = widget.post['media_attachments'];

    checkIsImage(media) {
      return media['type'] == 'image' ? true : false;
    }

    return Stack(
      children: [
        SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 12.0,
            ),
            PostHeader(post: widget.post, type: postMultipleMedia),
            const SizedBox(
              height: 12.0,
            ),
            PostContent(post: widget.post),
            const SizedBox(
              height: 12.0,
            ),
            PostFooter(
              post: widget.post,
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
                          GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PostOneMediaDetail(
                                      currentIndex: index,
                                      medias: medias,
                                      postMedia: medias[index],
                                      backFunction: () {
                                        setState(() {
                                          isShowImage = false;
                                        });
                                      });
                                }));

                                // setState(() {
                                //   imgIndex = index;
                                //   isShowImage = true;
                                // });
                              },
                              child: checkIsImage(medias[index])
                                  ? ImageCacheRender(
                                      key: Key(medias[index]['id'].toString()),
                                      path: medias[index]['url'])
                                  : FeedVideo(
                                      key: Key(medias[index]['id'].toString()),
                                      flickMultiManager: flickMultiManager,
                                      path: medias[index]['url'],
                                      image: medias[index]['preview_url'])),
                          PostFooter(
                            post: medias[index],
                            type: postMultipleMedia,
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                        ],
                      )),
            )
          ]),
        ),
        // isShowImage
        //     ? PostOneMediaDetail(
        //         currentIndex: imgIndex,
        //         medias: medias,
        //         postMedia: medias[imgIndex!],
        //         backFunction: () {
        //           setState(() {
        //             isShowImage = false;
        //           });
        //         })
        //     : SizedBox()
      ],
    );
  }
}
