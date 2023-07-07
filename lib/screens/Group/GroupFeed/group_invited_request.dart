import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                'Lời mời tham gia nhóm (${groupInviteAdmin['meta']['total']})',
                style: style,
              ),
              const SizedBox(
                height: 4.0,
              ),
              groupInviteAdmin['data'].isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: groupInviteAdmin['data'].length,
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
                                  group: groupInviteAdmin['data'][index]
                                      ['group'],
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ButtonPrimary(
                                      label: "Chấp nhận",
                                      handlePress: () {},
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    ButtonPrimary(
                                      label: "Xóa",
                                      isPrimary: true,
                                      handlePress: () {},
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
                'Yêu cầu đã gửi (${groupInviteJoin['meta']['total']})',
                style: style,
              ),
              const SizedBox(
                height: 4.0,
              ),
              groupInviteJoin['data'].isEmpty
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
                      itemCount: groupInviteJoin['data'].length,
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
                                    group: groupInviteJoin['data'][index],
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
}
