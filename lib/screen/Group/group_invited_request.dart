import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/data/groups.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/group_item.dart';

class GroupInvitedRequest extends StatelessWidget {
  const GroupInvitedRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                'Lời mời tham gia nhóm (${groupInvitations['meta']['total']})',
                style: style,
              ),
              const SizedBox(
                height: 4.0,
              ),
              groupInvitations['data'].isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: groupInvitations['data'].length,
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
                                  group: groupInvitations['data'][index]
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
                'Yêu cầu đã gửi (${groupJoinRequests['meta']['total']})',
                style: style,
              ),
              const SizedBox(
                height: 4.0,
              ),
              groupJoinRequests['data'].isEmpty
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
                      itemCount: groupJoinRequests['data'].length,
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
                                    group: groupJoinRequests['data'][index],
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
