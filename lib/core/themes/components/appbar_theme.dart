import 'package:flutter/material.dart';
import '../core/color_schema.dart';

AppBarTheme getAppBarTheme() {
  return const AppBarTheme(
    backgroundColor: SaintColors.primary,
    foregroundColor: SaintColors.background,
    elevation: 4.0,
    scrolledUnderElevation: 8.0,
    titleTextStyle: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: SaintColors.background,
    ),
    iconTheme: IconThemeData(color: SaintColors.background, size: 24.0),
    actionsIconTheme: IconThemeData(color: SaintColors.background, size: 24.0),
  );
}
