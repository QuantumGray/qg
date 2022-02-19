import 'dart:async';

import 'package:riverbloc/riverbloc.dart';

class RefreshBloc<T extends List> extends Cubit<AsyncValue<T>> {
  final Future<T> Function() fetch;
  final Duration debounce;

  RefreshBloc(this.fetch, this.debounce) : super(const AsyncValue.loading()) {
    _debounce = Timer(debounce, refresh);
  }

  late Timer _debounce;

  Future<void> refresh({bool force = false}) async {
    if (_debounce.isActive && !force) {
      return;
    }

    emit(const AsyncValue.loading());

    _debounce.cancel();
    _debounce = Timer(debounce, () {});

    try {
      final data = await fetch();
      emit(AsyncValue.data(data));
    } catch (error) {
      emit(AsyncValue.error(error));
    }
  }
}
