import 'package:flutter/material.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';

class AppDefaults extends IDefaults {
  const AppDefaults();

  @override
  Curve get animationCurve => Curves.ease;
  @override
  Duration get animationDuration => const Duration(milliseconds: 420);

  @override
  Curve get pageTransitionCurve => Curves.ease;
  @override
  Duration get pageTransitionDuration => const Duration(milliseconds: 320);

  @override
  double get flatElevation => 6;
  @override
  double get idleElevation => 10;
  @override
  double get highElevation => 14;

  @override
  double get smallPadding => 7;
  @override
  double get normalPadding => 12;
  @override
  double get largePadding => 17;

  @override
  BorderRadius get smallBorderRadius => BorderRadius.circular(smallPadding);
  @override
  BorderRadius get borderRadius => BorderRadius.circular(normalPadding);
  @override
  BorderRadius get largeBorderRadius => BorderRadius.circular(largePadding);
}
