import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';

class ScreenPadding extends ConsumerWidget {
  final Widget child;

  const ScreenPadding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: context.screenInsets(),
      child: child,
    );
  }
}
