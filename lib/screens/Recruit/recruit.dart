import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screens/Recruit/recruit_render.dart';

class Recruit extends StatefulWidget {
  const Recruit({Key? key}) : super(key: key);

  @override
  State<Recruit> createState() => _RecruitState();
}

class _RecruitState extends State<Recruit> with AutomaticKeepAliveClientMixin<Recruit> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const NotificationListener<ScrollNotification>(
      child: Scaffold(body: RecruitRender()),
    );
  }
  @override
  bool get wantKeepAlive => true;
}
