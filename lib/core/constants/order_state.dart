import 'package:flutter/material.dart';
import 'package:packlead/core/themes/index.dart';

enum OrderState {
  pending,
  shipped,
  delivered,
}

extension OrderStateExtension on OrderState {
  String toJson() => name;

  static OrderState fromJson(String value) {
    return OrderState.values.firstWhere(
      (e) => e.name == value,
      orElse: () => OrderState.pending,
    );
  }
}

extension OrderStateUI on OrderState {
  String get label {
    switch (this) {
      case OrderState.pending:
        return 'Pendiente';
      case OrderState.shipped:
        return 'En ruta';
      case OrderState.delivered:
        return 'Entregado';
    }
  }
}

extension OrderStateOptions on OrderState {
  static List<Map<String, String>> get options {
    return OrderState.values.map((state) {
      return {
        'label': state.label,
        'value': state.name,
      };
    }).toList();
  }
}

extension OrderStateStyle on OrderState {
  Color get color {
    switch (this) {
      case OrderState.pending:
        return SaintColors.warning;
      case OrderState.shipped:
        return SaintColors.info;
      case OrderState.delivered:
        return SaintColors.success;
    }
  }
}