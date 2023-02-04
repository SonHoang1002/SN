import 'package:flutter/cupertino.dart';
import 'package:social_network_app_mobile/data/event.dart';

class EventProvider with ChangeNotifier {
  var isCare;
  setEVentProvider(id, value) {
    isCare = {
      ...eventData[id],
      'event_relationship': {
        ...eventData[id]['event_relationship'],
        'status': 'interested'
      }
    };
  }

  get getEventProvider => isCare;
}
