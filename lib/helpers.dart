import 'dart:convert';
import 'dart:developer' as developer;

void consoleLog(String? name, dataLog, [StackTrace? stackTrace]) {
  // khai báo: consoleLog(null, dataDetail, StackTrace.current); nếu muốn in ra dòng và file chứa consoleLog
  if (stackTrace != null) {
    stackTrace;
    final traceString = stackTrace.toString().split('\n');
    //in ra dòng
    try {
      //in ra dataLog đầy đủ, không bị giới hạn ký tự trên terminal như print
      print(traceString[0].split(RegExp(r'[()]'))[1]);
      developer.log(dataLog is String ? dataLog : jsonEncode(dataLog),
          name: '');
    } catch (e) {
      print('Kiểu dữ liệu truyền vào không phù hợp');
    }
  } else {
    // khai báo tên name của consoleLog
    try {
      developer.log(dataLog is String ? dataLog : jsonEncode(dataLog),
          name: name ?? 'log');
    } catch (e) {
      print('Kiểu dữ liệu truyền vào không phù hợp');
    }
  }
}
