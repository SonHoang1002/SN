import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/data/me_data.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/widget/page_permission_comment.dart';
import 'package:social_network_app_mobile/widget/text_action.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class PostHeaderAction extends ConsumerStatefulWidget {
  final dynamic post;
  const PostHeaderAction({Key? key, this.post}) : super(key: key);

  @override
  ConsumerState<PostHeaderAction> createState() => _PostHeaderActionState();
}

class _PostHeaderActionState extends ConsumerState<PostHeaderAction> {
  String commentModeration = 'public';

  @override
  void initState() {
    super.initState();
    setState(() {
      commentModeration = widget.post['comment_moderation'];
    });
  }

  @override
  Widget build(BuildContext context) {
    List actionsPost = [
      {
        "key": widget.post['pinned'] != null && widget.post['pinned'] == true
            ? "unpin_post"
            : "pin_post",
        "label": widget.post['pinned'] != null && widget.post['pinned'] == true
            ? "Bỏ ghim bài viết"
            : "Ghim bài viết",
        "icon": FontAwesomeIcons.thumbtack,
        "isShow": meData['id'] == widget.post['account']['id'],
      },
      {
        "key": "save_post",
        "label": "Lưu bài viết",
        "icon": FontAwesomeIcons.solidBookmark,
        "description": "Thêm vào danh sách mục đã lưu",
        "isShow": true
      },
      {
        "key": "edit_post",
        "label": "Chỉnh sửa bài viết",
        "icon": FontAwesomeIcons.solidEdit,
        "isShow": meData['id'] == widget.post['account']['id']
      },
      {
        "key": "comment_permission_post",
        "label": "Ai có thể bình luận về bài viết này?",
        "icon": FontAwesomeIcons.solidComment,
        "isShow": meData['id'] == widget.post['account']['id']
      },
      {
        "key": "object_post",
        "label": "Chỉnh sửa đối tượng",
        "icon": FontAwesomeIcons.globe,
        "description": "Chỉnh sửa đối tượng theo dõi bài viết của bạn",
        "isShow": meData['id'] == widget.post['account']['id']
      },
      {
        "key": "open_notification_post",
        "label": "Bật thông báo bài viết này",
        "icon": FontAwesomeIcons.solidBell,
        "description": "Thêm vào danh sách mục đã lưu",
        "isShow": true
      },
      {
        "key": "report_post",
        "label": "Báo cáo",
        "icon": FontAwesomeIcons.solidFlag,
        "description": "Báo cáo bài viết này cho chúng tôi",
        "isShow": meData['id'] != widget.post['account']['id']
      },
      {
        "key": "delete_post",
        "label": "Xoá bài viết",
        "icon": FontAwesomeIcons.trash,
        "isShow": meData['id'] == widget.post['account']['id']
      },
    ];

    handleAction(key) {
      if (["unpin_post", "pin_post"].contains(key)) {
        ref.read(postControllerProvider.notifier).actionPinPost(
            widget.post['pinned'] != null && widget.post['pinned'] == true
                ? 'unpin'
                : 'pin',
            widget.post['id']);
        Navigator.pop(context);
      } else if (['save_post'].contains(key)) {
        Navigator.pop(context);
      } else if (key == "comment_permission_post") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateModalBaseMenu(
                    title: "Bình luận về bài viết này",
                    body: PagePermissionComment(
                        commentModeration: commentModeration,
                        handleUpdate: (newValue) {
                          setState(() {
                            commentModeration = newValue;
                          });
                        }),
                    buttonAppbar: TextAction(
                      title: "Xong",
                      fontSize: 17,
                      action: () {
                        Navigator.of(context)
                          ..pop()
                          ..pop();
                      },
                    ),
                  )),
        );
      }
    }

    // ref.listen<dynamic>(
    //     postControllerProvider.select((value) => value.postsPin),
    //     (previous, next) {
    //   print('abc $previous');
    //   print('abc $next');
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(const SnackBar(content: Text('Thành công')));
    // });

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            actionsPost
                    .sublist(0, 2)
                    .where((element) => element['isShow'] == true)
                    .toList()
                    .isNotEmpty
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: List.generate(
                          2,
                          (index) => actionsPost[index]['isShow']
                              ? BlockAction(
                                  item: actionsPost[index],
                                  handleAction: handleAction,
                                )
                              : const SizedBox()),
                    ))
                : const SizedBox(),
            const SizedBox(
              height: 12.0,
            ),
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: List.generate(
                      5,
                      (index) => actionsPost.sublist(2, 7)[index]['isShow']
                          ? BlockAction(
                              item: actionsPost.sublist(2, 7)[index],
                              handleAction: handleAction,
                            )
                          : const SizedBox()),
                )),
            const SizedBox(
              height: 12.0,
            ),
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8)),
                child: BlockAction(
                  item: actionsPost.last,
                  handleAction: handleAction,
                )),
          ],
        ),
      ),
    );
  }
}

class BlockAction extends StatelessWidget {
  final dynamic item;
  final Function handleAction;

  const BlockAction({
    super.key,
    this.item,
    required this.handleAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: InkWell(
        onTap: () {
          handleAction(item['key']);
        },
        child: Row(
          children: [
            Icon(
              item['icon'],
              size: 18,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['label'],
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: item['description'] != null ? 4.0 : 0,
                ),
                item['description'] != null
                    ? TextDescription(description: item['description'])
                    : const SizedBox(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
