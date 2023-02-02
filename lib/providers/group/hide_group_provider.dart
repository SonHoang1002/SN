import 'package:flutter/material.dart';

class HideGroupProvider with ChangeNotifier {
  String selection = "Hiển thị";
  setHideGroupProvider(String value) {
    selection = value;
    notifyListeners();
  }

  get getHideGroupProvider => selection;
}
