import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

class HorizontalSliverList extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets listPadding;
  final Widget? divider;

  const HorizontalSliverList({
    Key? key,
    required this.children,
    this.listPadding = const EdgeInsets.all(8),
    this.divider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPinnedHeader(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: listPadding,
          child: Row(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1) addDivider(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget addDivider() =>
      divider ?? const Padding(padding: EdgeInsets.symmetric(horizontal: 8));
}
