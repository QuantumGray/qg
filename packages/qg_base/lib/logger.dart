import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

final pLogger = Provider<Logger>(
  (ref) => Logger(
    printer: PrettyPrinter(),
  ),
);
