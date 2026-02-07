class EmailValidators {
  EmailValidators._();

  static String? validateFormat(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El correo es requerido';
    }

    final email = value.trim();

    final emailRegex = RegExp(
      r'^[\w.-]+@([\w-]+\.)+[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Ingrese un correo válido';
    }

    return null;
  }
}