import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

class ManagerDetail extends StatefulWidget {
  final dynamic groupDetail;
  const ManagerDetail({super.key, this.groupDetail});

  @override
  State<ManagerDetail> createState() => _ManagerDetailState();
}

class _ManagerDetailState extends State<ManagerDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: AppBarTitle(
            title: widget.groupDetail['title'] ?? '',
          ),
        ),
        body: Container());
  }
}
