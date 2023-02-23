import 'package:flutter/cupertino.dart';

class SelectTargetGroupProvider with ChangeNotifier {
  List<bool> list = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  setSelectTargetGroupProvider(List<bool> newlist) {
    list = newlist;
    notifyListeners();
  }

  get getSelectTargetGroupProvider => list;
}
