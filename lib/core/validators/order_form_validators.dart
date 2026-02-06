import 'package:packlead/core/validators/common_validators.dart';

class OrderFormValidators {
  OrderFormValidators._();

  static String? validateClientName(String? value) {
    return CommonValidators.minLength(value, 3, 'El nombre');
  }

  static String? validateZone(String? value) {
    return CommonValidators.notBlank(value, 'La zona');
  }
}