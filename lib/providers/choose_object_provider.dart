import 'package:flutter/cupertino.dart';

class ChooseObjectProvider with ChangeNotifier {
  String chooseObject = "public";
  setChooseObjectProvider(String value) {
    chooseObject = value;
    notifyListeners();
  }
  String get getChooseObjectProvider => chooseObject;
}
// import 'package:flutter/cupertino.dart';

// class ChooseObjectProvider with ChangeNotifier {
//   List<String> chooseObject = ["Công khai", "", ""];
//   setChooseObjectProvider(String value, int index) {
//     var primary = ["", "", ""];
//     primary[index] = value;
//     chooseObject = primary;
//     notifyListeners();
//   }

//   List<String> get getChooseObjectProvider => chooseObject;
// }
