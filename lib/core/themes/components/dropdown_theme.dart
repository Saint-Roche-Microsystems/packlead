import 'package:flutter/material.dart';
import '../core/color_schema.dart';

DropdownMenuThemeData getDropdownMenuTheme() {
  return DropdownMenuThemeData(
    menuStyle: MenuStyle(
      backgroundColor: WidgetStateProperty.all(SaintColors.background),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
      elevation: WidgetStateProperty.all(4),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textStyle: TextStyle(color: SaintColors.foreground, fontSize: 14),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: SaintColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: SaintColors.contrast),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: SaintColors.contrast),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: SaintColors.primary, width: 2),
      ),
    ),
  );
}
