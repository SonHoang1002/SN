import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventDiscuss extends ConsumerStatefulWidget {
  final dynamic eventDetail;
  const EventDiscuss({Key? key, this.eventDetail}) : super(key: key);
  @override
  ConsumerState<EventDiscuss> createState() => _EventDiscussState();
}

class _EventDiscussState extends ConsumerState<EventDiscuss> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
