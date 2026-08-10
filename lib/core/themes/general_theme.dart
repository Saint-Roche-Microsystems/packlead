import 'package:flutter/material.dart';
import 'components/index.dart';
import 'core/index.dart';

ThemeData getGeneralTheme(Brightness brightness) {
  final colorScheme = getColorScheme(brightness);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    appBarTheme: getAppBarTheme(),
    bottomNavigationBarTheme: getBottomNavTheme(colorScheme),
    cardTheme: getCardTheme(),
    dialogTheme: getDialogTheme(),
    dividerTheme: getDividerTheme(),
    dropdownMenuTheme: getDropdownMenuTheme(),
    elevatedButtonTheme: getElevatedButtonTheme(),
    iconTheme: getIconTheme(colorScheme),
    inputDecorationTheme: getInputDecorationTheme(),
    outlinedButtonTheme: getOutlinedButtonTheme(),
    primaryIconTheme: getActiveIconTheme(colorScheme),
    scaffoldBackgroundColor: getBackgroundColor(),
    snackBarTheme: getSnackBarTheme(),
    textButtonTheme: getTextButtonTheme(),
    textTheme: getTextTheme(),
  );
}
