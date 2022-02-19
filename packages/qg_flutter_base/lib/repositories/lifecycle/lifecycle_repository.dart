import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/repositories/base_repository.dart';

final Provider<ILifecycleRepository> pLifecycleRepository =
    Provider<ILifecycleRepository>((ref) {
  final lifecycleRepository = LifecycleRepository(ref.read);
  ref.onDispose(() {
    lifecycleRepository._streamController.close();
  });
  return lifecycleRepository;
});

abstract class ILifecycleRepository {
  void onAppLifecycleStateChanged(AppLifecycleState _state);
  Stream<Duration> get detached;
  Stream<Duration> get inactive;
  Stream<Duration> get paused;
  Stream<Duration> get resumed;
}

class LifecycleRepository extends BaseRepository
    implements ILifecycleRepository {
  LifecycleRepository(Reader read) : super(read);

  @override
  void onAppLifecycleStateChanged(AppLifecycleState _state) {
    _streamController.sink.add(_state);
  }

  final StreamController<AppLifecycleState> _streamController =
      StreamController<AppLifecycleState>();

  final Stopwatch _stopwatch = Stopwatch();

  Duration get _timeFromLastChange {
    final Duration _timeElapsed = _stopwatch.elapsed;
    _stopwatch.reset();
    _stopwatch.start();
    return _timeElapsed;
  }

  @override
  Stream<Duration> get detached => _streamController.stream
      .where((event) => event == AppLifecycleState.detached)
      .map((_) => _timeFromLastChange);

  @override
  Stream<Duration> get inactive => _streamController.stream
      .where((event) => event == AppLifecycleState.inactive)
      .map((_) => _timeFromLastChange);

  @override
  Stream<Duration> get paused => _streamController.stream
      .where((event) => event == AppLifecycleState.paused)
      .map((_) => _timeFromLastChange);

  @override
  Stream<Duration> get resumed => _streamController.stream
      .where((event) => event == AppLifecycleState.resumed)
      .map((_) => _timeFromLastChange);
}
