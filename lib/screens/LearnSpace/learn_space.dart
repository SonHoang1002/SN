import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screens/LearnSpace/learn_space_render.dart';

class LearnSpace extends StatefulWidget {
  const LearnSpace({Key? key}) : super(key: key);

  @override
  State<LearnSpace> createState() => _LearnSpaceState();
}

class _LearnSpaceState extends State<LearnSpace>
    with AutomaticKeepAliveClientMixin<LearnSpace> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const NotificationListener<ScrollNotification>(
      child: Scaffold(body: LearnSpaceRender()),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
