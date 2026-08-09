import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:packlead/services/api/base/api_exception.dart';

/// Generic HTTP base client with Dio
class BaseApiClient {
  late final Dio _dio;
  final String baseUrl;

  BaseApiClient({
    required this.baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Map<String, dynamic>? headers,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout ?? const Duration(seconds: 30),
        receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
        headers: headers ?? {'Content-Type': 'application/json'},
        validateStatus: (status) => status != null && status >= 200 && status < 300,
      ),
    );

    _dio.interceptors.add(_AuthInterceptor(_dio));

    // Add interceptor for logging in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(_LoggingInterceptor());
    }
  }

  /// GET request
  Future<T> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// POST request
  Future<T> post<T>(
      String path, {
        required Map<String, dynamic> data,
      }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// PUT request
  Future<T> put<T>(
      String path, {
        required Map<String, dynamic> data,
      }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// DELETE request
  Future<void> delete(String path) async {
    try {
      await _dio.delete(path);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Error handling with Dio
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          'Tiempo de espera agotado. Verifica tu conexión.',
          statusCode: null,
        );

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;

        // Try to extract message from the backend
        String message = 'Error del servidor';
        if (responseData is Map<String, dynamic>) {
          message = responseData['message'] as String? ??
              responseData['error'] as String? ??
              message;
        }

        return ApiException(message, statusCode: statusCode);

      case DioExceptionType.connectionError:
        return ApiException('Sin conexión a internet.', statusCode: null);

      case DioExceptionType.cancel:
        return ApiException('Petición cancelada.', statusCode: null);

      default:
        return ApiException(
          'Error del servidor: ${e.message}',
          statusCode: null,
        );
    }
  }
}

/// Attaches the current Firebase ID token to every request and retries
/// once with a force-refreshed token on a 401.
class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._dio);

  final Dio _dio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    final alreadyRetried = requestOptions.extra['authRetried'] == true;

    if (err.response?.statusCode == 401 &&
        !alreadyRetried &&
        FirebaseAuth.instance.currentUser != null) {
      try {
        final refreshedToken = await FirebaseAuth.instance.currentUser?.getIdToken(true);
        if (refreshedToken != null) {
          requestOptions.headers['Authorization'] = 'Bearer $refreshedToken';
          requestOptions.extra['authRetried'] = true;
          final response = await _dio.fetch(requestOptions);
          handler.resolve(response);
          return;
        }
      } on DioException catch (retryError) {
        handler.next(retryError);
        return;
      }
    }

    handler.next(err);
  }
}

/// Logging Interceptor
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('[REQUEST]: ${options.method} ${options.uri}');
    if (options.data != null) {
      debugPrint('Body: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('[RESPONSE]: ${response.statusCode} ${response.requestOptions.uri}');
    debugPrint('Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('[ERROR]: ${err.response?.statusCode} ${err.requestOptions.uri}');
    debugPrint('Message: ${err.message}');
    super.onError(err, handler);
  }
}