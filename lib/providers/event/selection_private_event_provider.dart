import 'package:flutter/material.dart';

class SelectionPrivateEventProvider with ChangeNotifier {
  String selection = "";
  setSelectionPrivateEventProvider(String value) {
    selection = value;
    notifyListeners();
    print(selection);
  }

  get getSelectionPrivateEventProvider => selection;
}
