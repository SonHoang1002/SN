import 'package:flutter/material.dart';

Function(int num) shortenLargeNumber = (int num) {
  if (num >= 1000000000) {
    return '${(num / 1000000000).toStringAsFixed(1).replaceAll(RegExp(r'/\.0$/'), '')}G';
  }
  if (num >= 1000000) {
    return '${(num / 1000000).toStringAsFixed(1).replaceAll(RegExp(r'/\.0$/'), '')}M';
  }
  if (num >= 1000) {
    return '${(num / 1000).toStringAsFixed(1).replaceAll(RegExp(r'/\.0$/'), '')}K';
  }
  return num;
};

hiddenKeyboard(context) {
  FocusScopeNode currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

checkObjectUniqueInList(list, keyCheck) {
  List newList = [];

  for (var i = 0; i < list.length; i++) {
    List keyOfNewList = newList.map((element) => element[keyCheck]).toList();

    if (!keyOfNewList.contains(list[i][keyCheck])) {
      newList.add(list[i]);
    }
  }

  return newList;
}
