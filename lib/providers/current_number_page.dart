import 'package:flutter/material.dart';

class CurrentNumberPageProvider with ChangeNotifier {
  int currentNumberPage = 1;
  setCurrentNumberPage(int newNumber) {
    currentNumberPage = newNumber;
    notifyListeners();
  }

  get getCurrentNumberPage => currentNumberPage;
}
