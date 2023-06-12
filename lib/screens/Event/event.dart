import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screens/Event/event_render.dart';

class Event extends StatefulWidget {
  const Event({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EventState createState() => _EventState();
}

class _EventState extends State<Event>
    with AutomaticKeepAliveClientMixin<Event> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final GlobalKey<ScaffoldState> key = GlobalKey();

    return const NotificationListener<ScrollNotification>(
      child: Scaffold(body: EventRender()),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
