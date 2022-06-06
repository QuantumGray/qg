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
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, _, __) => builder(context),
        opaque: false,
        barrierColor: Colors.grey.withOpacity(.1),
        barrierDismissible: true,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.ease;
          final curveTween = CurveTween(curve: curve);
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end).chain(curveTween);
          final offsetAnimation = animation.drive(tween);
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: SlideTransition(
              position: offsetAnimation,
              child: child,
            ),
          );
        },
      ),
    );

Future<T?> showTransparentModalBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  bool isScrollControlled = false,
}) =>
    showModalBottomSheet<T>(
      context: context,
      barrierColor: Colors.white.withOpacity(.5),
      isScrollControlled: isScrollControlled,
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
