import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/base/properties_component.dart';

class SafeConnectivity extends StatefulHookConsumerWidget {
  final WidgetBuilder builder;
  final Stream<ConnectivityResult> connectivityListenable;

  const SafeConnectivity({
    Key? key,
    required this.builder,
    required this.connectivityListenable,
  }) : super(key: key);

  @override
  _SafeConnectivityState createState() => _SafeConnectivityState();
}

class _SafeConnectivityState extends ConsumerState<SafeConnectivity>
    with PropertiesComponent {
  late StreamSubscription _connectivityListenableSubscription;

  final Completer<ConnectivityResult> _connectivityResultCompleter =
      Completer<ConnectivityResult>();

  @override
  void initState() {
    super.initState();
    _connectivityListenableSubscription =
        widget.connectivityListenable.listen(_onConnectivityChanged);
  }

  @override
  void dispose() {
    _connectivityListenableSubscription.cancel();
    super.dispose();
  }

  void _onConnectivityChanged(ConnectivityResult result) {
    if (!_connectivityResultCompleter.isCompleted) {
      _connectivityResultCompleter.complete(result);
    }
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text('$result'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    buildProperties(context, ref);
    final snapshot = useStream(widget.connectivityListenable);

    if (snapshot.hasError) {
      return widgets.errorIndicator(
        snapshot.error,
        null,
      );
    }
    if (!snapshot.hasData) {
      return widgets.loadingIndicator();
    }
    final result = snapshot.data;
    if (result == ConnectivityResult.none) {
      return widgets.errorIndicator(
        Exception(
          'No internet connection',
        ),
        null,
      );
    }
    return widget.builder(context);
  }
}
