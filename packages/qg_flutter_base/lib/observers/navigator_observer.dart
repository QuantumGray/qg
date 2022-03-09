import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qg_flutter_base/repositories/navigator_observer/navigator_observer_repository.dart';

class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  AppRouteObserver(this.read);

  final Reader read;

  void _dispatch(RouteTransitionEvent event) {
    if (event.map(
      push: (push) => push.route,
      replace: (replace) => replace.newRoute,
      pop: (pop) => pop.route,
    ) is PageRoute) {
      read(pNavigatorObserverRepository).add(event);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _dispatch(
      RouteTransitionEvent.push(
        route: route,
        previousRoute: previousRoute,
      ),
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _dispatch(
      RouteTransitionEvent.replace(
        newRoute: newRoute,
        oldRoute: oldRoute,
      ),
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _dispatch(
      RouteTransitionEvent.pop(
        route: route,
        previousRoute: previousRoute,
      ),
    );
  }
}
