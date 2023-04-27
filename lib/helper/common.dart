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
String shortenNumber(int num) {
  if (num >= 1000000000) {
    return '${(num / 1000000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}B';
  } else if (num >= 1000000 && num < 1000000000) {
    return '${(num / 1000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}M';
  } else if (num >= 1000 && num < 1000000) {
    return '${(num / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}K';
  } else {
    return num.toString();
  }
}

Function(int num) convertNumberToVND = (int num) {
  return num.toString().replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
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

convertTimeIsoToTimeShow(String value, dynamic type, bool? checkThisDay) {
  var timeNow = DateTime.now();
  var dayNow = timeNow.day;

  var year = value.substring(0, 4);
  var month = value.substring(5, 7);
  var day = value.substring(8, 10);
  var hour = value.substring(11, 13);
  var min = value.substring(14, 16);

  switch (type) {
    case 'dMy':
      if (dayNow.toString() == '${int.parse(day)}/${int.parse(month)}/$year' &&
          checkThisDay == true) {
        return '$hour/$min';
      } else {
        return '$day/$month/$year';
      }
    case 'hM':
      return '$hour/$min';
    default:
      break;
  }
}

String formatDuration(Duration duration) {
  String twoDigits(int n) => n >= 10 ? "$n" : "0$n";
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}
