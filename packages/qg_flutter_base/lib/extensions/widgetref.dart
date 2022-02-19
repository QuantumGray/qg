import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';

extension WidgetRefX on WidgetRef {
  IDefaults defaults() => read(pDefaults);
  IAppWidgetsFactory widgets() => read(pAppWidgets);
}
