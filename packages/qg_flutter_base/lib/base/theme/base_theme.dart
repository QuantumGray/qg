import 'package:flutter/material.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';

abstract class BaseTheme {
  final ColorScheme Function(Brightness brightness) colorSchemeBuilder;
  final TextTheme textTheme;

  BaseTheme({
    required this.colorSchemeBuilder,
    required this.textTheme,
  });

  ThemeData build(
    ColorScheme colorScheme,
    BaseDefaults defaults,
    BaseWidgets widgets,
  );
}
