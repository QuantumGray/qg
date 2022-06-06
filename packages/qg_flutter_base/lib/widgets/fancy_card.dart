import 'dart:math';

import 'package:flutter/material.dart';

class FancyCard extends StatefulWidget {
  final double height;
  final double width;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Widget child;
  final bool dragAllowed;
  final bool autoMove;
  final Duration animDuration;
  final double dragMoveAmplitude;
  final String? heroTag;
  final Offset? initialAngle;
  const FancyCard({
    Key? key,
    required this.child,
    this.initialAngle,
    this.dragAllowed = true,
    this.autoMove = true,
    this.width = 300.0,
    this.height = 300.0,
    this.borderRadius = 20.0,
    this.animDuration = const Duration(seconds: 5),
    this.dragMoveAmplitude = .001,
    this.heroTag,
    Color? backgroundColor,
    Color? borderColor,
  })  : backgroundColor = backgroundColor ?? const Color(0xFF180e43),
        borderColor = borderColor ?? const Color(0xFF2fd6e8),
        super(key: key);
  @override
  _FancyCardState createState() => _FancyCardState();
}

class _FancyCardState extends State<FancyCard>
    with SingleTickerProviderStateMixin {
  late Offset _angle;
  late AnimationController _animController;
  late double dragMoveAmplitude;
  Matrix4 get _cardTransformation => Matrix4.identity()
    ..setEntry(3, 2, 0.0011) // perspective
    ..rotateX(_angle.dx)
    ..rotateY(_angle.dy);
  // Offset get _shadowOffset => Offset(_angle.dy, -_angle.dx).scale(10, 10);
  double get _shinePosition => 0.3 - _angle.dy - _angle.dx * 2;
  @override
  void initState() {
    super.initState();
    _angle = widget.initialAngle ?? Offset.zero;
    _animController = AnimationController(
      vsync: this,
      duration: widget.animDuration,
      value: 0,
    );
    _animController.addListener(() {
      setState(() {
        final val = 2 * pi * _animController.value;
        _angle = Offset(cos(val), sin(pi / 3 + val)).scale(0.2, 0.6);
      });
    });
    // _animController.repeat();
    dragMoveAmplitude = 1 / widget.dragMoveAmplitude;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _angle += Offset(
        details.delta.dy / dragMoveAmplitude,
        -details.delta.dx / dragMoveAmplitude,
      );
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {},
      onPanUpdate: widget.dragAllowed ? _onPanUpdate : null,
      behavior: HitTestBehavior.translucent,
      child: Transform(
        alignment: Alignment.center,
        transform: _cardTransformation,
        // CARD
        child: Hero(
          tag: widget.heroTag ?? hashCode.toString(),
          child: Container(
            width: widget.width,
            height: widget.height,
            alignment: Alignment.center,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Content
                Positioned.fill(child: widget.child),
                // Shine
                Container(
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(widget.borderRadius),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft, // const Alignment(-1.0, -1.0),
                      end: Alignment.bottomRight, // const Alignment(1.0, 1.0),
                      stops: [
                        _shinePosition - 1,
                        _shinePosition,
                        _shinePosition + 1
                      ],
                      colors: [
                        Colors.white.withOpacity(0),
                        Colors.white30,
                        Colors.white.withOpacity(0)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
