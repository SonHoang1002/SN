import 'package:comment_tree/comment_tree.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/data/post.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_card.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/feed_video.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/flick_multiple_manager.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:transparent_image/transparent_image.dart';

class CommentTree extends StatefulWidget {
  const CommentTree({Key? key, this.commentParent}) : super(key: key);
  final dynamic commentParent;

  @override
  State<CommentTree> createState() => _CommentTreeState();
}

class _CommentTreeState extends State<CommentTree> {
  bool isShowCommentChild = false;
  List<Comment> commentChild = [];
  @override
  void initState() {
    commentChild = widget.commentParent['replies_total'] > 0
        ? [Comment(avatar: 'icon', userName: 'null', content: '')]
        : [];
    GetTimeAgo.setDefaultLocale('vi');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic avatarMedia = widget.commentParent['account']['avatar_media'];
    int replyCount = widget.commentParent['replies_total'];

    fetchChildComment() {
      List<Comment>? newListCommentChild = postChildComment
          .map((e) => Comment(
              avatar: e['account']['avatar_media'] != null
                  ? e['account']['avatar_media']['preview_url']
                  : linkAvatarDefault,
              userName: e['account']['display_name'],
              content: e['id']))
          .toList();
      setState(() {
        isShowCommentChild = true;
        commentChild = newListCommentChild;
      });
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: CommentTreeWidget<Comment, Comment>(
        Comment(
          avatar: avatarMedia['preview_url'] ?? linkAvatarDefault,
          userName: widget.commentParent['account']['display_name'],
          content: widget.commentParent['content'],
        ),
        commentChild,
        treeThemeData: TreeThemeData(
            lineColor: replyCount == 0 ? Colors.transparent : greyColor,
            lineWidth: 0.5),
        avatarRoot: (context, data) => PreferredSize(
            preferredSize: const Size.fromRadius(18),
            child: AvatarSocial(width: 36, height: 36, path: data.avatar!)),
        avatarChild: (context, data) => PreferredSize(
          preferredSize: const Size.fromRadius(12),
          child: data.avatar == 'icon'
              ? Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: const Icon(
                    Icons.reply,
                    color: greyColor,
                    size: 14,
                  ),
                )
              : AvatarSocial(width: 30, height: 30, path: data.avatar!),
        ),
        contentChild: (context, data) {
          return replyCount > 0 && !isShowCommentChild
              ? GestureDetector(
                  onTap: () {
                    fetchChildComment();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      "$replyCount phản hồi",
                      style: const TextStyle(
                          color: greyColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              : BoxComment(
                  widget: widget,
                  data: data,
                  post: postChildComment
                      .firstWhere((element) => element['id'] == data.content));
        },
        contentRoot: (context, data) {
          return BoxComment(
            widget: widget,
            data: data,
            post: widget.commentParent,
          );
        },
      ),
    );
  }
}

class BoxComment extends StatelessWidget {
  final dynamic post;
  const BoxComment({
    super.key,
    required this.widget,
    required this.data,
    this.post,
  });

  final CommentTree widget;
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        data.content != ''
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${data.userName}',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${post['content']}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                child: Text(
                  '${data.userName}',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500),
                )),
        PostMediaComment(post: post),
        DefaultTextStyle(
          style: const TextStyle(
              color: greyColor, fontSize: 12, fontWeight: FontWeight.w500),
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 8,
                    ),
                    const Text('Thích'),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text('Trả lời'),
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      GetTimeAgo.parse(
                          DateTime.parse(widget.commentParent['created_at'])),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20.0),
                  child: Row(
                    children: [
                      Text('${post['favourites_count']} thích'),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class PostMediaComment extends StatefulWidget {
  final dynamic post;
  const PostMediaComment({
    super.key,
    this.post,
  });

  @override
  State<PostMediaComment> createState() => _PostMediaCommentState();
}

class _PostMediaCommentState extends State<PostMediaComment> {
  late FlickMultiManager flickMultiManager;

  @override
  void initState() {
    super.initState();
    flickMultiManager = FlickMultiManager();
  }

  @override
  Widget build(BuildContext context) {
    dynamic card = widget.post['card'];
    List medias = widget.post['media_attachments'] ?? [];
    final size = MediaQuery.of(context).size;
    renderCard() {
      if (card['description'] == 'sticky') {
        return ImageCacheRender(
          path: card['link'],
          width: 90.0,
        );
      } else if (card['provider_name'] == 'GIPHY') {
        return Container(
          margin: const EdgeInsets.only(top: 5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ImageCacheRender(
              path: card['link'],
            ),
          ),
        );
      } else {
        return PostCard(post: widget.post);
      }
    }

    checkIsImage(media) {
      return media['type'] == 'image' ? true : false;
    }

    renderMedia() {
      if (checkIsImage(medias[0])) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: medias[0]['url'],
            imageErrorBuilder: (context, error, stackTrace) => const SizedBox(),
          ),
        );
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FeedVideo(
              path: medias[0]['remote_url'] ?? medias[0]['url'],
              flickMultiManager: flickMultiManager,
              image:
                  medias[0]['preview_remote_url'] ?? medias[0]['preview_url']),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: card != null
          ? renderCard()
          : medias.isNotEmpty
              ? Container(
                  constraints: BoxConstraints(
                      maxHeight: size.width * 0.7, maxWidth: size.width * 0.7),
                  child: renderMedia())
              : const SizedBox(),
    );
  }
}