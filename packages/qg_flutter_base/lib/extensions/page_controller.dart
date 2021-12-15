import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/extensions/widgetref.dart';

extension PageControllerX on PageController {
  Future<void> nextPageDefault(WidgetRef ref) async {
    return nextPage(
      duration: ref.defaults().pageTransitionDuration,
      curve: ref.defaults().pageTransitionCurve,
    );
  }

  Future<void> previousPageDefault(WidgetRef ref) {
    return previousPage(
      duration: ref.defaults().pageTransitionDuration,
      curve: ref.defaults().pageTransitionCurve,
    );
  }
}

extension TabControllerX on TabController {
  void animateToDefault(WidgetRef ref, int index) {
    animateTo(
      index,
      duration: ref.defaults().pageTransitionDuration,
      curve: ref.defaults().pageTransitionCurve,
    );
  }
}
