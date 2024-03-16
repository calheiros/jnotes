import 'package:flutter/material.dart';

class MyTheme {
  static const Color primaryColor = Color.fromARGB(255, 0, 204, 255);
  static const Color secondaryColor = Color.fromARGB(255, 118, 50, 226);
  //static const Color backgroundColor = Color.fromARGB(255, 118, 50, 226);
  static const Color backgroundColor = Color.fromARGB(255, 34, 33, 54);
  static const Color surfaceColor = Color.fromARGB(255, 0, 204, 255);

  static final ThemeData themeDark = ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
      }),
      useMaterial3: true,
      colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: primaryColor,
          onPrimary: Colors.white,
          secondary: secondaryColor,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          onBackground: Colors.white,
          background: backgroundColor,
          surface: secondaryColor,
          onSurface: Colors.white));
}
