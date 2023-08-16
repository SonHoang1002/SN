import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/post_current_provider.dart';
import 'package:social_network_app_mobile/providers/watch_provider.dart';
import 'package:social_network_app_mobile/screens/Post/PostCenter/post_content.dart';
import 'package:social_network_app_mobile/screens/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screens/Post/post_header.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/video_player_controller.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';

class WatchSuggest extends ConsumerStatefulWidget {
  final dynamic media;
  final dynamic post;
  final String? preType;
  final Function? updateData;
  final dynamic friendData;
  final bool? isInGroup;
  final dynamic groupData;
  const WatchSuggest(
      {Key? key,
      this.media,
      required this.post,
      this.preType,
      this.updateData,
      this.friendData,
      this.groupData,
      this.isInGroup})
      : super(key: key);

  @override
  ConsumerState<WatchSuggest> createState() => _WatchSuggestState();
}

class _WatchSuggestState extends ConsumerState<WatchSuggest> {
  dynamic watchPost;
  List<dynamic> listWatch = [];
  final ScrollController _watchController = ScrollController();
  dynamic meData;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref
          .read(watchControllerProvider.notifier)
          .getListWatchSuggest({"limit": 3});
      ref
          .read(currentPostControllerProvider.notifier)
          .saveCurrentPost(widget.post);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        watchPost =
            ref.read(currentPostControllerProvider).currentPost ?? widget.post;
      });
    });
    _watchController.addListener(() {
      if (_watchController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (double.parse((_watchController.offset).toStringAsFixed(0)) ==
            double.parse((_watchController.position.maxScrollExtent)
                .toStringAsFixed(0))) {
          ref.read(watchControllerProvider.notifier).getListWatchSuggest({
            "limit": 3,
            'max_id': ref.watch(watchControllerProvider).watchSuggest.last['id']
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    watchPost = null;
    listWatch = [];
  }

  updateNewPost(dynamic newData) {
    // ref
    //     .read(watchControllerProvider.notifier)
    //     .getListWatchSuggest({"limit": 3});
    setState(() {
      watchPost = ref.watch(currentPostControllerProvider).currentPost;
    });
  }

  @override
  Widget build(BuildContext context) {
    watchPost = ref.watch(currentPostControllerProvider).currentPost;
    List suggestWatchList = ref.watch(watchControllerProvider).watchSuggest;
    meData ??= ref.watch(meControllerProvider)[0];
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.grey.shade900,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackIconAppbar(iconColor: white),
              const AppBarTitle(title: "Video khác", textColor: white),
              Container()
            ],
          ),
        ),
        body: CustomScrollView(
          controller: _watchController,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostHeader(
                    post: watchPost ?? widget.post,
                    textColor: white,
                    type: postDetail,
                    updateDataFunction: updateNewPost,
                    isHaveAction: true,
                    friendData: widget.friendData,
                    groupData: widget.groupData,
                    isInGroup: widget.isInGroup,
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  PostContent(
                    post: watchPost ?? widget.post,
                    textColor: white,
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Hero(
                    tag: (widget.media?['remote_url']) ??
                        (widget.media?['url']) ??
                        (widget.post?['media_attachments']?[0]
                            ?['remote_url']) ??
                        (widget.post?['media_attachments']?[0]?['url']),
                    child: VideoPlayerHasController(
                      media: widget.media,
                      onDoubleTapAction: () {},
                    ),
                  ),
                  PostFooter(
                    post: watchPost ?? widget.post,
                    type: postWatch,
                    updateDataFunction: updateNewPost,
                    preType: widget.preType,
                  ),
                  const CrossBar(
                    height: 7,
                    opacity: 0.2,
                    onlyTop: 5,
                  )
                ],
              ),
            ),
            suggestWatchList.isNotEmpty
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PostHeader(
                                post: suggestWatchList[index] ??
                                    watchPost ??
                                    widget.post,
                                textColor: white,
                                type: postDetail,
                                friendData: widget.friendData,
                                updateDataFunction: updateNewPost,
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              PostContent(
                                post: suggestWatchList[index] ??
                                    watchPost ??
                                    widget.post,
                                textColor: white,
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              // Stack(
                              // children: [
                              Hero(
                                tag: (suggestWatchList[index]
                                            ?['media_attachments']?[0]
                                        ?['remote_url']) ??
                                    (suggestWatchList[index]
                                        ?['media_attachments']?[0]?['url']) ??
                                    (widget.media?['remote_url']) ??
                                    (widget.media?['url']),
                                child: VideoPlayerHasController(
                                  media: (suggestWatchList[index]
                                          ?['media_attachments']?[0]) ??
                                      widget.media,
                                  onDoubleTapAction: () {},
                                ),
                              ),
                              // Positioned.fill(child: GestureDetector(
                              //   onDoubleTap: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) => WatchDetail(
                              //                   post: watchPost ??
                              //                       widget.post,
                              //                   media: widget.media,
                              //                   type: postWatchDetail,
                              //                   preType: widget.preType,
                              //                   updateDataFunction: () {
                              //                     widget.updateData != null
                              //                         ? widget.updateData!()
                              //                         : null;
                              //                   },
                              //                 )));
                              //   },
                              // ))
                              //   ],
                              PostFooter(
                                post: suggestWatchList[0] ??
                                    watchPost ??
                                    widget.post,
                                type: postWatch,
                                updateDataFunction: updateNewPost,
                                preType: widget.preType,
                              ),
                              const CrossBar(
                                height: 7,
                                opacity: 0.2,
                                onlyTop: 0,
                              )
                            ],
                          ),
                        );
                      },
                      childCount: ref
                          .watch(watchControllerProvider)
                          .watchSuggest
                          .length,
                    ),
                  )
                : SliverToBoxAdapter(
                    child: buildTextContent("Không có video khác.", false,
                        fontSize: 15,
                        isCenterLeft: false,
                        margin: const EdgeInsets.only(top: 20),
                        colorWord: white),
                  ),
          ],
        ));
  }
}
