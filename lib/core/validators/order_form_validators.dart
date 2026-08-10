import 'package:packlead/core/validators/common_validators.dart';

class OrderFormValidators {
  OrderFormValidators._();

  static String? validateClientName(String? value) {
    return CommonValidators.minLength(value, 3, 'El nombre');
  }

  static String? validateZone(String? value) {
    return CommonValidators.notBlank(value, 'La zona');
  }

  static String? validateDeliveryDate(DateTime? date) {
    if (date == null) {
      return 'La fecha de entrega es requerida';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(date.year, date.month, date.day);

    if (selectedDate.isBefore(today)) {
      return 'La fecha no puede ser antes que hoy';
    }

    return null;
  }
}
