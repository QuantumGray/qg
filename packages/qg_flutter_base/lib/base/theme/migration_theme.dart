import 'package:flutter/material.dart';

class MigrationTheme {
  static const _primaryColor = Color(0xFF65A0F1);
  final ColorScheme colorScheme;
  final Brightness brightness;
  final TextTheme textTheme;
  final Color cardColor;
  final Color scaffoldBackgroundColor;
  final InputDecorationTheme inputDecorationTheme;
  final ButtonStyle textButtonStyle;
  final DialogTheme dialogTheme;
  final Color dividerColor;
  final IconThemeData iconTheme;

  MigrationTheme._({
    required this.brightness,
    required this.textTheme,
    required this.cardColor,
    required this.scaffoldBackgroundColor,
    required this.inputDecorationTheme,
    required this.textButtonStyle,
    required this.colorScheme,
    required this.dialogTheme,
    required this.dividerColor,
    required this.iconTheme,
  });

  factory MigrationTheme.light() => MigrationTheme._(
        brightness: Brightness.light,
        cardColor: const Color(0xFFFFFFFF),
        scaffoldBackgroundColor: const Color(0xFFF1F4F9),
        textTheme: const TextTheme(
          headline1: TextStyle(color: Color(0xFF18191A)),
          headline5: TextStyle(color: Color(0xFF18191A)),
          subtitle1: TextStyle(color: Color(0xFF3D3E40)),
          subtitle2: TextStyle(color: Color(0xFF3D3E40)),
          bodyText1: TextStyle(color: Color(0xFF616366)),
          bodyText2: TextStyle(color: Color(0xFF919599)),
          caption: TextStyle(color: Color(0xFFC2C7CC)),
          overline: TextStyle(color: Color(0xFFC2C7CC)),
        ),
        dividerColor: const Color(0xFFE3E6EB),
        inputDecorationTheme: const InputDecorationTheme(
          errorStyle: TextStyle(color: Color(0xFFFF9078)),
          hintStyle: TextStyle(color: Color(0xFF999999)),
          fillColor: Colors.white,
        ),
        textButtonStyle: TextButton.styleFrom(
          primary: const Color(0xFF959BA1),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF181919)),
        colorScheme: const ColorScheme(
          primary: _primaryColor,
          secondary: _primaryColor,
          primaryVariant: _primaryColor,
          error: Color(0xFFFF9078),
          secondaryVariant: _primaryColor,
          onBackground: Colors.black,
          onPrimary: Colors.white,
          background: Color(0xFFF1F4F9),
          brightness: Brightness.light,
          onSurface: Colors.black,
          onError: Colors.white,
          surface: Colors.white,
          onSecondary: Colors.white,
        ),
        dialogTheme: const DialogTheme(backgroundColor: Colors.white),
      );

  factory MigrationTheme.dark() => MigrationTheme._(
        brightness: Brightness.dark,
        cardColor: const Color(0xFF3B547B),
        textTheme: const TextTheme(
          headline1: TextStyle(color: Colors.white),
          headline5: TextStyle(color: Colors.white),
          subtitle1: TextStyle(color: Color(0xFFe1e7f0)),
          subtitle2: TextStyle(color: Color(0xFFCFD7E5)),
          bodyText1: TextStyle(color: Colors.white70),
          bodyText2: TextStyle(color: Colors.white70),
          caption: TextStyle(color: Colors.white54),
          overline: TextStyle(color: Color(0xFF7D93B2)),
        ),
        dividerColor: const Color(0xFF505A6A),
        scaffoldBackgroundColor: const Color(0xFF24334A),
        inputDecorationTheme: const InputDecorationTheme(
          errorStyle: TextStyle(color: Color(0xFFFF9078)),
          hintStyle: TextStyle(color: Colors.white30),
          fillColor: Color(0xFF2C3E5A),
        ),
        textButtonStyle: TextButton.styleFrom(
          primary: const Color(0xFF9199A4),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        colorScheme: const ColorScheme(
          primary: _primaryColor,
          secondary: _primaryColor,
          primaryVariant: _primaryColor,
          error: Color(0xFFFF9078),
          secondaryVariant: _primaryColor,
          onBackground: Colors.white,
          onPrimary: Colors.white,
          background: Color(0xFF24334A),
          brightness: Brightness.dark,
          onSurface: Colors.white,
          onError: Colors.white,
          surface: Color(0xFF3B547B),
          onSecondary: Colors.white,
        ),
        dialogTheme: const DialogTheme(backgroundColor: Color(0xFF38598B)),
      );

  factory MigrationTheme.fromBrightness(Brightness brightness) =>
      brightness == Brightness.dark
          ? MigrationTheme.dark()
          : MigrationTheme.light();

  ThemeData get themeData {
    return ThemeData(
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      primaryColor: _primaryColor,
      colorScheme: colorScheme,
      canvasColor: scaffoldBackgroundColor,
      fontFamily: 'Poppins',
      applyElevationOverlayColor: brightness == Brightness.dark,
      brightness: brightness,
      primaryColorBrightness: Brightness.light,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: brightness == Brightness.dark ? Colors.black : Colors.white,
        ),
      ),
      dialogTheme: dialogTheme,
      cardColor: cardColor,
      cardTheme: CardTheme(
        elevation: 10,
        color: cardColor,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(23),
        ),
      ),
      iconTheme: iconTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        actionsIconTheme: const IconThemeData(color: _primaryColor),
        iconTheme: iconTheme,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.5,
          color: brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
        color: Colors.transparent,
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 50,
          height: 1.5,
        ),
        headline4: TextStyle(
          height: 1.5,
          fontWeight: FontWeight.w600,
          fontSize: 30,
        ),
        headline5: TextStyle(
          height: 1.5,
          fontWeight: FontWeight.w600,
          fontSize: 25,
        ),
        headline6: TextStyle(
          height: 1.5,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        subtitle1: TextStyle(
          fontSize: 15,
          height: 1.5,
          fontWeight: FontWeight.w600,
        ),
        subtitle2: TextStyle(
          fontSize: 14,
          height: 1.5,
          fontWeight: FontWeight.w600,
        ),
        bodyText1: TextStyle(
          fontSize: 13,
          height: 1.5,
          fontWeight: FontWeight.w600,
        ),
        bodyText2: TextStyle(
          fontSize: 13,
          height: 1.5,
          fontWeight: FontWeight.w600,
        ),
        caption: TextStyle(
          fontSize: 12,
          height: 1.5,
          fontWeight: FontWeight.w600,
        ),
        overline: TextStyle(
          fontSize: 10,
          height: 1.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.0,
        ),
      ).merge(textTheme),
      inputDecorationTheme: inputDecorationTheme.copyWith(
        hintStyle: const TextStyle(
          fontSize: 15.0,
          height: 1.5,
          fontWeight: FontWeight.w600,
        ).merge(inputDecorationTheme.hintStyle),
        errorStyle: const TextStyle(
          fontSize: 13.0,
          height: 1.5,
          fontWeight: FontWeight.w600,
        ).merge(inputDecorationTheme.errorStyle),
        filled: true,
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(13)),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(
          20,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(150, 60),
          onPrimary: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          primary: _primaryColor,
          animationDuration: const Duration(milliseconds: 100),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: 13.0,
            height: 1.5,
          ),
          animationDuration: const Duration(milliseconds: 100),
        ).merge(textButtonStyle),
      ),
    );
  }
}
