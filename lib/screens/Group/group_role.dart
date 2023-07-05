import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

class GroupRole extends ConsumerStatefulWidget {
  const GroupRole({super.key});

  @override
  ConsumerState<GroupRole> createState() => _GroupRoleState();
}

class _GroupRoleState extends ConsumerState<GroupRole> {
  List groupAdmin = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Mọi người'),
      ),
      body: const Column(
        children: [
          Text('Quản trị viên và người kiểm duyệt'),
        ],
      ),
    );
  }
}
