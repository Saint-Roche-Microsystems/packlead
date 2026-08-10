import 'package:flutter/material.dart';
import '../core/color_schema.dart';

BottomNavigationBarThemeData getBottomNavTheme(ColorScheme colorScheme) {
  return BottomNavigationBarThemeData(
    backgroundColor: SaintColors.surface,
    selectedItemColor: SaintColors.primary,
    unselectedItemColor: colorScheme.onSurfaceVariant,
    selectedIconTheme: IconThemeData(color: colorScheme.primary),
    unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
    type: BottomNavigationBarType.fixed,
    showUnselectedLabels: true,
  );
}
