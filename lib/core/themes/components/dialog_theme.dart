import 'package:flutter/material.dart';
import '../core/color_schema.dart';

DialogThemeData getDialogTheme() {
  return DialogThemeData(
    backgroundColor: SaintColors.background,
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    titleTextStyle: TextStyle(
      color: SaintColors.primary,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    contentTextStyle: TextStyle(color: SaintColors.foreground, fontSize: 16),
  );
}
