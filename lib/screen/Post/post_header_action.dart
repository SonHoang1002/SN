import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/data/me_data.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class PostHeaderAction extends ConsumerWidget {
  final dynamic post;
  const PostHeaderAction({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List actionsPost = [
      {
        "key": post['pinned'] != null && post['pinned'] == true
            ? "unpin_post"
            : "pin_post",
        "label": post['pinned'] != null && post['pinned'] == true
            ? "Bỏ ghim bài viết"
            : "Ghim bài viết",
        "icon": FontAwesomeIcons.thumbtack,
        "isShow": meData['id'] == post['account']['id'],
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
        "isShow": true
      },
      {
        "key": "comment_permission_post",
        "label": "Ai có thể bình luận về bài viết này?",
        "icon": FontAwesomeIcons.solidComment,
        "isShow": true
      },
      {
        "key": "object_post",
        "label": "Chỉnh sửa đối tượng",
        "icon": FontAwesomeIcons.globe,
        "description": "Chỉnh sửa đối tượng theo dõi bài viết của bạn",
        "isShow": true
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
        "isShow": true
      },
      {
        "key": "delete_post",
        "label": "Xoá bài viết",
        "icon": FontAwesomeIcons.trash,
        "isShow": true
      },
    ];

    handleAction(key) {
      if (["unpin_post", "pin_post"].contains(key)) {
        ref.read(postControllerProvider.notifier).actionPinPost(
            post['pinned'] != null && post['pinned'] == true ? 'unpin' : 'pin',
            post['id']);
      }
      Navigator.pop(context);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            actionsPost
                    .sublist(0, 2)
                    .where((element) =>
                        element['isShow'] != null && element['isShow'] == true)
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
                          (index) => actionsPost[index]['isShow'] != null &&
                                  actionsPost[index]['isShow']
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
                      (index) => actionsPost[index]['isShow'] != null &&
                              actionsPost[index]['isShow']
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
                child: Column(
                  children: List.generate(
                      1,
                      (index) => BlockAction(
                            item: actionsPost.sublist(7)[index],
                            handleAction: handleAction,
                          )),
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
