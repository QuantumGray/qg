import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/presentation/widgets/indicators.dart';

final pWidgets = Provider(
  (ref) => Widgets(
    loadingIndicator: (context) => const LoadingIndicator(),
    exceptionIndicator: (context) => const ExceptionIndicator(),
    emptyIndicator: (context) => const EmptyIndicator(),
  ),
);

class Widgets {
  final WidgetBuilder loadingIndicator;
  final WidgetBuilder exceptionIndicator;
  final WidgetBuilder emptyIndicator;

  Widgets({
    required this.loadingIndicator,
    required this.exceptionIndicator,
    required this.emptyIndicator,
  });

  Widgets copyWith({
    WidgetBuilder? loadingIndicator,
    WidgetBuilder? exceptionIndicator,
    WidgetBuilder? emptyIndicator,
  }) =>
      Widgets(
        loadingIndicator: loadingIndicator ?? this.loadingIndicator,
        exceptionIndicator: exceptionIndicator ?? this.exceptionIndicator,
        emptyIndicator: emptyIndicator ?? this.emptyIndicator,
      );
}

class WidgetsOverride {
  final WidgetBuilder? loadingIndicator;
  final WidgetBuilder? exceptionIndicator;
  final WidgetBuilder? emptyIndicator;

  WidgetsOverride({
    this.loadingIndicator,
    this.exceptionIndicator,
    this.emptyIndicator,
  });
}

class WidgetsScope extends ConsumerWidget {
  final Widget child;
  final WidgetsOverride widgets;

  const WidgetsScope({
    Key? key,
    required this.child,
    required this.widgets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widgets = ref.read(pWidgets);
    return ProviderScope(
      overrides: [
        pWidgets.overrideWithValue(
          widgets.copyWith(
            loadingIndicator: widgets.loadingIndicator,
            exceptionIndicator: widgets.exceptionIndicator,
            emptyIndicator: widgets.emptyIndicator,
          ),
        ),
      ],
      child: child,
    );
  }
}
