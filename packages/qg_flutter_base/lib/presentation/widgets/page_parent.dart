import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spaces/spaces.dart';

final pDefaultSpacing =
    Provider.family<SpacingData, MediaQueryData>((ref, media) {
  if (media.size.width > 500) {
    return SpacingData.generate(30);
  }
  return SpacingData.generate(18);
});

class PageParent extends ConsumerWidget {
  final Widget child;
  final ProviderFamily<SpacingData, MediaQueryData>? spacingProvider;
  final Map<LogicalKeySet, Intent> shortcuts;
  final Map<Type, Action<Intent>> Function(BuildContext context)?
      actionsBuilder;

  const PageParent({
    Key? key,
    required this.child,
    this.spacingProvider,
    this.shortcuts = const {},
    this.actionsBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQueryData = MediaQuery.of(context);
    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: actionsBuilder != null ? actionsBuilder!(context) : const {},
        child: Spacing(
          dataBuilder: (context) => ref.watch(
            spacingProvider != null
                ? spacingProvider!(mediaQueryData)
                : pDefaultSpacing(mediaQueryData),
          ),
          child: child,
        ),
      ),
    );
  }
}
