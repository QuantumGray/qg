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

  ThemeData dark(IDefaults defaults, IAppWidgetsFactory widgets) =>
      _baseTheme.build(
        _baseTheme.colorSchemeBuilder(Brightness.dark),
        defaults,
        widgets,
      );

  ThemeData light(IDefaults defaults, IAppWidgetsFactory widgets) =>
      _baseTheme.build(
        _baseTheme.colorSchemeBuilder(Brightness.light),
        defaults,
        widgets,
      );

  ThemeData from(
    Brightness brightness,
    IDefaults defaults,
    IAppWidgetsFactory widgets,
  ) =>
      _baseTheme.build(
        _baseTheme.colorSchemeBuilder(brightness),
        defaults,
        widgets,
      );

  ThemeData mode(
    IDefaults defaults,
    IAppWidgetsFactory widgets,
  ) {
    final brightness = _themeMode == ThemeMode.system
        ? Brightness.light
        : _themeMode == ThemeMode.light
            ? Brightness.light
            : Brightness.dark;

    return from(brightness, defaults, widgets);
  }
}
