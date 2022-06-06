import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';

class EntityConsumer<E> extends HookConsumerWidget {
  final E Function(
    BuildContext context,
    E Function<E>(ProviderListenable<E> provider) watch,
  ) watcher;
  final Widget Function(
    BuildContext context,
    E data,
  ) builder;

  const EntityConsumer({
    Key? key,
    required this.watcher,
    required this.builder,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widgets = ref.watch(pWidgets);
    final value = watcher(context, ref.watch);

    if (value is AsyncValue<E>) {
      return value.when<Widget>(
        error: widgets.errorIndicator,
        loading: widgets.loadingIndicator,
        data: (data) {
          if (data is Iterable && data.isEmpty) {
            return widgets.emptyIndicator();
          }

          return builder(
            context,
            data,
          );
        },
      );
    }

    return builder(context, value);
  }
}
