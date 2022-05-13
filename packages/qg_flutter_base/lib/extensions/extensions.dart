import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'buildcontext.dart';
export 'color.dart';
export 'materialstateproperty.dart';
export 'page_controller.dart';
export 'widget.dart';

final pDefaults = Provider<BaseDefaults>(
  (ref) => throw UnimplementedError('no Defaults set yet'),
);

abstract class BaseDefaults {
  const BaseDefaults();

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
  final BaseDefaults defaults;
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

abstract class BaseWidgets {
  const BaseWidgets();
  Widget loadingIndicator({Stream? progress});
  Widget exceptionIndicator(Exception exception);
  Widget emptyIndicator({String? forSubject});
  Widget nothingFoundIndicator({String? forSubject});
}

class Widgets extends ConsumerWidget {
  final Widget child;
  final BaseWidgets widgets;

  const Widgets({
    Key? key,
    required this.child,
    required this.widgets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widgets = ref.read(pWidgets);
    return ProviderScope(
      overrides: [
        pWidgets.overrideWithValue(widgets),
      ],
      child: child,
    );
  }
}

final pWidgets = Provider<BaseWidgets>(
  (ref) => throw UnimplementedError('no appwidgets set yet'),
);
