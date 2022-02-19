import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieSwitch extends StatefulWidget {
  final bool switchValue;
  final String asset;
  const LottieSwitch({
    Key? key,
    required this.asset,
    required this.switchValue,
  }) : super(key: key);

  @override
  _LottieSwitchState createState() => _LottieSwitchState();
}

class _LottieSwitchState extends State<LottieSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.switchValue;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      value: value ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(LottieSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.switchValue != value) {
      controller.twist();
      value = widget.switchValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LottieBuilder.asset(
      widget.asset,
      controller: controller,
    );
  }
}

extension AnimationSwitch on AnimationController {
  void twist() {
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.forward) {
      reverse();
    } else if (status == AnimationStatus.reverse ||
        status == AnimationStatus.dismissed) {
      forward();
    }
  }
}
