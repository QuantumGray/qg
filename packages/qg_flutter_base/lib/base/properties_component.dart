import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';
import 'package:spaces/spaces.dart';

mixin PropertiesComponent {
  void buildProperties(BuildContext context, WidgetRef ref) {
    spacing = context.spacing();
    screenInsets = context.screenInsets();
    theme = Theme.of(context);
    media = MediaQuery.of(context);
    defaults = context.defaults(ref);
    widgets = ref.read(pAppWidgets);
  }

  late SpacingData spacing;
  late EdgeInsets screenInsets;
  late ThemeData theme;
  late MediaQueryData media;
  late IDefaults defaults;
  late IAppWidgetsFactory widgets;
}