import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/repositories/navigation/base_navigation_repository.dart';

final pNavigationRepository =
    StateNotifierProvider<BaseNavigationRepository, NavigationState>(
  (ref) => NavigationRepository(ref.read),
);

class NavigationRepository extends BaseNavigationRepository<NavigationState> {
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
        router.pop();
      });
      return;
    }
    execute((router) {
      router.go(previousRoutePath);
    });
  }
}
