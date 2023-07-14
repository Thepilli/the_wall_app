import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.grey[300]),
      titleTextStyle: TextStyle(color: Colors.grey[300], fontSize: 20),
    ),
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: Colors.black,
      primary: Colors.grey[800]!,
      secondary: Colors.grey[600]!,
      inversePrimary: Colors.grey[100]!,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey[100],
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.grey[500]),
      bodyMedium: TextStyle(color: Colors.grey[300]),
      bodySmall: TextStyle(color: Colors.grey[100]),
    ));
