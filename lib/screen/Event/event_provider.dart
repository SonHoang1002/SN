import 'package:flutter/cupertino.dart';

class EventProvider with ChangeNotifier {
  final List _items = [];
  void add(value) {
    if (!_items.contains(value)) {
      _items.add(value);
    }
    notifyListeners();
  }

  void remove(value) {
    if (_items.contains(value)) {
      _items.remove(value);
    }
    notifyListeners();
  }

  get getEventProvider => _items;
}
