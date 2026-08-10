import 'package:flutter/material.dart';
import '../core/color_schema.dart';

SnackBarThemeData getSnackBarTheme() {
  return SnackBarThemeData(
    backgroundColor: SaintColors.secondary,
    contentTextStyle: TextStyle(color: SaintColors.foreground),
    actionTextColor: SaintColors.primary,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}
