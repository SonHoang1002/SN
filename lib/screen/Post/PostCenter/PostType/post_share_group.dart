import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class PostShareGroup extends StatelessWidget {
  final dynamic post;
  const PostShareGroup({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final group = post['shared_group'];
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        ImageCacheRender(path: group['banner']['preview_url']),
        Container(
          width: size.width,
          padding: const EdgeInsets.all(8),
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.background),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
                '${group['is_private'] ? 'Nhóm riêng tư' : 'Nhóm công khai'} · ${group['member_count']} thành viên'),
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
    );
  }
}
