import 'package:flutter/material.dart';
import 'watch_render.dart';

class Watch extends StatefulWidget {
  const Watch({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WatchState createState() => _WatchState();
}

class _WatchState extends State<Watch> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const WatchRender();
  }
}
