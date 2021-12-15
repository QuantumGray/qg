import 'package:flutter/material.dart';
import 'package:qg_flutter_base/presentation/presentation.dart';

import 'app_core.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    this.overrides = const [],
  }) : super(key: key);

  final List<Override> overrides;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: const AppCore(),
    );
  }
}
