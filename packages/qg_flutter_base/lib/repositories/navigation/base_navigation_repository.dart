import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class BaseNavigationRepository<T extends NavigationState>
    extends StateNotifier<T> {
  BaseNavigationRepository(T state) : super(state);

  void go(String routePath);
  void push(String routePath);
  void pop({BuildContext? context});
  void execute(GoRouterFunction function);
}

class NavigationState {
  final GoRouterFunction? routerFunction;

  const NavigationState({this.routerFunction});
}

typedef GoRouterFunction = void Function(GoRouter router);
