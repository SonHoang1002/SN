import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_content.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/screen/Post/post_one_media_detail.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/video_player_none_controller.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class PostMutipleMediaDetail extends StatefulWidget {
  final int? initialIndex;
  final dynamic post;
  const PostMutipleMediaDetail({Key? key, this.post, this.initialIndex})
      : super(key: key);

  @override
  State<PostMutipleMediaDetail> createState() => _PostMutipleMediaDetailState();
}

class _PostMutipleMediaDetailState extends State<PostMutipleMediaDetail> {
  late ScrollController _scrollController;
  bool isShowImage = false;
  int? imgIndex;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        (widget.initialIndex ?? 0) *
            _scrollController.position.viewportDimension,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    });
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
          controller: _scrollController,
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
                                  : VideoPlayerNoneController(
                                      path: medias[index]['url'],
                                      type: postDetail)),
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
