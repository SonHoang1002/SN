import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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

String? handleTimeShow(String value) {
  DateTime time = DateTime.parse(value);
  DateTime currentDate = DateTime.now();
  Duration timeDiff = currentDate.difference(time);
  int diffInDays = timeDiff.inDays;
  int yearTime = time.year;
  int yearNow = DateTime.now().year;

  if (yearTime == yearNow) {
    String timeShow = DateFormat('MMM d, yyyy, hh:mm a').format(
      time,
    );

    if (diffInDays < 7) {
      return '${diffInDays} ngày';
    } else if (diffInDays >= 7 && diffInDays < 14) {
      return '${diffInDays} tuần';
    } else if (diffInDays >= 14) {
      return '${(diffInDays / 7).floor()} tuần';
    }
  }
}

String formatDateTimeToStringDateTimeYear(DateTime dateTime) {
  return DateFormat('dd/MM/yyyy').format(dateTime);
}

String convertISO8086toLTime(DateTime dateTime) {
  return DateFormat('HH:mm').format(dateTime);
}

String formatTimeMediaPlayer(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");

  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
}

classifyTypeMessage(message) {
  if (message['urls'] != null && message['urls'].length > 0) {
    if (message['urls'].elementAt(0)["headers"] != null &&
        message['urls'].elementAt(0)["headers"]["contentType"] ==
            'text/html;charset=utf-8') {
      return 'link';
    } else if (message['urls'].elementAt(0)["headers"] != null &&
            message['urls'].elementAt(0)["headers"]["contentType"] ==
                'image/gif' ||
        message['urls'].elementAt(0)['url'].contains('giphy')) {
      if (message['urls'].elementAt(0)['url'].contains('mojitok')) {
        return 'sticky';
      } else {
        return 'gif';
      }
    } else if (message['msg'].contains('mojitok') &&
        message['msg'].contains('gif')) {
      return 'sticky';
    } else if (message['urls'].elementAt(0)["ignoreParse"] == true) {
      return 'reply';
    } else {
      return 'text';
    }
  } else if (message['file'] != null) {
    return message['file']['type']?.split('/').elementAt(0) ?? 'message';
  } else {
    return "message";
  }
}

// ignore: unnecessary_question_mark
renderMessageText(text, listMention, objectItem) {
  if (listMention['t'] == 'p') {
    List members = listMention['members'] ?? [];
    String newText = text;
    for (var element in [
      {
        "_id": "111111111111111111",
        "name": "Tất cả",
      },
      ...members
    ]) {
      newText = newText.replaceAll('@${element['_id']}', '@${element['name']}');
    }
    return newText;
  } else {
    if (objectItem != null && classifyTypeMessage(objectItem) == 'reply') {
      return text.toString().split(' ').sublist(2).join(' ');
    } else {
      return text;
    }
  }
}

String readTimestamp(int timestamp, String firstText) {
  var now = DateTime.now();
  var format = DateFormat('HH:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    if (diff.inHours > 0 && diff.inHours < 24) {
      time = '$firstText ${diff.inHours} giờ trước';
    } else if (diff.inMinutes > 1 && diff.inMinutes < 60) {
      time = '$firstText ${diff.inMinutes} phút trước';
    } else {
      time = format.format(date);
    }
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = '$firstText ${diff.inDays} ngày trước';
    } else {
      time = '$firstText ${diff.inDays} ngày trước';
    }
  } else {
    if (diff.inDays == 7) {
      time = '$firstText ${(diff.inDays / 7).floor()} tuần trước';
    } else {
      time = '$firstText ${(diff.inDays / 7).floor()} tuần trước';
    }
  }

  return time;
}

String formatCurrency(dynamic number) {
  final formatter = NumberFormat('#,##0', 'vi_VN');
  return formatter.format(int.parse(number.toStringAsFixed(0)));
}

TextStyle customIbmPlexSans(TextStyle textStyle) {
  return GoogleFonts.ibmPlexSans(textStyle: textStyle);
}
