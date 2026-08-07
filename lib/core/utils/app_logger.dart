import 'dart:developer' as developer;

import 'package:packlead/core/constants/log_level.dart';

class AppLogger {
  AppLogger._();

  static void log(
    String message, {
    LogLevel level = LogLevel.info,
    Object? error,
    StackTrace? stackTrace,
    String name = 'packlead',
  }) {
    developer.log(
      '${level.label} $message',
      name: name,
      error: error,
      stackTrace: stackTrace,
      level: level.severity,
    );
  }

  static void debug(String message, {String name = 'packlead'}) {
    log(message, level: LogLevel.debug, name: name);
  }

  static void info(String message, {String name = 'packlead'}) {
    log(message, level: LogLevel.info, name: name);
  }

  static void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String name = 'packlead',
  }) {
    log(message, level: LogLevel.warning, error: error, stackTrace: stackTrace, name: name);
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String name = 'packlead',
  }) {
    log(message, level: LogLevel.error, error: error, stackTrace: stackTrace, name: name);
  }
}
