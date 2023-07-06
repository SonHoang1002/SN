import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/group_item.dart';
import 'package:social_network_app_mobile/widgets/page_item.dart';
import 'package:social_network_app_mobile/widgets/user_item.dart';

class BoxMention extends StatelessWidget {
  final List listData;
  final Function getMention;
  final double? width;
  final double? height;
  const BoxMention(
      {Key? key,
      required this.listData,
      required this.getMention,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      constraints: const BoxConstraints(maxHeight: 300),
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(listData.length, (index) {
            var item = listData[index];
            Widget itemWidget = const SizedBox();
            if (item['username'] != null) {
              itemWidget = UserItem(
                user: item,
              );
            } else if (item['avatar_media'] != null) {
              itemWidget = PageItem(
                page: item,
              );
            } else {
              itemWidget = GroupItem(
                group: item,
              );
            }

            return InkWell(
              onTap: () {
                getMention(listData[index]);
              },
              child: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 0.2, color: greyColor))),
                child: itemWidget,
              ),
            );
          }),
        ),
      ),
    );
  }
}
