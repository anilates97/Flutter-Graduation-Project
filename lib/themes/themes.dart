import 'package:bitirme_proje/constants/entire_constants.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // black
  static final darkTheme = ThemeData(
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, foregroundColor: Colors.black),
      primaryTextTheme: TextTheme(
          bodyText2: EntireConstants.googleFontsHomePageBodyText2TitleDark(),
          bodyText1: EntireConstants.googleFontsHomePageBodyText1PriceDark(),
          caption: EntireConstants.googleFontsHomePageCaptionDescriptionDark()),
      brightness: Brightness.dark,
      primaryColor: const Color(0xFFF86541),
      cardColor: Color.fromARGB(249, 51, 12, 12),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.white, foregroundColor: Colors.red),
      textTheme: const TextTheme(
          headline6: TextStyle(color: Colors.white, fontFamily: 'MyFont')));

  //white
  static final lightTheme = ThemeData(
    fontFamily: 'MyFont',
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.red, foregroundColor: Colors.white),
    primaryTextTheme: TextTheme(
      bodyText2: EntireConstants.googleFontsHomePageBodyText2TitleLight(),
      bodyText1: EntireConstants.googleFontsHomePageBodyText1PriceLight(),
      caption: EntireConstants.googleFontsHomePageCaptionDescriptionLight(),
    ),
    brightness: Brightness.light,
    primaryColor: const Color(0xFFF86541),
    cardColor: Colors.white,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.red, foregroundColor: Colors.white),
    textTheme: const TextTheme(
      headline6: TextStyle(color: Colors.white, fontFamily: 'MyFont'),
    ),
  );
}
