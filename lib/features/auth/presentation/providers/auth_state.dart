import 'package:packlead/core/constants/user_status.dart';
import 'package:packlead/core/models/user.dart';

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  factory AuthState.initial() => AuthState(
    status: AuthStatus.initial,
  );

  factory AuthState.loading() => AuthState(
    status: AuthStatus.loading,
  );

  factory AuthState.authenticated(User user) => AuthState(
    status: AuthStatus.authenticated,
    user: user,
  );

  factory AuthState.unauthenticated() => AuthState(
    status: AuthStatus.unauthenticated,
  );

  factory AuthState.error(String errMsg) => AuthState(
    status: AuthStatus.error,
    errorMessage: errMsg,
  );

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}