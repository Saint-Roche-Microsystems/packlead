import 'package:flutter/material.dart';

IconThemeData getIconTheme(ColorScheme colorScheme) {
  return IconThemeData(color: colorScheme.onSurfaceVariant, size: 24);
}

IconThemeData getActiveIconTheme(ColorScheme colorScheme) {
  return IconThemeData(color: colorScheme.primary, size: 24);
}
