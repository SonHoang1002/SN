import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';

import 'package:social_network_app_mobile/widgets/appbar_title.dart';

import 'package:social_network_app_mobile/widgets/chip_menu.dart';

class ApprovalGroup extends ConsumerStatefulWidget {
  final String menuSelected;
  final dynamic groupDetail;
  const ApprovalGroup(
      {super.key, required this.menuSelected, required this.groupDetail});

  @override
  ConsumerState<ApprovalGroup> createState() => _ApprovalGroupState();
}

List approval = [];

class _ApprovalGroupState extends ConsumerState<ApprovalGroup> {
  String menuSelected = '';
  @override
  void initState() {
    super.initState();
    setState(() {
      menuSelected = widget.menuSelected;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    approval = [
      {
        'key': 'content',
        'label': 'Đã báo cáo',
        'noti':
            '${ref.watch(groupListControllerProvider).contentReported.length}',
      },
      {
        'key': 'waiting',
        'label': 'Phê duyệt',
        'noti':
            '${ref.watch(groupListControllerProvider).waitingApproval.length}',
      },
      {
        'key': 'member',
        'label': 'Thành viên',
        'noti':
            '${ref.watch(groupListControllerProvider).requestMember.length}',
      },
      {
        'key': 'noti',
        'label': 'Thông báo',
        'noti': '${ref.watch(groupListControllerProvider).notiApproval.length}',
      },
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Cần xét duyệt'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  approval.length,
                  (index) => InkWell(
                    onTap: () {
                      setState(
                        () {
                          menuSelected = approval[index]['key'];
                        },
                      );
                    },
                    child: ChipMenu(
                      isSelected: menuSelected == approval[index]['key'],
                      label:
                          '${approval[index]['label']}  ${approval[index]['noti']}',
                    ),
                  ),
                ),
              ),
            ),
            buildContentSection()
          ],
        ),
      ),
    );
  }

  Widget buildContentSection() {
    var data = ref.watch(groupListControllerProvider).waitingApproval;
    if (menuSelected == "waiting") {
      return Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          data.isEmpty
              ? const Center(
                  child: Text("Chưa có bài đăng nào"),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Post(
                          type: postApproval,
                          post: data[index],
                          haveSuggest: false,
                          isInGroup: true,
                          groupData: widget.groupDetail,
                          isHiddenFooter: true,
                          isHiddenCrossbar: false,
                          waitingForApproval: true,
                          groupId: widget.groupDetail["id"],
                        ),
                      ],
                    );
                  })
        ],
      );
    } else {
      return Container();
    }
  }
}
