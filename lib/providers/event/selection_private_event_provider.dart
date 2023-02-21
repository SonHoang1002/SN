import 'package:flutter/material.dart';

class SelectionPrivateEventProvider with ChangeNotifier {
  String selection = "";
  setSelectionPrivateEventProvider(String value) {
    selection = value;
    notifyListeners();
  }

  get getSelectionPrivateEventProvider => selection;
}
