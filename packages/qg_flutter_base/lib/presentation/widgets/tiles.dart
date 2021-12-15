import 'package:flutter/material.dart';

class Tiles extends StatelessWidget {
  final double _aspectRatio;
  final Widget child;

  const Tiles.square({
    required this.child,
  }) : _aspectRatio = 1;

  const Tiles.banner({
    required this.child,
  }) : _aspectRatio = 10 / 23;

  const Tiles.tile({
    required this.child,
  }) : _aspectRatio = 16 / 9;
  const Tiles.bar({
    required this.child,
  }) : _aspectRatio = 29 / 10;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _aspectRatio,
      child: child,
    );
  }
}
