import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';

extension WidgetRefExtensions on WidgetRef {
  BaseDefaults defaults() => read(pDefaults);
  BaseWidgets widgets() => read(pWidgets);
}
