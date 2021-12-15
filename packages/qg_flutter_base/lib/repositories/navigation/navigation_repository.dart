import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final pNavigationRepository =
    StateNotifierProvider<NavigationRepository, NavigationState>(
  (ref) => NavigationRepository(ref.read),
);

abstract class INavigationRepository<T> extends StateNotifier<T> {
  INavigationRepository(T state) : super(state);

  void go(String routePath);
  void push(String routePath);
  void pop({BuildContext? context});
  void execute(GoRouterFunction function);
}

class NavigationRepository extends INavigationRepository<NavigationState> {
  final Reader read;

  NavigationRepository(this.read) : super(const NavigationState());

  String previousRoutePath = '/';

  @override
  void go(String routePath) {
    execute((router) {
      previousRoutePath = router.location;
      router.go(routePath);
    });
  }

  @override
  void push(String routePath) {
    execute((router) {
      previousRoutePath = router.location;
      router.push(routePath);
    });
    previousRoutePath = routePath;
  }

  @override
  void execute(GoRouterFunction function) {
    state = NavigationState(routerFunction: function);
  }

  @override
  void pop({BuildContext? context}) {
    if (context != null) {
      execute((router) {
        router.pop(context);
      });
      return;
    }
    execute((router) {
      router.go(previousRoutePath);
    });
  }
}

class NavigationState {
  final GoRouterFunction? routerFunction;

  const NavigationState({this.routerFunction});
}

typedef GoRouterFunction = void Function(GoRouter router);
