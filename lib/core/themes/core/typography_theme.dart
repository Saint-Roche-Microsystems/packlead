import 'package:flutter/material.dart';
import 'color_schema.dart';

TextTheme getTextTheme() {
  return const TextTheme(
    displayLarge: TextStyle(
      fontSize: 57.0,
      fontWeight: FontWeight.bold,
      color: SaintColors.contrast,
    ), // Headline1
    displayMedium: TextStyle(
      fontSize: 45.0,
      fontWeight: FontWeight.bold,
      color: SaintColors.contrast,
    ),
    displaySmall: TextStyle(
      fontSize: 36.0,
      fontWeight: FontWeight.bold,
      color: SaintColors.contrast,
    ),
    headlineLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: SaintColors.contrast,
    ), // Headline4
    headlineMedium: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: SaintColors.contrast,
    ),
    headlineSmall: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: SaintColors.contrast,
    ),
    titleLarge: TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      color: SaintColors.contrast,
    ), // Subtitle1
    titleMedium: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: SaintColors.contrast,
    ),
    titleSmall: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: SaintColors.contrast,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: SaintColors.contrast,
    ), // BodyText1
    bodyMedium: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: SaintColors.contrast,
    ), // BodyText2
    bodySmall: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: SaintColors.contrast,
    ),
    labelLarge: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: SaintColors.contrast,
    ), // Button
    labelMedium: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: SaintColors.contrast,
    ),
    labelSmall: TextStyle(
      fontSize: 11.0,
      fontWeight: FontWeight.w500,
      color: SaintColors.contrast,
    ),
  ).apply(
    fontFamily: 'Roboto',
    bodyColor: SaintColors.contrast,
    displayColor: SaintColors.contrast,
  );
}
