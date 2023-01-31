import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/screen/Event/event_render.dart';

class Event extends StatefulWidget {
  const Event({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EventState createState() => _EventState();
}

class _EventState extends State<Event>
    with AutomaticKeepAliveClientMixin<Event> {
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final GlobalKey<ScaffoldState> key = GlobalKey();

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: const Scaffold(body: EventRender()),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
