import 'package:flutter/material.dart';
import 'package:packlead/core/themes/index.dart';

enum DispatcherState {
  available,
  assigned,
  inactive,
}

extension DispatcherStateExtension on DispatcherState {
  String toJson() => name;

  static DispatcherState fromJson(String value) {
    return DispatcherState.values.firstWhere(
      (e) => e.name == value,
      orElse: () => DispatcherState.available,
    );
  }
}

extension DispatcherStateUI on DispatcherState {
  String get label {
    switch (this) {
      case DispatcherState.available:
        return 'Activo';
      case DispatcherState.assigned:
        return 'Asignado';
      case DispatcherState.inactive:
        return 'Inactivo';
    }
  }
}

extension DispatcherStateStyle on DispatcherState {
  Color get color {
    switch (this) {
      case DispatcherState.available:
        return SaintColors.success;
      case DispatcherState.assigned:
        return SaintColors.info;
      case DispatcherState.inactive:
        return SaintColors.error;
    }
  }
}