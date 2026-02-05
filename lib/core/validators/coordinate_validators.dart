class CoordinateValidators {
  CoordinateValidators._();

  static String? validateLatitude(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La latitud es requerida';
    }

    final lat = double.tryParse(value.trim());

    if (lat == null) {
      return 'Latitud inválida';
    }

    if (lat < -90 || lat > 90) {
      return 'Latitud debe estar entre -90 y 90';
    }

    return null;
  }

  static String? validateLongitude(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La longitud es requerida';
    }

    final lng = double.tryParse(value.trim());

    if (lng == null) {
      return 'Longitud inválida';
    }

    if (lng < -180 || lng > 180) {
      return 'Longitud debe estar entre -180 y 180';
    }

    return null;
  }
}