import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class PagePermissionComment extends StatelessWidget {
  final String commentModeration;
  final Function handleUpdate;
  const PagePermissionComment(
      {Key? key, required this.commentModeration, required this.handleUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List listOptions = [
      {
        "key": 'public',
        "icon": FontAwesomeIcons.globe,
        "label": "Mọi người",
        "description": "Tất cả mọi người có thể bình luận"
      },
      {
        "key": "friend",
        "icon": FontAwesomeIcons.users,
        "label": "Bạn bè",
        "description": "Chỉ bạn bè của bạn mới có thể bình luận"
      },
      {
        "key": "tag",
        "icon": FontAwesomeIcons.tag,
        "label": "Trang cá nhân và trang bạn nhắc đến",
        "description":
            "Chỉ những trang cá nhân và trang bạn nhắc đến mới có thể bình luận"
      }
    ];

    return Container(
      margin: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          const Text(
            "Hãy chọn đối tượng có thể bình luận về bài viết của bạn, lựa chọn chỉ ảnh hưởng đến bài viết này.",
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Column(
            children: List.generate(
                listOptions.length,
                (index) => InkWell(
                      borderRadius: BorderRadius.circular(10.0),
                      onTap: () {
                        handleUpdate(listOptions[index]['key']);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color:
                                commentModeration == listOptions[index]['key']
                                    ? secondaryColorSelected
                                    : null,
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              listOptions[index]['icon'],
                              size: 20,
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(listOptions[index]['label'],
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(
                                  height: 4.0,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 110,
                                  child: TextDescription(
                                      description: listOptions[index]
                                          ['description']),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
          )
        ],
      ),
    );
  }
}
