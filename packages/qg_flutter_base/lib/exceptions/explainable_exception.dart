import 'package:flutter/widgets.dart';
import 'package:qg_dart_base/exceptions/base_exception.dart';

mixin ExplainableError on BaseException {
  String explain(BuildContext context);
}
