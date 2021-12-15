import 'dart:ui';
import 'package:flutter/material.dart';

Future<T?> showTransparentDialog<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) =>
    showDialog<T>(
      context: context,
      barrierColor: Colors.white.withOpacity(.5),
      builder: (context) => TransparentBackground(child: builder(context)),
    );

Future<T?> showTransparentBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) =>
    showModalBottomSheet<T>(
      context: context,
      barrierColor: Colors.white.withOpacity(.5),
      clipBehavior: Clip.none,
      builder: (context) =>
          TransparentBackground(bottomSheet: true, child: builder(context)),
    );

Future<T?> showTransparentModalBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) =>
    showModalBottomSheet<T>(
      context: context,
      barrierColor: Colors.white.withOpacity(.5),
      builder: (context) =>
          TransparentBackground(bottomSheet: true, child: builder(context)),
    );

class TransparentBackground extends StatelessWidget {
  final Widget child;
  final bool bottomSheet;

  const TransparentBackground({
    Key? key,
    required this.child,
    this.bottomSheet = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5.0,
        sigmaY: 5.0,
      ),
      child: Center(
        child: Material(
          shape: const RoundedRectangleBorder(),
          clipBehavior: Clip.hardEdge,
          elevation: 8,
          child: child,
        ),
      ),
    );
  }
}
