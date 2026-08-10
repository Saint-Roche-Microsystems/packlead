import 'package:flutter/material.dart';
import '../core/color_schema.dart';

InputDecorationTheme getInputDecorationTheme() {
  return InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: const BorderSide(
        color: SaintColors.lightForeground,
        width: 1.0,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: const BorderSide(
        color: SaintColors.lightForeground,
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: const BorderSide(
        color: SaintColors.lightForeground,
        width: 2.0,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: BorderSide(color: SaintColors.error, width: 3.0),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 12.0,
    ),
    labelStyle: const TextStyle(
      color: SaintColors.lightForeground,
      fontSize: 14.0,
    ),
    hintStyle: TextStyle(
      color: SaintColors.lightForeground.withValues(alpha: 0.5),
      fontSize: 14.0,
    ),
  );
}
