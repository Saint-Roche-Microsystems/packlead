import 'package:flutter/material.dart';
import 'package:packlead/core/constants/user_roles.dart';
import 'package:packlead/core/constants/user_status.dart';
import 'package:packlead/features/admin/presentation/layouts/admin_bottom_nav_layout.dart';
import 'package:packlead/features/auth/presentation/providers/auth_state.dart';
import 'package:packlead/features/auth/presentation/screens/login_screen.dart';
import 'package:packlead/features/dispatcher/presentation/screens/dispatcher_home_screen.dart';

class HomeBuilder extends StatelessWidget {
  final AuthState authState;

  const HomeBuilder({super.key, required this.authState});

  @override
  Widget build(BuildContext context) {
    if(authState.status == AuthStatus.authenticated) {
      final role = authState.user?.role ?? UserRole.none;
      return switch (role) {
        UserRole.admin => AdminBottomNavLayout(),
        UserRole.dispatcher => DispatcherHomeScreen(
          dispatcherId: authState.user!.id,
          dispatcherEmail: authState.user!.email,
        ),
        UserRole.none => const LoginScreen(),
      };
    }
    return const LoginScreen();
  }
}
