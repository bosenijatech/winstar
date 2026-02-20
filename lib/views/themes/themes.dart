import 'package:flutter/material.dart';

class ThemeClass {
  Color lightPrimaryColor = const Color(0xFFf9d00e);
  Color darkPrimaryColor = const Color(0xFF480032);
  Color secondaryColor = const Color(0XFFFF8B6A);
  Color accentColor = const Color(0XFFFFD2BB);

  static ThemeData lightTheme = ThemeData(
    primaryColor: ThemeData.light().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.light().copyWith(
        primary: _themeClass.lightPrimaryColor,
        secondary: _themeClass.secondaryColor),
    appBarTheme: AppBarTheme(
        backgroundColor: _themeClass.lightPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _themeClass.darkPrimaryColor,
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: false),
  );
}

ThemeClass _themeClass = ThemeClass();
