import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/screens/Group/GroupDetail/home_group.dart';
import 'package:social_network_app_mobile/screens/Group/GroupDetail/manager.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

class GroupDetail extends ConsumerStatefulWidget {
  final String id;
  const GroupDetail({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends ConsumerState<GroupDetail> {
  var groupDetail = {};
  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () async {
        await ref
            .read(groupListControllerProvider.notifier)
            .getGroupDetail(widget.id)
            .then(
          (value) {
            setState(
              () {
                groupDetail = ref.read(groupListControllerProvider).groupDetail;
              },
            );
          },
        );
        ref.read(groupListControllerProvider.notifier).getPostGroup(
            {"sort_by": "new_post", "exclude_replies": true, "limit": 3},
            widget.id);
        ref
            .read(groupListControllerProvider.notifier)
            .getJoinRequest(widget.id);
        ref
            .read(groupListControllerProvider.notifier)
            .getPendingStatus(widget.id);
        ref
            .read(groupListControllerProvider.notifier)
            .getReportedStatus(widget.id);
        ref
            .read(groupListControllerProvider.notifier)
            .getStatusAlert(widget.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: AppBarTitle(
          title: groupDetail['title'] ?? '',
        ),
      ),
      body: Scaffold(
        endDrawerEnableOpenDragGesture: false,
        key: _drawerscaffoldkey,
        endDrawer: SafeArea(
          child: ManagerDetail(
            groupDetail: groupDetail,
          ),
        ),
        body: HomeGroup(
            groupDetail: groupDetail,
            onTap: () {
              if (_drawerscaffoldkey.currentState!.isDrawerOpen) {
                Navigator.pop(context);
              } else {
                _drawerscaffoldkey.currentState!.openEndDrawer();
              }
            }),
      ),
    );
  }
}
