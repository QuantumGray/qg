import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LifecycleManager extends HookWidget with WidgetsBindingObserver {
  LifecycleManager({
    required this.child,
    this.onAppLifecycleStateChanged,
  });
  final Widget child;
  final Widget? Function(AppLifecycleState appLifecycleState)?
      onAppLifecycleStateChanged;

  @override
  void didChangeAppLifecycleState(AppLifecycleState _appLifecycleState) {
    onAppLifecycleStateChanged?.call(_appLifecycleState);
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      WidgetsBinding.instance?.addObserver(this);
      return () => WidgetsBinding.instance?.removeObserver(this);
    });
    return child;
  }
}

class AppLifeycleStateNotifier extends StateNotifier<AppLifecycleState?> {
  AppLifeycleStateNotifier(this.read) : super(null) {
    appLifecycleStateChanges = _streamController.stream.distinct();
  }
  final Reader read;
  final StreamController<AppLifecycleState> _streamController =
      StreamController<AppLifecycleState>();

  final Stopwatch _stopwatch = Stopwatch();

  Duration get timeFromLastChange {
    final Duration _timeElapsed = _stopwatch.elapsed;
    _stopwatch.reset();
    _stopwatch.start();
    return _timeElapsed;
  }

  Stream<Duration> get detached => _streamController.stream
      .where((event) => event == AppLifecycleState.detached)
      .map((_) => timeFromLastChange);
  Stream<Duration> get inactive => _streamController.stream
      .where((event) => event == AppLifecycleState.detached)
      .map((_) => timeFromLastChange);
  Stream<Duration> get paused => _streamController.stream
      .where((event) => event == AppLifecycleState.detached)
      .map((_) => timeFromLastChange);
  Stream<Duration> get resumed => _streamController.stream
      .where((event) => event == AppLifecycleState.detached)
      .map((_) => timeFromLastChange);

  void lifecycleChanged(AppLifecycleState _appLifecycleState) {
    state = _appLifecycleState;
    _streamController.add(_appLifecycleState);
  }

  Stream<AppLifecycleState?>? appLifecycleStateChanges;

  AppLifecycleState? get appLifecycleState => state;
}

final StateNotifierProvider<AppLifeycleStateNotifier, AppLifecycleState?>
    appLifecycleState =
    StateNotifierProvider<AppLifeycleStateNotifier, AppLifecycleState?>(
  (ref) => AppLifeycleStateNotifier(ref.read),
);
