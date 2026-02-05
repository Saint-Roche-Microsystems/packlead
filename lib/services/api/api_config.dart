import 'package:packlead/core/config/env_config.dart';

class ApiConfig {
  ApiConfig._();

  /// Base URLs
  static String get ordersBaseUrl => EnvConfig.ordersApiBaseUrl;

  /// Global Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Common Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}