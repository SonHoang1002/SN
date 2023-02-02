import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectionPrivateEventProvider with ChangeNotifier {
  String selection = "";
  setSelectionPrivateEventProvider(String value) {
    selection = value;
    notifyListeners();
    print(selection);
  }

  get getSelectionPrivateEventProvider => selection;
}
