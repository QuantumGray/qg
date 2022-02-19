import 'package:flutter/material.dart';

class FlexBuilder extends StatefulWidget {
  const FlexBuilder({
    this.changeCallback,
    required this.builder,
  });

  final void Function(Orientation orientation, BoxConstraints constraints)?
      changeCallback;
  final Widget Function(
    BuildContext context,
    Orientation orientation,
    BoxConstraints constraints,
  ) builder;

  @override
  _FlexBuilderState createState() => _FlexBuilderState();
}

class _FlexBuilderState extends State<FlexBuilder> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (_, orientation) => LayoutBuilder(
        builder: (context, constraints) {
          if (widget.changeCallback != null) {
            // ignore: prefer_null_aware_method_calls
            widget.changeCallback!(
              orientation,
              constraints,
            );
          }
          return widget.builder(context, orientation, constraints);
        },
      ),
    );
  }
}
