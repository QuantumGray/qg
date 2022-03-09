import 'package:flutter/material.dart';
import 'package:qg_flutter_base/repositories/navigator_observer/navigator_observer_repository.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseNavigatorObserverRepository {
  void add(RouteTransitionEvent event);
  RouteSettings? get currentRoute;
  ValueStream<RouteTransitionEvent> get routeTransitionStream;
}
