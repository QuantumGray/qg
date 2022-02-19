import 'package:qg_base/qg_base.dart';

final pResponseMessages =
    Provider<_ResponseMessages>((_) => _ResponseMessages());

class _ResponseMessages {
  const _ResponseMessages();

  String nothingFoundFor(Object? target) => 'Nothing found for: $target';
}
