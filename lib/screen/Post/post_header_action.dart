import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/bookmark_api.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/data/me_data.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/widget/Bookmark/bookmark_page.dart';
import 'package:social_network_app_mobile/widget/page_permission_comment.dart';
import 'package:social_network_app_mobile/widget/text_action.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class PostHeaderAction extends ConsumerStatefulWidget {
  final dynamic post;
  final String type;
  const PostHeaderAction({Key? key, this.post, required this.type})
      : super(key: key);

  @override
  ConsumerState<PostHeaderAction> createState() => _PostHeaderActionState();
}

class _PostHeaderActionState extends ConsumerState<PostHeaderAction> {
  String commentModeration = 'public';

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        commentModeration = widget.post['comment_moderation'];
      });
    }
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
        "key": widget.post['bookmarked'] ? 'unsave_post' : "save_post",
        "label": widget.post['bookmarked'] ? "Bỏ lưu bài viết" : "Lưu bài viết",
        "icon": FontAwesomeIcons.solidBookmark,
        "description": widget.post['bookmarked']
            ? "Loại khỏi danh sách mục đã lưu"
            : "Thêm vào danh sách mục đã lưu",
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

    handleUnBookmark() async {
      var response =
          await BookmarkApi().unBookmarkApi({"bookmark_id": widget.post['id']});
      if (response != null && mounted) {
        ref
            .read(postControllerProvider.notifier)
            .actionUpdateDetailInPost(widget.type, response);
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Bỏ lưu thành công")));
      }
    }

    handleActionPinPost(type) async {
      dynamic response;
      if (type == 'pin_post') {
        response = await PostApi().pinPostApi(widget.post['id']);
        if (response == null) return;
      } else {
        response = await PostApi().unPinPostApi(widget.post['id']);
        if (response == null) return;
      }

      ref.read(postControllerProvider.notifier).actionPinPost(type, response);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("${type == 'pin_post' ? "Ghim" : "Bỏ ghim"} thành công")));
      }

      setState(() {});
    }

    handleAction(key) {
      if (["unpin_post", "pin_post"].contains(key)) {
        handleActionPinPost(key);
      } else if (['save_post'].contains(key)) {
        Navigator.pop(context);
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
            builder: (context) => BookmarkPage(
                type: widget.type,
                entitySave: widget.post,
                entityType: 'Status'));
      } else if (['unsave_post'].contains(key)) {
        handleUnBookmark();
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
