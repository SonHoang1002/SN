import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class PostShareGroup extends StatelessWidget {
  final dynamic post;
  const PostShareGroup({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final group = post['shared_group'];
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '/group', arguments: group);
      },
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Container(
              decoration: const BoxDecoration(
                  border:
                      Border(top: BorderSide(width: 0.4, color: greyColor))),
              child: ExtendedImage.network(
                group['banner']?['preview_url'] ?? '',
                height: 200,
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover,
              )),
          Container(
            width: size.width,
            padding: const EdgeInsets.all(8),
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.background),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                  '${group['is_private'] != null && group['is_private'] ? 'Nhóm riêng tư' : 'Nhóm công khai'} · ${group['member_count'] ?? 0} thành viên'),
              const SizedBox(
                height: 5,
              ),
              Text(
                group['title'],
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis),
              )
            ]),
          )
        ],
      ),
    );
  }
}
