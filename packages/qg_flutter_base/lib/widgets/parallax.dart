import 'package:flutter/material.dart';

class Parallax extends StatefulWidget {
  final PageController controller;
  final int index;
  final double factor;
  final Widget child;

  const Parallax({
    Key? key,
    required this.controller,
    required this.index,
    required this.child,
    this.factor = 1,
  }) : super(key: key);

  @override
  _ParallaxState createState() => _ParallaxState();
}

class _ParallaxState extends State<Parallax> {
  double pageOffset = 0;
  bool disposed = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      if (disposed) return;
      if (!widget.controller.position.haveDimensions ||
          !widget.controller.hasClients) return;
      setState(() {
        pageOffset = widget.controller.page!;
      });
    });
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(
        (-pageOffset.abs() + widget.index) * widget.factor,
        0,
      ),
      child: widget.child,
    );
  }
}
