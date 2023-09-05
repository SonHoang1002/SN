import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/friend/friend_provider.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';

import '../Group/GroupDetail/group_detail.dart';

class MenuShortcut extends ConsumerStatefulWidget {
  const MenuShortcut({Key? key}) : super(key: key);

  @override
  ConsumerState<MenuShortcut> createState() => _MenuShortcutState();
}

class _MenuShortcutState extends ConsumerState<MenuShortcut> {
  List? listShortCut;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (ref.read(friendControllerProvider).friendSuggestions.isNotEmpty) {
        await ref
            .read(friendControllerProvider.notifier)
            .getListFriendSuggest({"limit": 25});
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        listShortCut = ref.read(friendControllerProvider).friendSuggestions;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Lối tắt của bạn",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 8,
          ),
          listShortCut != null
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                        listShortCut!.length,
                        (index) => InkWell(
                              // margin: const EdgeInsets.only(),
                              onTap: () {
                                Navigator.push(context, CustomPageRoute(
                                  builder: (context) {
                                    return GroupDetail(
                                      id: listShortCut![index]['id'],
                                    );
                                  },
                                ));
                              },
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      AvatarSocial(
                                          width: 65,
                                          height: 65,
                                          isGroup: true,
                                          object: listShortCut![index],
                                          path: (listShortCut?[index]
                                                      ?['avatar_media']) !=
                                                  null
                                              ? (listShortCut?[index]
                                                      ?['avatar_media']
                                                  ?['preview_url'])
                                              : (listShortCut?[index]?['banner']
                                                      ?['preview_url']) ??
                                                  linkAvatarDefault)
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                     ( listShortCut?[index]?['title']) ??
                                          (listShortCut?[index]
                                              ?['display_name']) ??
                                          "",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: greyColor,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  )
                                ],
                              ),
                            )),
                  ),
                )
              : Container(
                  height: 65,
                  alignment: Alignment.center,
                  child: buildCircularProgressIndicator())
        ],
      ),
    );
  }
}
