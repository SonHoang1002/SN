import 'package:flutter/material.dart';
import 'watch_render.dart';

class Watch extends StatefulWidget {
  const Watch({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WatchState createState() => _WatchState();
}

class _WatchState extends State<Watch> {
  @override
  Widget build(BuildContext context) {
    return const WatchRender();
  }
}
