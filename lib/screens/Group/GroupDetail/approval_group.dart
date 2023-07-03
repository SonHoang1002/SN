import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/chip_menu.dart';

class ApprovalGroup extends ConsumerStatefulWidget {
  final String menuSelected;
  const ApprovalGroup({super.key, required this.menuSelected});

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

    setState(() {
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
          'noti':
              '${ref.watch(groupListControllerProvider).notiApproval.length}',
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Cần xét duyệt'),
      ),
      body: Column(
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
        ],
      ),
    );
  }
}
