import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/models/user.dart';
import 'package:packlead/features/auth/data/datasources/auth_datasource.dart';
import 'package:packlead/features/auth/data/datasources/auth_mock_datasource.dart';
import 'package:packlead/features/auth/data/repositories/auth_repository.dart';
import 'package:packlead/features/auth/data/repositories/auth_repository_imp.dart';

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

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AsyncValue<User?>>((ref) {
  return AuthStateNotifier(ref);
});

class AuthStateNotifier extends StateNotifier<AsyncValue<User?>> {
  final Ref _ref;

  AuthStateNotifier(this._ref) : super(const AsyncValue.loading()) {
    _checkAuthStatus();
  }

  AuthRepository get _repository => _ref.read(authRepositoryProvider);

  Future<void> _checkAuthStatus() async {
    try {
      final user = await _repository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      final user = await _repository.login(email, password);

      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          state = const AsyncValue.data(null);
        }
      });
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// *******************
/// CONVENIENCE PROVIDERS
/// *******************

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value != null;
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value;
});