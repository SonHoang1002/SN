import 'package:intl/intl.dart';

String formatCurrency(dynamic number) {
  final formatter = NumberFormat('#,##0', 'vi_VN');
  return formatter.format(int.parse(number.toStringAsFixed(0)));
}
