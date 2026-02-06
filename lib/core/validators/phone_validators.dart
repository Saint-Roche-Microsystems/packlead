class PhoneValidators {
  PhoneValidators._();

  static String? validateEC(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El teléfono es requerido';
    }

    final cleanPhone = value.replaceAll(RegExp(r'\D'), '');

    if (cleanPhone.length != 9) {
      return 'El teléfono debe tener 9 dígitos';
    }

    if (!cleanPhone.startsWith('9')) {
      return 'El teléfono debe empezar con 9';
    }

    return null;
  }

  /// Format to add Prefix +593
  static String formatEC(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    return '+593$cleanPhone';
  }
}