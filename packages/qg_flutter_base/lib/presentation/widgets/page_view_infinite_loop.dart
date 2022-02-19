import 'package:flutter/material.dart';

class PageViewInfiniteLoop<T> extends StatefulWidget {
  final List<T> content;
  final Widget Function(T content) builder;

  const PageViewInfiniteLoop({
    Key? key,
    required this.builder,
    required this.content,
  }) : super(key: key);

  @override
  _PageViewInfiniteLoopState createState() => _PageViewInfiniteLoopState();
}

class _PageViewInfiniteLoopState extends State<PageViewInfiniteLoop> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.content;
    final length = content.length;
    return PageView.builder(
      itemBuilder: (context, index) {
        final contentIndex = index % length;
        return widget.builder(content[contentIndex]);
      },
    );
  }
}
