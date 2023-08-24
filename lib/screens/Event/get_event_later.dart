import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';

class GetTimeLater {
  static String _defaultLocale = 'vi';

  static final Map<String, Messages> _messageMap = {
    'ar': ArabicMessages(),
    'en': EnglishMessages(),
    'es': EspanaMessages(),
    'fa': PersianMessages(),
    'fr': FrenchMessages(),
    'hi': HindiMessages(),
    'pt': PortugueseBrazilMessages(),
    'br': PortugueseBrazilMessages(),
    'zh': SimplifiedChineseMessages(),
    'zh_tr': TraditionalChineseMessages(),
    'ja': JapaneseMessages(),
    'oc': OccitanMessages(),
    'ko': KoreanMessages(),
    'de': GermanMessages(),
    'id': IndonesianMessages(),
    'tr': TurkishMessages(),
    'ur': UrduMessages(),
    'vi': VietnameseMessages(),
  };

  static void setDefaultLocale(String locale) {
    assert(
      _messageMap.containsKey(locale),
      '[locale] must be a valid locale',
    );
    _defaultLocale = locale;
  }

  static void setCustomLocaleMessages(
    String customLocale,
    Messages customMessages,
  ) {
    _messageMap[customLocale] = customMessages;
  }

  static String parse(
    String dateString,
    DateTime dateTime, {
    String? locale,
    String? pattern,
  }) {
    final _locale = locale;
    final _message = _messageMap[_locale] ?? VietnameseMessages();
    final _pattern = pattern ?? "dd MMM, yyyy hh:mm aa";
    final date = DateFormat(_pattern).format(dateTime);
    var _currentClock = DateTime.now();
    var elapsed =
        (_currentClock.millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch)
            .abs();
    var _today = "Hôm nay vào";
    var _tommorow = "Ngày mai vào";

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;
    final num days = hours / 24;

    String msg;
    String result;

    if (hours < 24) {
      String timePart = formatTime(dateString.substring(11, 16));
      result = [_today, timePart]
          .where((res) => res.isNotEmpty)
          .join(_message.wordSeparator());
    } else if (hours < 48) {
      String timePart = formatTime(dateString.substring(11, 16));
      result = [_tommorow, timePart]
          .where((res) => res.isNotEmpty)
          .join(_message.wordSeparator());
    } else {
      msg = date;
      result = date;
    }

    return result;
  }
}

String formatTime(String time) {
  int hour = int.parse(time.substring(0, 2));
  int minute = int.parse(time.substring(3, 5));

  String period = hour >= 12 ? "PM" : "AM";

  if (hour > 12) {
    hour -= 12;
  }
  String formattedHour = hour < 10 ? "0$hour" : hour.toString();
  String formattedMinute = minute < 10 ? "0$minute" : minute.toString();
  return "$formattedHour:$formattedMinute $period";
}

String eventDate(dateString) {
  DateTime targetDate = DateTime.parse(dateString);
  DateTime currentDate = DateTime.now();

  if (targetDate.isBefore(currentDate)) {
    return GetTimeAgo.parse(DateTime.parse(dateString));
  } else if (targetDate.isAfter(currentDate)) {
    return GetTimeLater.parse(dateString, DateTime.parse(dateString));
  } else {
    return GetTimeAgo.parse(DateTime.parse(dateString));
  }
}
