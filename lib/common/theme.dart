import 'package:flutter/material.dart';

import 'colors.dart';

final theme = ThemeData(
  brightness: Brightness.light,
  primaryColor: kPrimaryColor,
  scaffoldBackgroundColor: kBackgroundColor,
  cardColor: kSurfaceColor,
  useMaterial3: false,
  colorScheme: ColorScheme(
    primary: kPrimaryColor,
    primaryContainer: kPrimaryVariantColor,
    secondary: kSecondaryColor,
    secondaryContainer: kSecondaryVariantColor,
    surface: kSurfaceColor,
    error: kErrorColor,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: kTextPrimaryColor,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: kPrimaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, color: kTextPrimaryColor),
    displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, color: kTextPrimaryColor),
    displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: kTextPrimaryColor),

    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: kTextPrimaryColor),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: kTextPrimaryColor),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: kTextPrimaryColor),

    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: kTextPrimaryColor),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: kTextPrimaryColor),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kTextSecondaryColor),

    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: kTextPrimaryColor),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: kTextSecondaryColor),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: kTextSecondaryColor),

    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kPrimaryColor),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: kTextSecondaryColor),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: kTextSecondaryColor),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
);