// ignore_for_file: prefer_null_aware_method_calls

import 'package:flutter/material.dart';

class Selectable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSelect;
  final VoidCallback? onDeselect;
  final BoxDecoration Function(bool selected)? decorator;
  final Duration? transitionDuration;

  const Selectable({
    Key? key,
    required this.child,
    this.onSelect,
    this.onDeselect,
    this.decorator,
    this.transitionDuration,
  }) : super(key: key);

  @override
  _SelectableState createState() => _SelectableState();
}

class _SelectableState extends State<Selectable> {
  bool selected = false;

  @override
  void initState() {
    super.initState();
    selected = false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: AnimatedContainer(
              duration: widget.transitionDuration ??
                  const Duration(milliseconds: 200),
              constraints: const BoxConstraints.expand(),
              decoration: widget.decorator?.call(selected) ??
                  BoxDecoration(
                    color:
                        selected ? Colors.greenAccent.withOpacity(0.5) : null,
                    borderRadius: BorderRadius.circular(20),
                    border: selected
                        ? Border.all(width: 3, color: Colors.greenAccent)
                        : null,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTap() {
    if (selected) {
      if (widget.onSelect != null) widget.onSelect!();
      setState(() {
        selected = true;
      });
    } else {
      if (widget.onDeselect != null) widget.onDeselect!();
      setState(() {
        selected = false;
      });
    }
  }
}
