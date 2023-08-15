import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/apis/group_api.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/widgets/circular_progress_indicator.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/group_item.dart';

class GroupInvitedRequest extends ConsumerStatefulWidget {
  const GroupInvitedRequest({Key? key}) : super(key: key);

  @override
  ConsumerState<GroupInvitedRequest> createState() =>
      _GroupInvitedRequestState();
}

class _GroupInvitedRequestState extends ConsumerState<GroupInvitedRequest> {
  dynamic groupInviteAdmin;
  dynamic groupInviteJoin;
  dynamic groupInviteMember;
  List<bool> testList = List.generate(1000, (index) => false);
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await ref
        .read(groupListControllerProvider.notifier)
        .getGroupJoinRequest(null);
  }

  @override
  Widget build(BuildContext context) {
    groupInviteAdmin = ref.watch(groupListControllerProvider).groupInviteAdmin;
    groupInviteJoin = ref.watch(groupListControllerProvider).groupInviteJoin;
    groupInviteMember =
        ref.watch(groupListControllerProvider).groupInviteMember;
    final height = MediaQuery.sizeOf(context).height;
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // lời mời admin
            Container(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Column(
                children: [
                  buildTextContent(
                      "Lời mời tham gia nhóm với vai trò admin (${groupInviteAdmin != null ? ((groupInviteAdmin?['meta']?['total']) ?? 0) : "--"})",
                      true,
                      fontSize: 20),
                  const SizedBox(
                    height: 10.0,
                  ),
                  groupInviteAdmin != null && groupInviteAdmin.isNotEmpty
                      ? (groupInviteAdmin?['data'].isNotEmpty)
                          ? ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: groupInviteAdmin?['data'].length,
                              itemBuilder: (context, index) => Container(
                                    margin: const EdgeInsets.all(6.0),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                            width: 0.1, color: greyColor)),
                                    child: Column(
                                      children: [
                                        GroupItem(
                                          group: (groupInviteAdmin?['data']
                                                  ?[index]['group']) ??
                                              (groupInviteAdmin?['data']
                                                  ?[index]),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ButtonPrimary(
                                              label: "Chấp nhận",
                                              handlePress: () {
                                                updateJoinRequest(
                                                  true,
                                                  (groupInviteAdmin?['data']
                                                              ?[index]['group']
                                                          ?['id']) ??
                                                      (groupInviteAdmin?['data']
                                                          ?[index]['id']),
                                                );
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
                                                  (groupInviteAdmin?['data']
                                                              ?[index]['group']
                                                          ?['id']) ??
                                                      (groupInviteAdmin?['data']
                                                          ?[index]['id']),
                                                );
                                              },
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ))
                          : buildTextContent(
                              "Chưa có lời mời làm quản trị của nhóm nào",
                              false,
                              fontSize: 13)
                      : buildCircularProgressIndicator(),
                ],
              ),
            ),
            const CrossBar(
              height: 7,
              opacity: 0.2,
            ),
            // lơi mời tham gia nhóm với vai trò thành viên
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Column(
                children: [
                  buildTextContent(
                    "Lời mời tham gia nhóm (${groupInviteMember != null ? ((groupInviteMember?['meta']?['total']) ?? 0) : "--"})",
                    true,
                    fontSize: 20,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  groupInviteMember != null && groupInviteMember.isNotEmpty
                      ? (groupInviteMember?['data'].isNotEmpty)
                          ? ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: groupInviteMember?['data'].length,
                              itemBuilder: (context, index) => Container(
                                    margin: const EdgeInsets.all(6.0),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                            width: 0.1, color: greyColor)),
                                    child: Column(
                                      children: [
                                        GroupItem(
                                          group: (groupInviteMember?['data']
                                                  ?[index]['group']) ??
                                              (groupInviteMember?['data']
                                                  ?[index]),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ButtonPrimary(
                                              label: "Chấp nhận",
                                              handlePress: () {
                                                updateJoinRequest(
                                                  true,
                                                  (groupInviteMember?['data']
                                                              ?[index]['group']
                                                          ?['id']) ??
                                                      (groupInviteMember?[
                                                              'data']?[index]
                                                          ['id']),
                                                );
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
                                                  (groupInviteMember?['data']
                                                              ?[index]['group']
                                                          ?['id']) ??
                                                      (groupInviteMember?[
                                                              'data']?[index]
                                                          ['id']),
                                                );
                                              },
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ))
                          : buildTextContent(
                              "Chưa có lời mời tham gia nhóm nào", false,
                              fontSize: 13)
                      : buildCircularProgressIndicator(),
                ],
              ),
            ),
            const CrossBar(
              height: 7,
              opacity: 0.2,
            ),
            // yêu cầu tham gia nhóm
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Column(
                children: [
                  buildTextContent(
                      "Yêu cầu đã gửi (${groupInviteJoin != null ? ((groupInviteJoin?['meta']?['total']) ?? 0) : "--"})",
                      true,
                      fontSize: 20),
                  const SizedBox(
                    height: 10.0,
                  ),
                  groupInviteJoin != null && groupInviteJoin.isNotEmpty
                      ? (groupInviteJoin?['data'].isNotEmpty)
                          ? ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
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
                                          Flexible(
                                            child: GroupItem(
                                              group: groupInviteJoin?['data']
                                                  ?[index],
                                              //  (groupInviteJoin?['data']?[index]
                                              //       ['group']) ??
                                              //   (groupInviteJoin?['data']?[index]),
                                            ),
                                          ),
                                          ButtonPrimary(
                                            label: testList[index] == false
                                                ? "Hủy bỏ"
                                                : "Yêu cầu tham gia",
                                            isPrimary: false,
                                            handlePress: () {
                                              if (testList[index] == true) {
                                                GroupApi().joinGroupRequest(
                                                    groupInviteJoin['data']
                                                        [index]["id"]);
                                              } else {
                                                GroupApi().removeGroupRequest(
                                                    groupInviteJoin['data']
                                                        [index]["id"]);
                                              }
                                              testList[index] =
                                                  !testList[index];
                                              setState(() {});
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ))
                          : Container(
                              margin: const EdgeInsets.all(12.0),
                              child: const Text(
                                "Chưa có lời mời tham gia nhóm nào",
                                textAlign: TextAlign.center,
                              ),
                            )
                      : buildCircularProgressIndicator(),
                ],
              ),
            ),
          ],
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
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        message,
        style: TextStyle(color: messageColor),
      )));
      await ref
          .read(groupListControllerProvider.notifier)
          .getGroupInvite({'role': 'admin'});
      await ref
          .read(groupListControllerProvider.notifier)
          .getGroupInvite({'role': 'member'});
      await ref
          .read(groupListControllerProvider.notifier)
          .getGroupJoinRequest(null);
    }
  }
}
