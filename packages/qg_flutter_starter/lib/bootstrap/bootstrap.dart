import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:qg_flutter_base/base/utils/run_main.dart';
import 'package:qg_flutter_base/presentation/presentation.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  await runZonedBlocBus(() async {
    await runMain(
      await builder(),
      onError: (_, __) {},
      onFlutterError: (_) {},
    );
  });
}
