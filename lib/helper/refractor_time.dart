import 'package:intl/intl.dart';

/// chuyển đổi 2024-03-22T00:00:00.000+07:00 sang dạng 22 - 3 - 2024
String getRefractorTime(String preTime, {String? pattern = "dd 'tháng' MM 'lúc' HH:mm" }) {
  // "'Lúc' HH:mm 'ngày' dd' - 'MM' - 'yyyy"
  return DateFormat(pattern).format(DateTime.parse(preTime));
}
