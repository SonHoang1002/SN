import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class PostHeaderAction extends StatelessWidget {
  final dynamic post;
  const PostHeaderAction({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List actionsPost = [
      {
        "key": "pin_post",
        "label": "Ghim bài viết",
        "icon": FontAwesomeIcons.thumbtack,
      },
      {
        "key": "save_post",
        "label": "Lưu bài viết",
        "icon": FontAwesomeIcons.solidBookmark,
        "description": "Thêm vào danh sách mục đã lưu"
      },
      {
        "key": "edit_post",
        "label": "Chỉnh sửa bài viết",
        "icon": FontAwesomeIcons.solidEdit,
      },
      {
        "key": "comment_permission_post",
        "label": "Ai có thể bình luận về bài viết này?",
        "icon": FontAwesomeIcons.solidComment,
      },
      {
        "key": "object_post",
        "label": "Chỉnh sửa đối tượng",
        "icon": FontAwesomeIcons.globe,
        "description": "Chỉnh sửa đối tượng theo dõi bài viết của bạn"
      },
      {
        "key": "open_notification_post",
        "label": "Bật thông báo bài viết này",
        "icon": FontAwesomeIcons.solidBell,
        "description": "Thêm vào danh sách mục đã lưu"
      },
      {
        "key": "delete_post",
        "label": "Xoá bài viết",
        "icon": FontAwesomeIcons.trash,
      },
    ];

    return Container(
      margin: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: List.generate(
                      2,
                      (index) => BlockAction(
                            item: actionsPost[index],
                            isLast: index == 1,
                          )),
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
                      4,
                      (index) => BlockAction(
                            item: actionsPost.sublist(2, 6)[index],
                            isLast: index == 3,
                          )),
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
                            item: actionsPost.sublist(6)[index],
                            isLast: index == 0,
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
  final bool isLast;

  const BlockAction({
    super.key,
    this.item,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0.0 : 10.0),
      child: InkWell(
        onTap: () {},
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
                      fontSize: 14, fontWeight: FontWeight.w500),
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
