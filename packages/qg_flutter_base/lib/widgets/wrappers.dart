import 'package:flutter/material.dart';

class Wrappers extends StatelessWidget {
  final List<Wrapper> wrappers;
  final Widget child;

  const Wrappers({
    Key? key,
    required this.child,
    required this.wrappers,
  }) : super(key: key);

  int get wrappersCount => wrappers.length;

  @override
  Widget build(BuildContext context) {
    late Widget widget;
    for (int i = 0; i < wrappersCount; i++) {
      widget = Builder(
        builder: (context) {
          return wrappers[i](context, (wrappersCount == i) ? widget : child);
        },
      );
    }
    if (wrappersCount == 0) {
      widget = child;
    }
    return widget;
  }
}

typedef Wrapper = Widget Function(BuildContext context, Widget child);
