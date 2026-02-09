import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/features/auth/data/datasources/auth_datasource.dart';
import 'package:packlead/features/auth/data/datasources/auth_mock_datasource.dart';
import 'package:packlead/features/auth/data/repositories/auth_repository.dart';
import 'package:packlead/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:packlead/features/auth/presentation/providers/auth_state.dart';

/// *******************
/// CONFIG PROVIDERS
/// *******************

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  // Dev ONLY - use mock data
  return AuthMockDataSource();

  // Use real API service
  // final apiClient = ref.watch(authApiClientProvider);
  // return AuthApiDataSource(apiClient);
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

    try {
      final user = await _repository.login(email, password);

      state = AuthState.authenticated(user);
    } catch (error, _) {
      state = AuthState.error(error.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
      state = AuthState.unauthenticated();
    } catch (error, _) {
      state = AuthState.error(error.toString());
    }
  }
}