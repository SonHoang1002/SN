import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/Grows/grow_render.dart';

class Grows extends StatefulWidget {
  const Grows({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GrowsState createState() => _GrowsState();
}

class _GrowsState extends State<Grows>
    with AutomaticKeepAliveClientMixin<Grows> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return const NotificationListener<ScrollNotification>(
      child: Scaffold(body: GrowRender()),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
