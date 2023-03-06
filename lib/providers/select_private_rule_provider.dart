import 'package:flutter/material.dart';

class SelectionPrivateGroupProvider with ChangeNotifier {
  String selection = "";
  setSelectionPrivateGroupProvider(String newValue) {
    selection = newValue;
    notifyListeners();
  }

  get getSelectionPrivateGroupProvider => selection;
}
