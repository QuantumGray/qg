import 'dart:async';

Future<void> bootstrap(FutureOr<void> Function() main) async {
  await runZonedGuarded(
    () async => await main(),
    (error, trace) {},
  );
}
