import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';

class Mask extends StatelessWidget {
  final BoxFit fit;
  final Widget background;
  final Widget mask;
  final BlendMode blendMode;
  final bool childSaveLayer;

  const Mask({
    Key? key,
    required this.background,
    required this.mask,
    this.childSaveLayer = false,
    this.blendMode = BlendMode.srcOver,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetMask(
      blendMode: blendMode,
      childSaveLayer: childSaveLayer,
      mask: FittedBox(fit: fit, child: background),
      child: mask,
    );
  }
}
