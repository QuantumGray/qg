import 'package:flutter/material.dart';
import 'package:qg_flutter_base/base/theme/base_theme.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';
import 'package:qg_flutter_base/presentation/presentation.dart';

final pThemeNotifier = ChangeNotifierProvider<ThemeNotifier>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends ChangeNotifier {
  ThemeNotifier();

  late BaseTheme _baseTheme;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setBaseTheme(BaseTheme value, [bool notify = true]) {
    _baseTheme = value;
    if (notify) {
      notifyListeners();
    }
  }

  void setThemeMode(ThemeMode value) {
    _themeMode = value;
    notifyListeners();
  }

  ThemeData dark(BaseDefaults defaults, BaseWidgets widgets) =>
      _baseTheme.build(
        _baseTheme.colorSchemeBuilder(Brightness.dark),
        defaults,
        widgets,
      );

  ThemeData light(BaseDefaults defaults, BaseWidgets widgets) =>
      _baseTheme.build(
        _baseTheme.colorSchemeBuilder(Brightness.light),
        defaults,
        widgets,
      );

  ThemeData from(
    Brightness brightness,
    BaseDefaults defaults,
    BaseWidgets widgets,
  ) =>
      _baseTheme.build(
        _baseTheme.colorSchemeBuilder(brightness),
        defaults,
        widgets,
      );

  ThemeData mode(
    BaseDefaults defaults,
    BaseWidgets widgets,
  ) {
    final brightness = _themeMode == ThemeMode.system
        ? Brightness.light
        : _themeMode == ThemeMode.light
            ? Brightness.light
            : Brightness.dark;

    return from(brightness, defaults, widgets);
  }
}
