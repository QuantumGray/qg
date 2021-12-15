import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    Key? key,
    required this.pageController,
    required this.pageCount,
    this.effect = IndicatorEffects.worm,
    this.onDotClicked,
    this.dotSpacing = 10,
    this.dotHeight = 4,
    this.activeDotColor,
    this.dotColor,
    this.dotWidth,
  }) : super(key: key);

  final PageController pageController;
  final int pageCount;
  final double dotSpacing;
  final double dotHeight;
  final IndicatorEffects effect;
  final void Function(int)? onDotClicked;
  final Color? activeDotColor;
  final Color? dotColor;
  final double? dotWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final _dotSpacingDeficitPerDot = dotSpacing / (pageCount - 1);
        final _dotWidth = dotWidth ??
            (constraints.maxWidth / pageCount) - (_dotSpacingDeficitPerDot * 2);

        final _activeDotColor = activeDotColor ?? theme.primaryColor;
        final _dotColor = dotColor ?? theme.disabledColor;
        return SmoothPageIndicator(
          controller: pageController,
          count: pageCount,
          onDotClicked: onDotClicked,
          effect: () {
            if (effect == IndicatorEffects.swap) {
              return SwapEffect(
                spacing: dotSpacing,
                dotHeight: dotHeight,
                dotWidth: _dotWidth,
                activeDotColor: _activeDotColor,
                dotColor: _dotColor,
              );
            }
            if (effect == IndicatorEffects.scale) {
              return ScaleEffect(
                spacing: dotSpacing,
                dotHeight: dotHeight,
                dotWidth: _dotWidth,
                activeDotColor: _activeDotColor,
                dotColor: _dotColor,
              );
            }
            if (effect == IndicatorEffects.slide) {
              return SlideEffect(
                spacing: dotSpacing,
                dotHeight: dotHeight,
                dotWidth: _dotWidth,
                activeDotColor: _activeDotColor,
                dotColor: _dotColor,
              );
            }
            return WormEffect(
              spacing: dotSpacing,
              dotHeight: dotHeight,
              dotWidth: _dotWidth,
              activeDotColor: _activeDotColor,
              dotColor: _dotColor,
            );
          }(),
        );
      },
    );
  }
}

enum IndicatorEffects {
  swap,
  worm,
  slide,
  scale,
}
