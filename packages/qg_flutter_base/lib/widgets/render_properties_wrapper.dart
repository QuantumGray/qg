import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';

class RenderPropertiesWrapper extends ConsumerWidget {
  final Widget child;
  const RenderPropertiesWrapper({
    Key? key,
    required this.child,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaults = ref.watch(pDefaults);
    final widgets = ref.watch(pWidgets);
    return Defaults(
      defaults: defaults,
      child: Widgets(
        widgets: widgets,
        // Spacing(
        //   dataBuilder: (context) => config.spacing!,
        //   child: ScaffoldMessengerProxy<SnackBarConfig>(
        //     stream: ref.read(pMessagingRepository).snackBarStream,
        //     snackBarBuilder: (context, config) => SynchronousFuture<SnackBar>(
        //       OverlaySnackBar(
        //         config: config,
        //       ),
        //     ),
        child: child,
        //   ),
        // ),
      ),
    );
  }
}
