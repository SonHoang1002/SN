/// chia chuỗi thành mảng chứa các phần tử nhưng giữ nguyên cả từ khóa split.
///
/// Ví dụ:
///
/// condition = ['1','2','3'];
///
/// string = 'a1s2d3f4g5';
///
/// ==> kết quả: ['a','1','s','2','d','3','f4g5'];
List splitWithConditions(List condition, dynamic value1) {
  final arr = condition;
  String value = value1;
  final pattern = RegExp(arr.join('|'));
  int lastIndex = 0;
  List results = [];
  Iterable<RegExpMatch> matcheLinks = pattern.allMatches(value);
  for (RegExpMatch match in matcheLinks) {
    if (match.start > lastIndex) {
      results.add(value.substring(lastIndex, match.start).trim());
    }
    results.add(match.group(0)!);
    lastIndex = match.end;
  }

  if (lastIndex < value.length) {
    results.add(value.substring(lastIndex).trim());
  }
  return results;
}
