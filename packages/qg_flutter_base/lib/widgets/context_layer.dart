// ignore_for_file: prefer_function_declarations_over_variables, use_build_context_synchronously

import 'dart:async';

import 'package:bloc_bus/bloc_bus.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ContextLayer extends StatefulHookConsumerWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  final List<EventWorker> eventWorkers;

  const ContextLayer({
    Key? key,
    required this.child,
    required this.navigatorKey,
    this.eventWorkers = const [],
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContextLayerState();
}

class _ContextLayerState extends ConsumerState<ContextLayer>
    implements ContextLayerInteractor {
  NavigatorState? get _navigatorState => widget.navigatorKey.currentState;

  Future? _future;

  late final Map<String, OverlayEntry> _entries;
  late LayerLink _layerLink;
  RenderBox? renderObject;

  LayerLink get layerLink => _layerLink;

  late Stream<AppEvent> _stream;
  late StreamProvider<AppEvent> _streamProvider;

  @override
  void initState() {
    super.initState();
    _stream = eventBus.on<AppEvent>();
    _streamProvider = StreamProvider<AppEvent>((ref) => _stream);
    _entries = <String, OverlayEntry>{};
    _layerLink = LayerLink();
  }

  @override
  void dispose() {
    eventBus.destroy();
    super.dispose();
  }

  @override
  void interact(void Function(BuildContext context) interact) {
    interact(_context);
  }

  @override
  void insertOverlay(String id, OverlayEntry entry) {
    if (_entries.containsKey(id)) {
      throw Exception('overlay-already-present');
    }
    Overlay.of(_context)?.insert(entry);
  }

  @override
  void removeOverlay(String id) {
    _entries[id]!.remove();
    _entries.remove(id);
  }

  @override
  void pushRoute(Route route) {
    _future ??= _navigatorState!.push(route);
  }

  @override
  void showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(_context).showSnackBar(snackBar);
  }

  static late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    ref.listen<AsyncValue<AppEvent>>(_streamProvider, (previous, next) async {
      if (next is AsyncLoading || next is AsyncError) {
        return;
      }

      final event = next.value!;
      if (_future != null) {
        await _future;
      }

      for (final worker in widget.eventWorkers) {
        final predicate = worker.predicate?.call(ref) ?? true;
        if (!predicate) continue;

        if (worker.events.contains(event.key) ||
            event.value['type'] == 'overlay') {
          final type = event.value['type'] as String?;

          if (type == 'modal') {
            final callback = () async {
              if (_navigatorState == null) return;
              pushRoute(
                worker.routeBuilder != null
                    ? worker.routeBuilder!(
                        context,
                        worker.builder(context, event),
                      )
                    : MaterialPageRoute(
                        builder: (context) => worker.builder(context, event),
                      ),
              );
              final result = await _future;
              worker.onResult?.call(result);
            };

            if (worker.delay != null) {
              Future.delayed(worker.delay!).then((_) => callback());
              return;
            }
            callback();
          } else if (type == 'overlay') {
            insertOverlay(
              event.key,
              OverlayEntry(
                builder: (_context) {
                  Widget widget = worker.builder(
                    _context,
                    event,
                  );
                  final context = event.value['context'] as BuildContext?;
                  final duration = event.value['duration'] as Duration?;
                  final link = event.value['link'] as bool?;

                  if (context != null) {
                    renderObject = context.findRenderObject() as RenderBox?;
                    final pos = renderObject?.localToGlobal(Offset.zero);

                    if (pos != null) {
                      final left = pos.dx;
                      final top = pos.dy + renderObject!.size.height + 10;

                      if (link ?? false) {
                        widget = CompositedTransformFollower(
                          link: _layerLink,
                          showWhenUnlinked: false,
                          offset: Offset(0, renderObject!.size.height + 10),
                          child: widget,
                        );
                      }

                      widget = Positioned(
                        left: left,
                        top: top,
                        child: widget,
                      );
                    }
                  }

                  if (duration != null) {
                    Future.delayed(duration)
                        .then((__) => removeOverlay(event.key));
                  }
                  return widget;
                },
              ),
            );
          } else if (type == 'snackbar') {
            final builder = event.value['builder'] as WidgetBuilder;
            final SnackBar snackBar = SnackBar(
              content: builder(_context),
            );
            showSnackBar(snackBar);
          }
        }
      }
    });

    return ProviderScope(
      overrides: [
        pContextLayerInteractor.overrideWithValue(this),
      ],
      child: Navigator(
        key: widget.navigatorKey,
        pages: [
          MaterialPage(child: widget.child),
        ],
      ),
    );
  }

  @override
  void fire(AppEvent event) {
    eventBus.fire(event);
  }
}

abstract class ContextLayerInteractor {
  void interact(void Function(BuildContext context) interact);
  void insertOverlay(String id, OverlayEntry entry);
  void removeOverlay(String id);
  void showSnackBar(SnackBar snackBar);
  void pushRoute(Route route);
  void fire(AppEvent event);
}

class EventWorker {
  final Widget Function(BuildContext context, AppEvent event) builder;
  final List<String> events;
  final bool Function(WidgetRef ref)? predicate;
  final Duration? delay;
  final void Function(dynamic result)? onResult;
  final double? viewportFraction;
  final Route Function(BuildContext context, Widget child)? routeBuilder;

  EventWorker({
    required this.builder,
    required this.events,
    this.predicate,
    this.delay,
    this.onResult,
    this.viewportFraction,
    this.routeBuilder,
  });
}

final pContextLayerInteractor = Provider<ContextLayerInteractor>(
  (ref) => throw UnimplementedError(),
);

final pEventsStream = StreamProvider<AppEvent>(
  (ref) => bus.on(),
);

final bus = eventBus;

typedef AppEvent = MapEntry<String, Map<String, dynamic>>;

abstract class WidgetConfig {
  final String type;

  const WidgetConfig(this.type);
}

abstract class LeafWidgetConfig extends WidgetConfig {
  const LeafWidgetConfig(String type) : super(type);
}

abstract class NonLeafWidgetConfig extends WidgetConfig {
  const NonLeafWidgetConfig(String type) : super(type);
}

class SingleChildWidgetConfig extends NonLeafWidgetConfig {
  final WidgetConfig child;

  const SingleChildWidgetConfig(this.child, String type) : super(type);
}

class MultiChildWidgetConfig extends NonLeafWidgetConfig {
  final List<WidgetConfig> children;

  const MultiChildWidgetConfig(this.children, String type) : super(type);
}
