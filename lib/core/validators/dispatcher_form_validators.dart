import 'package:packlead/core/validators/common_validators.dart';

class DispatcherFormValidators {
  DispatcherFormValidators._();

  static String? validateName(String? value) {
    return CommonValidators.minLength(value, 3, 'El nombre');
  }

  static String? validateVehicle(String? value) {
    return CommonValidators.notBlank(value, 'El vehículo');
  }

  static String? validateLicensePlate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La placa es requerida';
    }

    final plate = value.trim();

    final plateRegex = RegExp(r'^[A-Z]{3}-\d{3,4}$');

    if (!plateRegex.hasMatch(plate)) {
      return 'Formato inválido. Ej: ABC-1234';
    }

    return null;
  }
}
