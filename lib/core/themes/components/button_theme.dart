import 'package:flutter/material.dart';
import '../core/color_schema.dart';

ElevatedButtonThemeData getElevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: SaintColors.foreground,
      backgroundColor: SaintColors.secondary,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2.0, // Subtle elevation
      textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
    ),
  );
}

OutlinedButtonThemeData getOutlinedButtonTheme() {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: SaintColors.secondary,
      side: const BorderSide(color: SaintColors.secondary, width: 2.0),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
    ),
  );
}

TextButtonThemeData getTextButtonTheme() {
  return TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: SaintColors.secondary,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
    ),
  );
}
