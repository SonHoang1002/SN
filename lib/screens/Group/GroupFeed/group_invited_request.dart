import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/group_api.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/group_item.dart';

class GroupInvitedRequest extends ConsumerStatefulWidget {
  const GroupInvitedRequest({Key? key}) : super(key: key);

  @override
  ConsumerState<GroupInvitedRequest> createState() =>
      _GroupInvitedRequestState();
}

class _GroupInvitedRequestState extends ConsumerState<GroupInvitedRequest> {
  dynamic groupInviteAdmin;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic groupInviteAdmin =
        ref.watch(groupListControllerProvider).groupInviteAdmin;
    dynamic groupInviteJoin =
        ref.watch(groupListControllerProvider).groupInviteJoin;
    TextStyle style =
        const TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lời mời tham gia nhóm (${groupInviteJoin?['meta']?['total']})',
                style: style,
              ),
              const SizedBox(
                height: 4.0,
              ),
              groupInviteJoin['data'].isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: groupInviteJoin?['data'].length,
                      itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.all(6.0),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border:
                                    Border.all(width: 0.1, color: greyColor)),
                            child: Column(
                              children: [
                                GroupItem(
                                  group: groupInviteJoin?['data']?[index],
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ButtonPrimary(
                                      label: "Chấp nhận",
                                      handlePress: () {
                                        updateJoinRequest(
                                            true,
                                            groupInviteJoin?['data'][index]
                                                ['id']);
                                      },
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    ButtonPrimary(
                                      label: "Xóa",
                                      isPrimary: true,
                                      handlePress: () {
                                        updateJoinRequest(
                                            false,
                                            groupInviteJoin?['data'][index]
                                                ['id']);
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          ))
                  : Container(
                      margin: const EdgeInsets.all(12.0),
                      child: const Text(
                        "Chưa có lời mời tham gia nhóm nào",
                        textAlign: TextAlign.center,
                      ),
                    ),
              Text(
                'Yêu cầu đã gửi (${(groupInviteJoin?['meta']?['total']) ?? groupInviteJoin.length})',
                style: style,
              ),
              const SizedBox(
                height: 4.0,
              ),
              groupInviteJoin?['data'].isEmpty
                  ? Container(
                      margin: const EdgeInsets.all(12.0),
                      child: const Text(
                        "Chưa có lời mời tham gia nhóm nào",
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: groupInviteJoin?['data'].length,
                      itemBuilder: (context, index) => InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              margin: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GroupItem(
                                    group: groupInviteJoin?['data']?[index],
                                  ),
                                  ButtonPrimary(
                                    label: "Hủy bỏ",
                                    isPrimary: false,
                                    handlePress: () {},
                                  )
                                ],
                              ),
                            ),
                          ))
            ],
          ),
        ),
      ),
    );
  }

  updateJoinRequest(bool isAccept, dynamic groupId) async {
    final response = await GroupApi().fetchPostUpdateJoinRequest(
        groupId, isAccept ? {"type": "approved"} : {"type": "rejected"});
    String message = (isAccept
        ? "Bạn đã xác nhận tham gia nhóm"
        : "Bạn đã từ chối tham gia nhóm");
    Color messageColor = Colors.green;
    if (response != null) {
      if (response?['status_code'] != null) {
        message = (response?['content']?['error']).toString();
        messageColor = red;
      } else {
        await ref
            .read(groupListControllerProvider.notifier)
            .getGroupJoinRequest(null);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        message,
        style: TextStyle(color: messageColor),
      )));
    }
  }
}
