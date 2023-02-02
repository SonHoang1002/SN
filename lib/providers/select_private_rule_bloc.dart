import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SelectionPrivateGroupProvider with ChangeNotifier{
   String selection = "";
  setSelectionPrivateGroupProvider(String newValue) {
    selection = newValue;
    notifyListeners();
  }

  get getSelectionPrivateGroupProvider => selection;
}
