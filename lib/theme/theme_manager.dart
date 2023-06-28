import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  getThemeInitial(value) {
    themeMode = value == 'dark'
        ? ThemeMode.dark
        : value == 'light'
            ? ThemeMode.light
            : ThemeMode.system;
    notifyListeners();
  }

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      // ignore: deprecated_member_use
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(type) {
    SecureStorage().saveKeyStorage(type, 'theme');
    themeMode = type == 'dark'
        ? ThemeMode.dark
        : type == 'light'
            ? ThemeMode.light
            : ThemeMode.system;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.grey.shade900,
      cardColor: Colors.grey.shade800,
      primaryColor: Colors.grey.withOpacity(0.6),
      appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade900),
      textTheme: TextTheme(
          displayLarge: const TextStyle(color: white),
          bodySmall: TextStyle(color: Colors.grey.shade300)),
      colorScheme:
          const ColorScheme.dark().copyWith(background: Colors.grey.shade800),
      canvasColor: Colors.black,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      // ignore: deprecated_member_use
      backgroundColor: Colors.white.withOpacity(0.1));

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: white,
      cardColor: white,
      primaryColor: white,
      appBarTheme: const AppBarTheme(backgroundColor: white),
      textTheme: TextTheme(
          displayLarge: const TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.grey.shade800)),
      colorScheme: const ColorScheme.light()
          .copyWith(background: const Color(0xfff1f2f5)),
      canvasColor: const Color(0xfff1f2f5),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      // ignore: deprecated_member_use
      backgroundColor: Colors.black.withOpacity(0.1));
}
