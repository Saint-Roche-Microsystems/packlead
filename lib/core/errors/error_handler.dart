import 'dart:io';
import 'dart:async';
import 'auth_exceptions.dart';
import 'package:dio/dio.dart';
import 'package:packlead/services/api/base/api_exception.dart';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is AuthException) {
      return error.message;
    }

    if (error is ApiException) {
      return error.message;
    }

    if (error is DioException) {
      return _handleDioError(error);
    }

    if (error is SocketException) {
      return 'Sin conexión a internet';
    }

    if (error is TimeoutException) {
      return 'La conexión tardó demasiado. Intenta nuevamente.';
    }

    // Generic Exception message extractor
    if (error is Exception) {
      final errorString = error.toString();
      if (errorString.startsWith('Exception: ')) {
        return errorString.substring(11);
      }
      return errorString;
    }

    return 'Ocurrió un error inesperado';
  }

  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Tiempo de espera agotado. Verifica tu conexión.';

      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode);

      case DioExceptionType.cancel:
        return 'Petición cancelada';

      case DioExceptionType.connectionError:
        return 'Error de conexión. Verifica tu internet.';

      default:
        return 'Error de red';
    }
  }

  static String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Solicitud inválida';
      case 401:
        return 'No autorizado. Inicia sesión nuevamente.';
      case 403:
        return 'Acceso denegado';
      case 404:
        return 'Recurso no encontrado';
      case 500:
        return 'Error del servidor. Intenta más tarde.';
      case 503:
        return 'Servicio no disponible';
      default:
        return 'Error del servidor (código: $statusCode)';
    }
  }
}
