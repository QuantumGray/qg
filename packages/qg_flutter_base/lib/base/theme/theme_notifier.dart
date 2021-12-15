import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  final Brightness systemBrightness;

  ThemeNotifier({required this.systemBrightness});

  final _baseTheme = ThemeData(
    primarySwatch: Colors.grey,
  );

  ThemeData get dark => _baseTheme.copyWith(
        primaryColor: Colors.black,
        brightness: Brightness.dark,
        backgroundColor: const Color(0xFF212121),
        dividerColor: Colors.black12,
      );

  ThemeData get light => _baseTheme.copyWith(
        primaryColor: Colors.white,
        brightness: Brightness.light,
        backgroundColor: const Color(0xFFE5E5E5),
        dividerColor: Colors.white54,
      );

  // ThemeData get theme =>
  //     ((Hive.box('theme-mode').get('main') ?? systemBrightness) ==
  //             Brightness.light)
  //         ? light
  //         : dark;
  // // notifyListeners();

  // String? get preferredThemeMode => Hive.box<String>('theme-mode').get('main');

  // void setThemeMode(ThemeMode mode) {
  //   switch (mode) {
  //     case ThemeMode.light:
  //       Hive.box<String>('theme-mode').put('main', 'light');
  //       break;
  //     case ThemeMode.dark:
  //       Hive.box<String>('theme-mode').put('main', 'dark');
  //       break;
  //     case ThemeMode.system:
  //       Hive.box<String>('theme-mode').put('main', 'system');
  //       break;
  //   }
  //   notifyListeners();
  // }
}
