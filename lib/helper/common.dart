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
