import 'dart:ui';

import 'package:flutter/material.dart';

class Glass extends StatelessWidget {
  final double blurX;
  final double blurY;
  final Color tintColor;
  final bool frosted;
  final BorderRadius? clipBorderRadius;
  final Clip clipBehaviour;
  final TileMode tileMode;
  final CustomClipper<RRect>? clipper;
  final Widget child;

  const Glass({
    Key? key,
    this.blurX = 10,
    this.blurY = 10,
    this.tintColor = Colors.grey,
    this.frosted = true,
    this.clipBorderRadius = BorderRadius.zero,
    this.clipBehaviour = Clip.antiAlias,
    this.tileMode = TileMode.clamp,
    this.clipper,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipper: clipper,
      clipBehavior: clipBehaviour,
      borderRadius: clipBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurX,
          sigmaY: blurY,
          tileMode: tileMode,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: (tintColor != Colors.transparent)
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      tintColor.withOpacity(0.1),
                      tintColor.withOpacity(0.08),
                    ],
                  )
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
