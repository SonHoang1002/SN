import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/screens/Group/GroupDetail/home_group.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

class GroupDetail extends ConsumerStatefulWidget {
  final String id;
  const GroupDetail({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends ConsumerState<GroupDetail> {
  var groupDetail = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(groupListControllerProvider.notifier)
          .getGroupDetail(widget.id)
          .then((value) {
        setState(() {
          groupDetail = ref.read(groupListControllerProvider).groupDetail;
        });
      });
    });
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
        body: HomeGroup(groupDetail: groupDetail));
  }
}
