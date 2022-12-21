dynamic dateFromNow(DateTime tm) {
  DateTime today = DateTime.now();
  Duration oneDay = const Duration(days: 1);
  Duration twoDay = const Duration(days: 2);
  Duration oneWeek = const Duration(days: 7);
  String month = 'Tháng ${tm.month}';

  Duration difference = today.difference(tm);

  if (difference.compareTo(oneDay) < 1) {
    return "Hôm nay";
  } else if (difference.compareTo(twoDay) < 1) {
    return "Hôm qua";
  } else if (difference.compareTo(oneWeek) < 1) {
    switch (tm.weekday) {
      case 1:
        return "Thứ 2";
      case 2:
        return "Thứ 3";
      case 3:
        return "Thứ 4";
      case 4:
        return "Thứ 5";
      case 5:
        return "Thứ 6";
      case 6:
        return "Thứ 7";
      case 7:
        return "Chủ nhật";
    }
  } else if (tm.year == today.year) {
    return '${tm.day} $month';
  } else {
    return '${tm.day} $month ${tm.year}';
  }
}
