import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/constants/user_roles.dart';
import 'package:packlead/features/auth/presentation/providers/auth_provider.dart';
import 'package:packlead/navigation/routers/admin_router.dart';
import 'package:packlead/navigation/routers/dispatcher_router.dart';
import 'package:packlead/navigation/routers/auth_router.dart';

class AppRouter {
  static String initialRoute(WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final role = authState.user?.role ?? UserRole.none;

    return switch(role) {
      UserRole.admin => AdminRouter.initialRoute,
      UserRole.dispatcher => DispatcherRouter.initialRoute,
      UserRole.none => AuthRouter.initialRoute,
    };
  }

  static Route<dynamic> generateRoute(RouteSettings settings, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final role = authState.user?.role ?? UserRole.none;
    final user = authState.user;

    Route<dynamic>? route;

    if (role == UserRole.admin) {
      route = AdminRouter.generateRoute(settings);
    }

    if (role == UserRole.dispatcher && user != null) {
      route = DispatcherRouter.generateRoute(
        settings,
        dispatcherId: user.id,
        dispatcherName: user.name,
      );
    }

    return route ?? AuthRouter.generateRoute(settings);
  }
}