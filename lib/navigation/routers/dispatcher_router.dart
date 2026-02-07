import 'package:flutter/material.dart';
import 'package:packlead/core/widgets/screen_not_found.dart';
import 'package:packlead/features/dispatcher/presentation/screens/dispatcher_home_screen.dart';

class DispatcherRouter {
  static const String initialRoute = '/dispatcher/home';
  static const String home = '/dispatcher/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => DispatcherHomeScreen(dispatcherId: 'disp_001', dispatcherName: 'Carlos Méndez'));
      default:
        return MaterialPageRoute(builder: (_) => ScreenNotFound());
    }
  }
}