import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/repositories/base_repository.dart';
import 'package:qg_flutter_base/repositories/navigator_observer/base_navigator_observer_repository.dart';
import 'package:rxdart/rxdart.dart';

final pNavigatorObserverRepository = Provider<NavigatorObserverRepository>(
  (ref) => NavigatorObserverRepository(ref.read),
);

class NavigatorObserverRepository extends BaseRepository
    implements BaseNavigatorObserverRepository {
  NavigatorObserverRepository(Reader read) : super(read);

  final BehaviorSubject<RouteTransitionEvent> _routeTransitionSubject =
      BehaviorSubject<RouteTransitionEvent>();

  void add(RouteTransitionEvent event) {
    _routeTransitionSubject.sink.add(event);
  }

  RouteSettings? get currentRoute =>
      _routeTransitionSubject.value.map<RouteSettings?>(
        push: (push) => push.route.settings,
        replace: (replace) => replace.newRoute?.settings,
        pop: (pop) => pop.route.settings,
      );

  ValueStream<RouteTransitionEvent> get routeTransitionStream =>
      _routeTransitionSubject.stream;
}

abstract class RouteTransitionEvent {
  const factory RouteTransitionEvent.push({
    required Route<dynamic> route,
    Route<dynamic>? previousRoute,
  }) = RouteTransitionEventPush;
  const factory RouteTransitionEvent.replace({
    Route<dynamic>? newRoute,
    Route<dynamic>? oldRoute,
  }) = RouteTransitionEventReplace;
  const factory RouteTransitionEvent.pop({
    required Route<dynamic> route,
    Route<dynamic>? previousRoute,
  }) = RouteTransitionEventPop;
}

extension MapRouteTransitionEvent on RouteTransitionEvent {
  T map<T>({
    T Function(RouteTransitionEventPush)? push,
    T Function(RouteTransitionEventReplace)? replace,
    T Function(RouteTransitionEventPop)? pop,
  }) {
    if (this is RouteTransitionEventPush) {
      if (push != null) return push(this as RouteTransitionEventPush);
    } else if (this is RouteTransitionEventReplace) {
      if (replace != null) return replace(this as RouteTransitionEventReplace);
    } else if (this is RouteTransitionEventPop) {
      if (pop != null) return pop(this as RouteTransitionEventPop);
    }
    throw UnsupportedError('Unsupported route transition event');
  }
}

class RouteTransitionEventPush implements RouteTransitionEvent {
  const RouteTransitionEventPush({
    required this.route,
    this.previousRoute,
  });

  final Route<dynamic> route;
  final Route<dynamic>? previousRoute;
}

class RouteTransitionEventReplace implements RouteTransitionEvent {
  const RouteTransitionEventReplace({
    this.newRoute,
    this.oldRoute,
  });

  final Route<dynamic>? newRoute;
  final Route<dynamic>? oldRoute;
}

class RouteTransitionEventPop implements RouteTransitionEvent {
  const RouteTransitionEventPop({
    required this.route,
    this.previousRoute,
  });

  final Route<dynamic> route;
  final Route<dynamic>? previousRoute;
}
