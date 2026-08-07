import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/errors/error_handler.dart';
import 'package:packlead/core/utils/app_logger.dart';
import 'package:packlead/features/auth/data/datasources/auth_datasource.dart';
import 'package:packlead/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:packlead/features/auth/data/repositories/auth_repository.dart';
import 'package:packlead/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:packlead/features/auth/presentation/providers/auth_state.dart';

/// *******************
/// CONFIG PROVIDERS
/// *******************

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  // Dev ONLY - use mock data
  //return AuthMockDataSource();

  // Use Firebase Auth
  return FirebaseAuthDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImp(dataSource);
});

/// *******************
/// AUTH STATE PROVIDER
/// *******************

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthStateNotifier(repository);
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthStateNotifier(this._repository) : super(AuthState.initial()) {
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final currentUser = await _repository.getCurrentUser();
    if(currentUser != null) {
      state = AuthState.authenticated(currentUser);
    } else {
      state = AuthState.unauthenticated();
    }
  }

  Future<void> login(String email, String password) async {
    state = AuthState.loading();

    final result = await _repository.login(email, password);

    result.fold(
       (error) => state = AuthState.error(error),
       (user) => state = AuthState.authenticated(user),
    );
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
      state = AuthState.unauthenticated();
    } catch (error, stackTrace) {
      AppLogger.error('Error al cerrar sesión', error: error, stackTrace: stackTrace);
      state = AuthState.error(ErrorHandler.getErrorMessage(error));
    }
  }
}