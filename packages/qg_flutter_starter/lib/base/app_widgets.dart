import 'package:flutter/material.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';

class AppWidgetsFactory implements IAppWidgetsFactory {
  const AppWidgetsFactory();

  @override
  Widget emptyIndicator({String? forSubject}) {
    throw UnimplementedError();
  }

  @override
  Widget exceptionIndicator(Exception errorMessage) {
    throw UnimplementedError();
  }

  @override
  Widget loadingIndicator({Stream? progress}) {
    throw UnimplementedError();
  }

  @override
  Widget nothingFoundIndicator({String? forSubject}) {
    throw UnimplementedError();
  }
}
