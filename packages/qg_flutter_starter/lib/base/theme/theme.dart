// ignore_for_file: sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:qg_flutter_base/extensions/extensions.dart';
import 'package:qg_flutter_base/presentation/presentation.dart';

extension AppThemeData on ThemeData {
  bool get isDark => brightness == Brightness.dark;

  ButtonStyle get accentElevatedButtonStyle => ElevatedButton.styleFrom(
        primary: secondary,
        minimumSize: const Size(0, 48),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      );

  ButtonStyle get smallElevatedButton => ElevatedButton.styleFrom(
        minimumSize: const Size(0, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
      );

  ButtonStyle get smallOutlinedButton => OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      );
}

extension AppTextThemeData on ThemeData {
  @override
  AppTextTheme get textTheme =>
      AppTextTheme(brightness: brightness, scheme: colorScheme);
}

class AppTextTheme extends TextTheme {
  final Brightness brightness;
  final ColorScheme scheme;

  const AppTextTheme({
    required this.brightness,
    required this.scheme,
  });

  TextStyle get textExtraSmall => TextStyle(
        color: brightness == Brightness.light ? scheme.primary : Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 10,
      );

  TextStyle get textSmallLight => TextStyle(
        color: brightness == Brightness.light ? scheme.primary : Colors.white,
        fontWeight: FontWeight.w100,
        fontSize: 12,
      );

  TextStyle get textSmallMedium => TextStyle(
        color: brightness == Brightness.light ? scheme.primary : Colors.white,
        fontWeight: FontWeight.w300,
        fontSize: 12,
      );

  TextStyle get textBaseLight => TextStyle(
        color: brightness == Brightness.light ? scheme.primary : Colors.white,
        fontWeight: FontWeight.w100,
        fontSize: 16,
      );

  TextStyle get textBaseMedium => TextStyle(
        color: brightness == Brightness.light ? scheme.primary : Colors.white,
        fontWeight: FontWeight.w300,
        fontSize: 16,
      );

  TextStyle get buttonBase => TextStyle(
        color: brightness == Brightness.light ? scheme.primary : Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 12,
      );

  TextStyle get buttonLarge => TextStyle(
        color: brightness == Brightness.light ? scheme.primary : Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      );

  TextStyle get buttonExtraLarge => TextStyle(
        color: brightness == Brightness.light ? scheme.primary : Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      );

  TextStyle get link => const TextStyle(
        color: Color(0xFF969696),
        fontWeight: FontWeight.w500,
        fontSize: 10,
        decoration: TextDecoration.underline,
      );
}

class AppTheme {
  final Brightness brightness;
  final ColorScheme scheme;
  // final Color colorBottomNavigation;
  // final Color colorBackground;
  // final Color colorDivider;
  // final Color cardColor;
  // final Color textColor;
  // final Color textButtonColor;

  factory AppTheme.fromThemeMode(ThemeMode mode) {
    return AppTheme.fromBrightness(
      mode == ThemeMode.dark ? Brightness.dark : Brightness.light,
    );
  }

  factory AppTheme.fromBrightness(Brightness brightness) =>
      brightness == Brightness.light ? AppTheme.light() : AppTheme.dark();

  AppTheme._({
    // required this.colorBottomNavigation,
    // required this.cardColor,
    // required this.textButtonColor,
    // required this.colorBackground,
    // required this.colorDivider,
    // required this.textColor,
    required this.brightness,
    required this.scheme,
  });

  static ColorScheme _appSchemeFrom(Brightness brightness) => ColorScheme(
        primary: Colors.blue,
        primaryVariant: Colors.blue,
        onPrimary: Colors.white,
        secondary: Colors.purple,
        secondaryVariant: Colors.purple,
        onSecondary: Colors.white,
        background: Colors.grey,
        surface: Colors.lightBlue,
        onBackground: Colors.white,
        onSurface: Colors.black,
        error: Colors.red,
        onError: Colors.white,
        brightness: brightness,
      );

  factory AppTheme.light() => AppTheme._(
        brightness: Brightness.light,
        scheme: _appSchemeFrom(Brightness.light),
        // colorBackground: ConstantsColors.secondaryShadeLight,
        // colorDivider: ConstantsColors.primaryShadeLight,
        // colorBottomNavigation: ConstantsColors.lightSurfacePrimary,
        // textColor: ConstantsColors.primary,
        // cardColor: ConstantsColors.lightSurfacePrimary,
        // textButtonColor: ConstantsColors.primary,
      );

  factory AppTheme.dark() => AppTheme._(
        brightness: Brightness.dark,
        scheme: _appSchemeFrom(Brightness.dark),
        // colorBackground: ConstantsColors.darkSurfaceSecondary,
        // colorDivider: ConstantsColors.primaryShadeDark,
        // colorBottomNavigation: ConstantsColors.darkSurfacePrimary,
        // textColor: Colors.white,
        // cardColor: ConstantsColors.darkSurfacePrimary,
        // textButtonColor: Colors.white,
      );

  AppTextTheme get textTheme =>
      AppTextTheme(brightness: brightness, scheme: scheme);

  ThemeData dataWith({required IDefaults defaults}) {
    // colorScheme: colorScheme,}) {
    return ThemeData(
      colorScheme: scheme,
      cardColor: scheme.surface,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.background,
      ),
      scaffoldBackgroundColor: scheme.background,
      canvasColor: scheme.surface,
      backgroundColor: scheme.background,
      dividerColor: scheme.secondary,
      // fontFamily: 'Euclid',
      applyElevationOverlayColor: brightness == Brightness.dark,
      brightness: brightness,
      primaryColorBrightness: Brightness.dark,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.secondary,
        unselectedItemColor: scheme.primary,
        selectedItemColor: scheme.secondary,
        unselectedIconTheme: const IconThemeData(size: 20),
        selectedIconTheme: const IconThemeData(size: 20),
        unselectedLabelStyle: textTheme.textExtraSmall,
        selectedLabelStyle: textTheme.textExtraSmall,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        actionTextColor: scheme.secondary,
        contentTextStyle: textTheme.textSmallMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      cardTheme: CardTheme(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      iconTheme: IconThemeData(
        color: scheme.primary,
        size: 24,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        color: scheme.background,
      ),
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: textTheme.textBaseMedium.copyWith(color: Colors.grey),
        // filled: true,
        fillColor: scheme.surface,
        errorStyle: textTheme.textSmallMedium,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 12,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: scheme.primary,
          onSurface: scheme.primary,
          onPrimary: Colors.white,
          shadowColor: scheme.secondaryVariant,
          textStyle: textTheme.buttonBase,
          shape: const StadiumBorder(),
          alignment: Alignment.center,
          animationDuration: defaults.animationDuration,
          elevation: 10,
          padding: const EdgeInsets.all(
            20,
          ),
          enableFeedback: true,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: scheme.onSurface,
          onSurface: scheme.primary,
          textStyle: textTheme.buttonBase,
          animationDuration: defaults.animationDuration,
          padding: const EdgeInsets.all(
            10,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: scheme.primary,
          textStyle: textTheme.buttonBase,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          minimumSize: const Size(0, 38),
          animationDuration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.all(
            10,
          ),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: scheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: textTheme.headline4,
        contentTextStyle: textTheme.bodyText1,
      ),
    );
  }
}
