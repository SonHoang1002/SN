import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class PageVisibility extends StatelessWidget {
  final dynamic visibility;
  final Function handleUpdate;

  const PageVisibility(
      {Key? key, required this.visibility, required this.handleUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ai có thể xem bài viết này?",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10.0),
          const Text(
            "Bài viết của bạn sẽ được hiển thị trên bảng tin, trang cá nhân và kết quả tìm kiếm.",
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 10.0),
          const Text(
            "Bạn có thể thay đổi đối tượng tiếp cận bài viết của bạn với các lựa chọn dưới đây.",
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(
            height: 15.0,
          ),
          const Text(
            "Chọn đối tương",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Column(
            children: List.generate(
                typeVisibility.length,
                (index) => InkWell(
                      borderRadius: BorderRadius.circular(10.0),
                      onTap: () {
                        handleUpdate(typeVisibility[index]);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: visibility['key'] ==
                                    typeVisibility[index]['key']
                                ? secondaryColorSelected
                                : null,
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              typeVisibility[index]['icon'],
                              size: 20,
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(typeVisibility[index]['label'],
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
                                      description: typeVisibility[index]
                                          ['subLabel']),
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
