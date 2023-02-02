import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CurrentNumberPageProvider with ChangeNotifier {
  int currentNumberPage = 1;
  setCurrentNumberPage(int newNumber) {
    currentNumberPage = newNumber;
    notifyListeners();
  }

  get getCurrentNumberPage => currentNumberPage;
}
