import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spaces/spaces.dart';

export 'buildcontext.dart';
export 'color.dart';
export 'materialstateproperty.dart';
export 'page_controller.dart';
export 'widget.dart';

extension SpacingDataScreenInsets on BuildContext {
  EdgeInsets screenInsets() => spacing().insets.exceptBottom.semiBig;
}

extension ThemeDataFromContext on BuildContext {
  ThemeData theme() => Theme.of(this);
}

extension MediaqueryFromContext on BuildContext {
  MediaQueryData media() => MediaQuery.of(this);
}

final pDefaults = Provider<IDefaults>(
  (ref) => throw UnimplementedError('no Defaults set yet'),
);

abstract class IDefaults {
  const IDefaults();

  Duration get pageTransitionDuration;
  Curve get pageTransitionCurve;

  Duration get animationDuration;
  Curve get animationCurve;

  double get flatElevation;
  double get idleElevation;
  double get highElevation;

  double get smallPadding;
  double get normalPadding;
  double get largePadding;

  BorderRadius get smallBorderRadius;
  BorderRadius get borderRadius;
  BorderRadius get largeBorderRadius;
}

class Defaults extends StatelessWidget {
  final IDefaults defaults;
  final Widget child;

  const Defaults({
    Key? key,
    required this.defaults,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        pDefaults.overrideWithValue(defaults),
      ],
      child: child,
    );
  }
}

abstract class IAppWidgetsFactory {
  const IAppWidgetsFactory();
  Widget loadingIndicator({Stream? progress});
  Widget exceptionIndicator(Exception exception);
  Widget emptyIndicator({String? forSubject});
  Widget nothingFoundIndicator({String? forSubject});
}

class AppWidgets extends StatelessWidget {
  final IAppWidgetsFactory widgets;
  final Widget child;

  const AppWidgets({
    Key? key,
    required this.widgets,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        pAppWidgets.overrideWithValue(widgets),
      ],
      child: child,
    );
  }
}

final pAppWidgets = Provider<IAppWidgetsFactory>(
  (ref) => throw UnimplementedError('no appwidgets set yet'),
);

extension AppWidgetsRef on WidgetRef {
  IAppWidgetsFactory widgets() => read(pAppWidgets);
}

@immutable
abstract class ExplainableException implements Exception {
  factory ExplainableException.fromTime(DateTime time) =
      _ExplainableExceptionFromTime;

  final DateTime throwTime = DateTime.now();

  String explain<T>(T localizations);

  @override
  String toString() => '$throwTime;$hashCode';

  @override
  bool operator ==(Object other) =>
      (other is ExplainableException) && (other.throwTime == throwTime);

  @override
  int get hashCode => throwTime.hashCode;
}

// ignore: avoid_implementing_value_types
class _ExplainableExceptionFromTime implements ExplainableException {
  _ExplainableExceptionFromTime(this.time);

  final DateTime time;

  @override
  String explain<Null>(dynamic _) => '$time';

  @override
  DateTime get throwTime => time;
}
