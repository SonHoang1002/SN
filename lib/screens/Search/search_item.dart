import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/screens/Group/GroupDetail/group_detail.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';

import '../Page/PageDetail/page_detail.dart';
import '../UserPage/user_page.dart';

class SearchItem extends StatelessWidget {
  final dynamic item;
  const SearchItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String description =
        item?['relationships']?['friendship_status'] == 'ARE_FRIENDS'
            ? 'Bạn bè'
            : item['page_relationship']?['like'] == true
                ? 'Trang đã thích'
                : item['page_relationship']?['following'] == true
                    ? 'Đang theo dõi'
                    : item['group_relationship']?['member'] == true
                        ? 'Nhóm của bạn'
                        : '';
    return InkWell(
      onTap: () {
        item?['relationships']?['friendship_status'] == 'ARE_FRIENDS'
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserPageHome(),
                  settings: RouteSettings(
                    arguments: {'id': item['id'].toString()},
                  ),
                ))
            : item['page_relationship']?['like'] == true ||
                    item['page_relationship']?['following'] == true ||
                    item?["page_relationship"] != null
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PageDetail(),
                      settings: RouteSettings(arguments: item['id'].toString()),
                    ))
                : item?["group_relationship"] != null
                    ? Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return GroupDetail(
                            id: item['id'],
                          );
                        },
                      ))
                    : const SizedBox();
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AvatarSocial(
                    width: 40.0,
                    height: 40.0,
                    object: item,
                    path: item['avatar_media']?['preview_url'] ??
                        item['banner']?['preview_url'] ??
                        linkAvatarDefault),
                const SizedBox(
                  width: 8.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.7,
                      child: Text(
                        item['display_name'] ?? item['title'],
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    SizedBox(
                      height: description != '' ? 4.0 : 0.0,
                    ),
                    description != ''
                        ? TextDescription(description: description)
                        : const SizedBox()
                  ],
                )
              ],
            ),
            const Icon(
              FontAwesomeIcons.arrowRight,
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}
