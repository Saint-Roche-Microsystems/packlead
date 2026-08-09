import 'package:packlead/core/config/env_config.dart';

enum ServiceMode { api, mock }

class AppServiceMode {
  AppServiceMode._();

  static ServiceMode get current =>
      EnvConfig.localService.toUpperCase() == 'MOCK' ? ServiceMode.mock : ServiceMode.api;

  static bool get isMock => current == ServiceMode.mock;
}
