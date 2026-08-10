import 'package:flutter/material.dart';
import 'color_palettes.dart';

class SaintColors {
  static const Color primary = OceanPalette.oceanBlue;
  static const Color secondary = OceanPalette.oceanBlueLight;

  static const Color background = OceanPalette.backgroundWhite;
  static const Color surface = OceanPalette.surfaceLight;

  static const Color foreground = OceanPalette.textPrimary;
  static const Color lightForeground = OceanPalette.textSecondary;

  static const Color contrast = OceanPalette.contrastDark;

  static const Color error = OceanPalette.error;
  static const Color success = OceanPalette.success;
  static const Color warning = OceanPalette.warning;
  static const Color info = OceanPalette.info;
}

ColorScheme getColorScheme(Brightness brightness) {
  return ColorScheme.fromSeed(
    seedColor: SaintColors.primary,
    brightness: brightness,
    primary: SaintColors.primary,
    onPrimary: SaintColors.background,
    secondary: SaintColors.secondary,
    onSecondary: SaintColors.contrast,
    surface: SaintColors.secondary,
    onSurface: SaintColors.contrast,
    error: SaintColors.error,
    onError: Colors.white,
  );
}
