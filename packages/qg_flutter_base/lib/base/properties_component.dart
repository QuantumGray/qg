import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';
import 'package:qg_flutter_base/widgets/spaces/spacing.dart';
import 'package:qg_flutter_base/widgets/spaces/spacing_data.dart';

mixin PropertiesComponent {
  void buildProperties(BuildContext context, WidgetRef ref) {
    spacing = context.spacing();
    screenInsets = context.screenInsets();
    theme = Theme.of(context);
    media = MediaQuery.of(context);
    defaults = context.defaults(ref);
    widgets = ref.read(pWidgets);
  }

  late SpacingData spacing;
  late EdgeInsets screenInsets;
  late ThemeData theme;
  late MediaQueryData media;
  late BaseDefaults defaults;
  late BaseWidgets widgets;
}
