import 'package:flutter/material.dart';

class ItemListAnimator extends StatefulWidget {
  final List<GlobalKey<_ItemAnimatorState>> itemAnimatorKeys;
  final Widget Function(List<Widget> children) listBuilder;
  final Widget Function(Animation animation) childBuilder;
  final Duration? delay;

  const ItemListAnimator({
    Key? key,
    this.itemAnimatorKeys = const [],
    required this.childBuilder,
    required this.listBuilder,
    this.delay,
  }) : super(key: key);

  @override
  _ItemListAnimatorState createState() => _ItemListAnimatorState();
}

class _ItemListAnimatorState extends State<ItemListAnimator> {
  late List<GlobalKey<_ItemAnimatorState>> keys;
  late Duration delay;

  @override
  void initState() {
    super.initState();
    keys = widget.itemAnimatorKeys;
    delay = widget.delay ?? const Duration(milliseconds: 300);
    onInit();
  }

  Future<void> onInit() async {
    for (final key in keys) {
      await Future.delayed(delay);
      key.currentState!.animate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final length = keys.length;

    return widget.listBuilder(
      List.generate(
        length,
        (index) {
          final key = keys[index];
          return ItemAnimator(
            key: key,
            builder: widget.childBuilder,
          );
        },
      ),
    );
  }
}

class ItemAnimator extends StatefulWidget {
  final Widget Function(Animation animation) builder;

  final Duration? duration;

  const ItemAnimator({
    Key? key,
    required this.builder,
    this.duration,
  }) : super(key: key);

  @override
  _ItemAnimatorState createState() => _ItemAnimatorState();
}

class _ItemAnimatorState extends State<ItemAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 300),
    );
    _animation = _controller;
  }

  void animate() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_animation);
  }
}
