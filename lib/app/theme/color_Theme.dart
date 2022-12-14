import 'package:FitStack/app/theme/text_theme.dart';
import 'package:flutter/material.dart';

class FSColorTheme {
  Color primaryColor = Colors.redAccent;
  FSColorTheme();

  static const TextTheme textTheme = TextTheme();

  static ThemeData light(BuildContext context) {
    return ThemeData(
      iconTheme: const IconThemeData(color: Color.fromRGBO(112, 112, 112, 1)),
      backgroundColor: const Color.fromARGB(249, 249, 249, 249),
      primaryColor: const Color.fromRGBO(254, 99, 71, 1),
      colorScheme: const ColorScheme(
        onSecondaryContainer: Color.fromRGBO(255, 36, 36, 1),
        surfaceVariant: Color.fromRGBO(242, 241, 254, 1),
        surface: Colors.white,
        background: Color.fromRGBO(249, 249, 249, 1),
        brightness: Brightness.light,
        error: Color.fromRGBO(242, 82, 82, 1),
        onBackground: Colors.black,
        onError: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        primary: Color.fromRGBO(254, 99, 71, 1),
        secondary: Color.fromRGBO(87, 54, 232, 1),
        tertiary: Color.fromRGBO(230, 64, 64, 1),
      ),
      textTheme: FSTextTheme.primaryTextTheme(context),
    );
  }

  static ThemeData dark(BuildContext context) {
    return ThemeData(
      iconTheme: const IconThemeData(color: Color.fromRGBO(112, 112, 112, 1)),
      backgroundColor: const Color.fromRGBO(249, 249, 249, 1),
      primaryColor: Colors.redAccent,
      colorScheme: const ColorScheme(
        surface: Colors.white,
        background: Color.fromRGBO(249, 249, 249, 1),
        brightness: Brightness.light,
        error: Color.fromRGBO(242, 82, 82, 1),
        onBackground: Colors.black,
        onError: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        primary: Color.fromRGBO(254, 99, 71, 1),
        secondary: Color.fromRGBO(87, 54, 232, 1),
      ),
      textTheme: FSTextTheme.primaryTextTheme(context),
      primaryTextTheme: FSTextTheme.primaryTextTheme(context),
    );
  }
}
