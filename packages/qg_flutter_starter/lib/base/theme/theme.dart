// ignore_for_file: sort_constructors_first

import 'package:flutter/material.dart';
import 'package:qg_flutter_base/base/theme/base_theme.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';

class AppTheme extends BaseTheme {
  AppTheme()
      : super(
          colorSchemeBuilder: (brightness) => brightness == Brightness.light
              ? const ColorScheme.light(
                  primary: ConstantsColors.primary,
                  onPrimary: ConstantsColors.lightSurfacePrimary,
                  surface: ConstantsColors.primary,
                  onSurface: ConstantsColors.darkSurfacePrimary,
                  error: ConstantsColors.danger,
                  onBackground: ConstantsColors.darkSurfacePrimary,
                  background: ConstantsColors.lightSurfacePrimary,
                )
              : const ColorScheme.dark(
                  primary: ConstantsColors.primary,
                  onPrimary: ConstantsColors.lightSurfacePrimary,
                  surface: ConstantsColors.darkSurfacePrimary,
                  onSurface: ConstantsColors.lightSurfacePrimary,
                  error: ConstantsColors.danger,
                  onBackground: ConstantsColors.primary,
                  background: ConstantsColors.darkSurfacePrimary,
                ),
          textTheme: const TextTheme(),
        );

  @override
  ThemeData build(
    ColorScheme colorScheme,
    IDefaults defaults,
    IAppWidgetsFactory widgets,
  ) =>
      ThemeData(
        colorScheme: colorScheme,
        textTheme: textTheme,
        fontFamily: 'Euclid',
        shadowColor: Colors.black,
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          actionTextColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onBackground,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: colorScheme.onBackground,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: textTheme.button?.copyWith(color: Colors.grey),
          filled: false,
          errorStyle: textTheme.button?.copyWith(color: ConstantsColors.danger),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.only(
            top: 12,
            bottom: 12,
            left: 12,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: colorScheme.primary,
            onPrimary: colorScheme.onPrimary,
            shape: const StadiumBorder(),
            alignment: Alignment.center,
            elevation: 10,
            padding: const EdgeInsets.all(
              20,
            ),
            enableFeedback: true,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: colorScheme.onBackground,
            alignment: Alignment.center,
            enableFeedback: true,
            shape: RoundedRectangleBorder(
              side: const BorderSide(),
              borderRadius: defaults.smallBorderRadius,
            ),
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(),
      );
}

class ConstantsColors {
  static const Color primary = Color(0xFF3454FF);

  static const Color lightSurfacePrimary = Color(0xFFEBEAEA);
  static const Color darkSurfacePrimary = Color(0xFF324586);

  static const Color info = Color(0xFF8254CB);
  static const Color infoShadeLight = Color(0xFFEBDEFF);
  static const Color infoShadeDark = Color(0xFFC29BFF);

  static const Color success = Color(0xFF00D7AF);
  static const Color successShadeLight = Color(0xFFBBF8EC);
  static const Color successShadeDark = Color(0xFF76DCC9);

  static const Color warning = Color(0xFFFFA636);
  static const Color warningShadeLight = Color(0xFFFFECD4);
  static const Color warningShadeDark = Color(0xFFFFCF94);

  static const Color danger = Color(0xFFED3065);
  static const Color dangerShadeLight = Color(0xFFFFDAE4);
  static const Color dangerShadeDark = Color(0xFFFF9BB7);
}
