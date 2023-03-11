import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/friends_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/search_input.dart';

class FriendTag extends ConsumerStatefulWidget {
  final Function handleUpdateData;
  final List friendsPrePage;
  const FriendTag(
      {Key? key, required this.handleUpdateData, required this.friendsPrePage})
      : super(key: key);

  @override
  ConsumerState<FriendTag> createState() => _FriendTagState();
}

class _FriendTagState extends ConsumerState<FriendTag> {
  List friendSelected = [];
  List friends = [];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      fetchFriends({"limit": 20});

      if (widget.friendsPrePage.isNotEmpty) {
        setState(() {
          friendSelected = widget.friendsPrePage;
        });
      }
    }
  }

  fetchFriends(params) async {
    var response = await FriendsApi()
        .getListFriendApi(ref.watch(meControllerProvider)[0]['id'], params);
    if (response != null) {
      setState(() {
        friends = response;
      });
    }
  }

  handleSearch(value) {
    if (value.isEmpty) {
      fetchFriends({"limit": 20});
      return;
    }
    EasyDebounce.debounce('my-debouncer', const Duration(milliseconds: 500),
        () {
      fetchFriends({"keyword": value});
    });
  }

  @override
  Widget build(BuildContext context) {
    List friendSelectedId = friendSelected.map((e) => e['id']).toList();

    handleSelected(friend) {
      List newList = [...friendSelected];
      if (friendSelectedId.contains(friend['id'])) {
        newList =
            newList.where((element) => element['id'] != friend['id']).toList();
      } else {
        newList = [...newList, friend];
      }

      setState(() {
        friendSelected = newList;
      });
      widget.handleUpdateData('update_friend', newList);
    }

    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchInput(
            handleSearch: handleSearch,
          ),
          const SizedBox(
            height: 8.0,
          ),
          friendSelected.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bạn bè được chọn'),
                    const SizedBox(
                      height: 8.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: friendSelected.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Container(
                                width: 65,
                                height: 65,
                                margin: const EdgeInsets.only(right: 8.0),
                                child: Stack(children: [
                                  AvatarSocial(
                                    width: 56,
                                    height: 56,
                                    path: friendSelected[index]
                                                ['avatar_media'] !=
                                            null
                                        ? friendSelected[index]['avatar_media']
                                            ['preview_url']
                                        : linkAvatarDefault,
                                  ),
                                  Positioned(
                                      right: 2,
                                      top: 2,
                                      child: InkWell(
                                        onTap: () {
                                          handleSelected(friendSelected[index]);
                                        },
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              shape: BoxShape.circle),
                                          child: const Icon(
                                            FontAwesomeIcons.xmark,
                                            size: 14,
                                          ),
                                        ),
                                      ))
                                ]),
                              )),
                    )
                  ],
                )
              : const SizedBox(),
          const SizedBox(
            height: 8.0,
          ),
          const Text('Gợi ý cho bạn'),
          const SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: friends.length,
                itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        handleSelected(friends[index]);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                AvatarSocial(
                                    width: 40,
                                    height: 40,
                                    path: friends[index]['avatar_media'] != null
                                        ? friends[index]['avatar_media']
                                            ['preview_url']
                                        : linkAvatarDefault),
                                const SizedBox(
                                  width: 8.0,
                                ),
                                Text(
                                  friends[index]['display_name'],
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            Checkbox(
                                value: friendSelectedId
                                    .contains(friends[index]['id']),
                                onChanged: null)
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
