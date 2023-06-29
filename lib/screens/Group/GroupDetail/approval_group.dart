import 'package:flutter/material.dart';

class ApprovalGroup extends StatefulWidget {
  const ApprovalGroup({super.key});

  @override
  State<ApprovalGroup> createState() => _ApprovalGroupState();
}

List approval = [
  {
    'key': 'reported',
    'label': 'Đã báo cáo',
  },
  {
    'key': 'approved',
    'label': 'Phê duyệt',
  },
  {
    'key': 'member',
    'label': 'Thành viên',
  },
  {
    'key': 'noti',
    'label': 'Thông báo',
  },
];

class _ApprovalGroupState extends State<ApprovalGroup> {
  final meunuSelected = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Cần xét duyệt'),
      ),
      body: Container(),
    );
  }
}
