import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:qg_flutter_base/presentation/presentation.dart';

class IndicatorScaffold extends HookWidget {
  final String? lottie;
  final String? label;
  final VoidCallback? callback;
  final String? callbackLabel;

  const IndicatorScaffold({
    this.lottie,
    this.label,
    this.callback,
    this.callbackLabel,
  });

  @override
  Widget build(BuildContext context) {
    assert(!(callback != null) || callbackLabel != null);
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (lottie != null) LottieBuilder.asset(lottie!),
        if (label != null) Text(label!, style: theme.textTheme.headline3),
        if (callback != null)
          ElevatedButton(
            onPressed: callback,
            child: Text(
              callbackLabel!,
              style: theme.textTheme.button,
            ),
          )
      ],
    );
  }
}

class ExceptionIndicator extends HookWidget {
  const ExceptionIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IndicatorScaffold();
  }
}

class ExceptionRetryIndicator extends HookWidget {
  final VoidCallback? retryCallback;
  final Object? exception;

  const ExceptionRetryIndicator({
    required this.retryCallback,
    required this.exception,
  });

  @override
  Widget build(BuildContext context) {
    return IndicatorScaffold();
  }
}

class EmptyIndicator extends StatelessWidget {
  const EmptyIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IndicatorScaffold();
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IndicatorScaffold();
  }
}
