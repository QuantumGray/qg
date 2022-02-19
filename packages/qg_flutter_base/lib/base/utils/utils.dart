import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:timeago/timeago.dart' as timeago;

class Utils {
  static Future<void> tryCatchAsync<E extends Exception>(
    void Function() function,
    void Function(E e) handleE,
  ) async {
    try {
      function();
    } on E catch (e) {
      handleE(e);
    }
  }

  static void tryCatch<E extends Exception>(
    void Function() function,
    void Function(E e) handleE,
  ) {
    try {
      function();
    } on E catch (e) {
      handleE(e);
    }
  }

  static MaterialStateProperty<T> mapMaterialStatesV1<T>({
    required T Function() idle,
    T Function()? disabled,
    T Function()? dragged,
    T Function()? error,
    T Function()? focused,
    T Function()? hovered,
  }) {
    return MaterialStateProperty.resolveWith<T>((_states) {
      if (_states.contains(MaterialState.disabled) && disabled != null) {
        return disabled();
      }
      if (_states.contains(MaterialState.dragged) && dragged != null) {
        return dragged();
      }
      if (_states.contains(MaterialState.error) && error != null) {
        return error();
      }
      if (_states.contains(MaterialState.focused) && focused != null) {
        return focused();
      }
      if (_states.contains(MaterialState.hovered) && hovered != null) {
        return hovered();
      }
      return idle();
    });
  }

  static MaterialStateProperty<T> mapMaterialStatesV2<T>(
    Map<Set<MaterialState>, T> stateMap,
    T fallback,
  ) {
    return MaterialStateProperty.resolveWith<T>((_states) {
      for (final _statesSet in stateMap.entries) {
        if (_statesSet.key.any((_state) => _states.contains(_state))) {
          return _statesSet.value;
        }
      }
      return fallback;
    });
  }

  Map<int, Color> createSwatch(Color color) {
    return {
      50: Color.fromRGBO(color.red, color.green, color.blue, .1),
      100: Color.fromRGBO(color.red, color.green, color.blue, .2),
      200: Color.fromRGBO(color.red, color.green, color.blue, .3),
      300: Color.fromRGBO(color.red, color.green, color.blue, .4),
      400: Color.fromRGBO(color.red, color.green, color.blue, .5),
      500: Color.fromRGBO(color.red, color.green, color.blue, .6),
      600: Color.fromRGBO(color.red, color.green, color.blue, .7),
      700: Color.fromRGBO(color.red, color.green, color.blue, .8),
      800: Color.fromRGBO(color.red, color.green, color.blue, .9),
      900: Color.fromRGBO(color.red, color.green, color.blue, 1),
    };
  }

  String timeAgo(DateTime time) =>
      timeago.format(time, locale: Platform.localeName);

  static String localeName = Platform.localeName;
}

const bool kReleaseMode = false;

class PlatformSupports {
  static bool get camera => Platform.isIOS || Platform.isAndroid;
  static bool get touch => Platform.isIOS || Platform.isAndroid;
  static const bool files = !kIsWeb;
}

final l = Logger();

MaterialColor createMaterialColor(Color color) {
  final List<double> strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red;
  final int g = color.green;
  final int b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (final strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
