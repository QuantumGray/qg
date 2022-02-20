import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

class LoggerProviderObserver extends ProviderObserver {
  const LoggerProviderObserver();

  Logger get l => Logger(printer: PrefixPrinter(PrettyPrinter()));

  @override
  void didUpdateProvider(ProviderBase provider, Object? newValue, _, __) {
    l.i(
      '''
    PROVIDER UPDATED
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''',
    );
  }

  @override
  void didAddProvider(ProviderBase provider, Object? value, _) {
    l.i(
      '''
    PROVIDER ADDED
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "value": "$value"
}''',
    );
  }

  @override
  void didDisposeProvider(ProviderBase provider, container) {
    l.i(
      '''
    PROVIDER DISPOSED
{
  "provider": "${provider.name ?? provider.runtimeType}",
}''',
    );
  }
}
