import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/bookmark_api.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screens/CreatePost/CreateNewFeed/create_new_feed.dart';
import 'package:social_network_app_mobile/screens/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/Bookmark/bookmark_page.dart';
import 'package:social_network_app_mobile/widgets/page_permission_comment.dart';
import 'package:social_network_app_mobile/widgets/page_visibility.dart';
import 'package:social_network_app_mobile/widgets/report_category.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';

class PostHeaderAction extends ConsumerStatefulWidget {
  final dynamic post;
  final String type;
  final Function? reloadFunction;
  const PostHeaderAction(
      {Key? key, this.post, required this.type, this.reloadFunction})
      : super(key: key);

  @override
  ConsumerState<PostHeaderAction> createState() => _PostHeaderActionState();
}

class _PostHeaderActionState extends ConsumerState<PostHeaderAction> {
  @override
  Widget build(BuildContext context) {
    var meData = ref.watch(meControllerProvider)[0];
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
        "key": widget.post['bookmarked'] != null && widget.post['bookmarked']
            ? 'unsave_post'
            : "save_post",
        "label": widget.post['bookmarked'] != null && widget.post['bookmarked']
            ? "Bỏ lưu bài viết"
            : "Lưu bài viết",
        "icon": FontAwesomeIcons.solidBookmark,
        "description":
            widget.post['bookmarked'] != null && widget.post['bookmarked']
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
        "key": "complete_goal",
        "label": "Đánh dấu hoàn thành mục tiêu",
        "icon": FontAwesomeIcons.bullseye,
        "isShow": meData['id'] == widget.post['account']['id'] &&
            widget.post['post_type'] == postTarget &&
            (widget.post["status_target"] != null &&
                widget.post["status_target"]["target_status"] != "completed")
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
        "key": widget.post['notify']
            ? "unopen_notification_post"
            : "open_notification_post",
        "label": widget.post['notify']
            ? "Tắt thông báo bài viết này"
            : "Bật thông báo bài viết này",
        "icon": widget.post['notify']
            ? FontAwesomeIcons.solidBellSlash
            : FontAwesomeIcons.solidBell,
        "description": widget.post['notify']
            ? "Không nhận thông báo từ bài viết này"
            : "Bạn sẽ nhận được thông báo của bài viết này",
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
        "key": ["account_avatar", "account_banner"]
                    .contains(widget.post['post_type']) ||
                meData['id'] != widget.post['account']['id']
            ? "hidden_post"
            : "delete_post",
        "label": ["account_avatar", "account_banner"]
                    .contains(widget.post['post_type']) ||
                meData['id'] != widget.post['account']['id']
            ? "Ẩn bài viết"
            : "Xoá bài viết",
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

    handleNotifyPost(key) async {
      var response = key == "unopen_notification_post"
          ? await PostApi().turnOffNotification(widget.post['id'])
          : await PostApi().turnOnNotification(widget.post['id']);
      if (response != null && mounted) {
        var newData = {
          ...widget.post,
          "notify": key == "unopen_notification_post" ? false : true
        };
        ref
            .read(postControllerProvider.notifier)
            .actionUpdateDetailInPost(widget.type, newData);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(key == "unopen_notification_post"
                ? "Tắt thông báo thành công"
                : "Bật thông báo thành công")));
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
    }

    handleUpdatePost(data) async {
      dynamic response = await PostApi().updatePost(widget.post['id'], data);

      if (data['hidden'] == true) {
        ref
            .read(postControllerProvider.notifier)
            .actionHiddenDeletePost(widget.type, widget.post);
      } else {
        ref
            .read(postControllerProvider.notifier)
            .actionFriendModerationPost(widget.type, response);
      }
      if (response != null && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Cập nhật thành công")));
      }
    }

    handleCompleteTarget() async {
      final newData = widget.post;
      newData['status_target']["target_status"] = "completed";
      ref
          .read(postControllerProvider.notifier)
          .actionUpdatePost(widget.type, newData);
      Navigator.pop(context);
      final response = await PostApi().postCompleteTarget(widget.post['id']);
      if (response != null) {
        widget.reloadFunction != null ? widget.reloadFunction!() : null;
      }
    }

    void showAlertDialog(BuildContext context) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => AlertDialogDelete(
                post: widget.post,
                type: widget.type,
              ));
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
                        commentModeration: widget.post['comment_moderation'],
                        handleUpdate: (newValue) {
                          handleUpdatePost({"comment_moderation": newValue});
                        }),
                    buttonAppbar: const SizedBox(),
                  )),
        );
      } else if (key == "hidden_post") {
        handleUpdatePost({"hidden": true});
        Navigator.pop(context);
      } else if (key == "delete_post") {
        Navigator.pop(context);
        showAlertDialog(context);
      } else if (key == "complete_goal") {
        handleCompleteTarget();
      } else if (key == "report_post") {
        Navigator.pop(context);
        showBarModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) =>
                ReportCategory(entityReport: widget.post, entityType: "post"));
      } else if (["unopen_notification_post", "open_notification_post"]
          .contains(key)) {
        handleNotifyPost(key);
      } else if (key == "object_post") {
        var visibility = typeVisibility.firstWhere(
            (element) => element['key'] == widget.post['visibility']);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateModalBaseMenu(
                    title: "Chỉnh sửa quyền riêng tư",
                    body: PageVisibility(
                      visibility: visibility,
                      handleUpdate: (newVisibility) {
                        handleUpdatePost({'visibility': newVisibility["key"]});
                      },
                    ),
                    buttonAppbar: const SizedBox())));
      } else if (key == "edit_post") {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CreateNewFeed(post: widget.post, type: widget.type)));
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
                      6,
                      (index) => actionsPost.sublist(2, 8)[index]['isShow']
                          ? BlockAction(
                              item: actionsPost.sublist(2, 8)[index],
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

class AlertDialogDelete extends ConsumerWidget {
  final dynamic post;
  final String type;
  const AlertDialogDelete({super.key, this.post, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    handleDeletePost(key) async {
      var response = await PostApi().deletePostApi(post!['id']);

      ref
          .read(postControllerProvider.notifier)
          .actionHiddenDeletePost(type, post);

      if (response != null) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Xóa bài viết thành công")));
      }
    }

    return CupertinoAlertDialog(
      title: const Text('Xóa bài viết'),
      content: const Text(
          'Bạn chắc chắn muốn xóa bài viết? Hành động này không thể hoàn tác'),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Hủy'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            handleDeletePost('delete_post');
          },
          child: const Text('Xóa'),
        ),
      ],
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
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
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
