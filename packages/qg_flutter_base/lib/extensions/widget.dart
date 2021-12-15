import 'dart:ui';

import 'package:flutter/material.dart';

extension Sliverable on Widget {
  SliverToBoxAdapter get sliver => SliverToBoxAdapter(child: this);

  ScrollView get scrollView => CustomScrollView(
        slivers: [sliver],
      );
}

extension ListWidget on List<Widget> {
  List<Widget> putBetween(Widget child) => () {
        final list = expand(
          (widget) => [
            widget,
            child,
          ],
        ).toList()
          ..removeLast();

        return list;
      }();
}

extension GlassWidget<T extends Widget> on T {
  ClipRRect asGlass({
    double blurX = 10.0,
    double blurY = 10.0,
    Color tintColor = Colors.white,
    bool frosted = true,
    BorderRadius? clipBorderRadius = BorderRadius.zero,
    Clip clipBehaviour = Clip.antiAlias,
    TileMode tileMode = TileMode.clamp,
    CustomClipper<RRect>? clipper,
  }) {
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
          child: this,
        ),
      ),
    );
  }
}
