import 'package:flutter/cupertino.dart';

class ChooseObjectProvider with ChangeNotifier {
  String chooseObject = "public";
  setChooseObjectProvider(String value) {
    chooseObject = value;
    notifyListeners();
  }
  String get getChooseObjectProvider => chooseObject;
}

