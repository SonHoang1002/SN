import 'package:intl/intl.dart';

/// chuyển đổi 2024-03-22T00:00:00.000+07:00 sang dạng 22 - 3 - 2024
String getRefractorTime(String preTime,
    {String? pattern = "dd 'tháng' MM 'lúc' HH:mm"}) {
  String patternHaverYear = ("dd 'tháng' MM 'năm' yyyy");

  DateTime currentTime = DateTime.now();
  DateTime parsedTime = DateTime.parse(preTime);
  DateTime oneYearAgo = currentTime.subtract(const Duration(days: 365));

  Duration difference = currentTime.difference(parsedTime);

  if (difference < const Duration(minutes: 1)) {
    if (difference.inSeconds >= 0) {
      int seconds = difference.inSeconds;
      return "$seconds giây trước";
    } else {
      return "Hết hạn";
    }
  } else if (difference < const Duration(hours: 1)) {
    int hours = difference.inMinutes;
    return "$hours phút trước";
  } else if (difference < const Duration(days: 1)) {
    int hours = difference.inHours;
    return "$hours giờ trước";
  } else if (difference < const Duration(days: 7)) {
    int days = difference.inDays;
    return "$days ngày trước";
  } else if (difference < const Duration(days: 30)) {
    int weeks = (difference.inDays / 7).floor();
    return "$weeks tuần trước";
  } else if (difference < const Duration(days: 365)) {
    int months = (difference.inDays / 30).floor();
    return "$months tháng trước";
  } else if (parsedTime.isBefore(oneYearAgo)) {
    return DateFormat(patternHaverYear).format(parsedTime);
  } else {
    return DateFormat(pattern).format(parsedTime);
  }
}
