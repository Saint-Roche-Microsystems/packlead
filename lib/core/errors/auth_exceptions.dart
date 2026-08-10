abstract class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException([
    super.message = 'Correo o contraseña incorrectos',
  ]);
}

class InactiveDispatcherException extends AuthException {
  const InactiveDispatcherException([
    super.message = 'Tu cuenta se encuentra inactiva',
  ]);
}

class NetworkException extends AuthException {
  const NetworkException([
    super.message = 'Error de conexión. Verifica tu internet.',
  ]);
}

class ServerException extends AuthException {
  const ServerException([
    super.message = 'Error del servidor. Intenta más tarde.',
  ]);
}

class UnknownException extends AuthException {
  const UnknownException([super.message = 'Ocurrió un error inesperado.']);
}
