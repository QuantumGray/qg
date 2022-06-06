import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:qg_flutter_base/widgets/page_indicator.dart';

class IndicatedPageView extends HookWidget {
  final List<Widget> children;
  final PageController? controller;
  final Alignment? indicatorAlignment;
  final Duration animationDuration;
  final Curve animationCurve;
  final void Function(int index)? onPageChanged;
  final Widget? background;

  const IndicatedPageView({
    required this.children,
    this.controller,
    this.indicatorAlignment,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeIn,
    this.onPageChanged,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    // final localizations = context.localizations;
    // final theme = Theme.of(context);
    final controller = this.controller ?? usePageController();
    final indicatorAlignment = this.indicatorAlignment ?? Alignment.topCenter;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (background != null)
          Positioned.fill(
            child: background!,
          ),
        Positioned.fill(
          child: PageView(
            controller: controller,
            onPageChanged: onPageChanged,
            children: children,
          ),
        ),
        Align(
          alignment: indicatorAlignment,
          child: PageIndicator(
            pageController: controller,
            pageCount: children.length,
          ),
        ),
        Positioned.fill(
          child: Row(
            children: [
              GestureDetector(
                onTap: () => controller.nextPage(
                  duration: animationDuration,
                  curve: animationCurve,
                ),
              ),
              GestureDetector(
                onTap: () => controller.previousPage(
                  duration: animationDuration,
                  curve: animationCurve,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
