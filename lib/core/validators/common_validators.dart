class CommonValidators {
  CommonValidators._();

  /// Generic required field validator
  static String? required(String? value, [String fieldName = 'Este campo']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  /// Min length validator
  static String? minLength(
    String? value,
    int min, [
    String fieldName = 'Este campo',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    if (value.trim().length < min) {
      return '$fieldName debe tener al menos $min caracteres';
    }
    return null;
  }

  /// Not blank validator (similar to required but allows whitespace)
  static String? notBlank(String? value, [String fieldName = 'Este campo']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName no puede estar vacío';
    }
    return null;
  }
}
