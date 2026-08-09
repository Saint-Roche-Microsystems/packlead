import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/config/service_mode.dart';
import 'package:packlead/core/constants/dispatcher_state.dart';
import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/features/auth/presentation/providers/auth_provider.dart';
import 'package:packlead/features/dispatcher/data/datasources/dispatcher_api_datasource.dart';
import 'package:packlead/features/dispatcher/data/datasources/dispatcher_datasource.dart';
import 'package:packlead/features/dispatcher/data/datasources/dispatcher_mock_datasource.dart';
import 'package:packlead/features/dispatcher/data/repositories/dispatcher_repository.dart';
import 'package:packlead/features/dispatcher/data/repositories/dispatcher_repository_imp.dart';
import 'package:packlead/features/dispatcher/models/dispatcher_creation_result.dart';
import 'package:packlead/services/api/api_config.dart';
import 'package:packlead/services/api/base/base_api_client.dart';
import 'package:packlead/services/api/clients/dispatchers_api_client.dart';

/// *******************
/// CONFIG PROVIDERS
/// *******************

// API service related
final dispatchersBaseApiClientProvider = Provider<BaseApiClient>((ref) {
  return BaseApiClient(
    baseUrl: ApiConfig.apiBaseUrl,
    connectTimeout: ApiConfig.connectTimeout,
    receiveTimeout: ApiConfig.receiveTimeout,
    headers: ApiConfig.defaultHeaders,
  );
});

final dispatchersApiClientProvider = Provider<DispatchersApiClient>((ref) {
  final baseClient = ref.watch(dispatchersBaseApiClientProvider);
  return DispatchersApiClient(baseClient);
});

final dispatcherDataSourceProvider = Provider<DispatcherDatasource>((ref) {
  if (AppServiceMode.isMock) {
    final currentUserId = ref.watch(authStateProvider).user?.id;
    return DispatcherMockDataSource(currentUserId: currentUserId);
  }

  final apiClient = ref.watch(dispatchersApiClientProvider);
  return DispatcherApiDataSource(apiClient);
});

final dispatcherRepositoryProvider = Provider<DispatcherRepository>((ref) {
  final dataSource = ref.watch(dispatcherDataSourceProvider);
  return DispatcherRepositoryImp(dataSource);
});

/// *******************
///   DATA PROVIDERS -> GET
/// *******************

final dispatchersProvider = FutureProvider<List<Dispatcher>>((ref) async {
  final repository = ref.watch(dispatcherRepositoryProvider);
  return await repository.getAllDispatchers();
});

final dispatchersByStateProvider = FutureProvider.family<List<Dispatcher>, DispatcherState>(
      (ref, state) async {
    final repository = ref.watch(dispatcherRepositoryProvider);
    return await repository.getDispatchersByState(state);
  },
);

final dispatcherByIdProvider = FutureProvider.family<Dispatcher, String>(
      (ref, dispatcherId) async {
    final repository = ref.watch(dispatcherRepositoryProvider);
    return await repository.getDispatcherById(dispatcherId);
  },
);

/// The signed-in dispatcher's own backend profile (GET /dispatchers/me).
/// autoDispose: must be re-fetched fresh on every login
final dispatcherMeProvider = FutureProvider.autoDispose<Dispatcher>((ref) async {
  final repository = ref.watch(dispatcherRepositoryProvider);
  return await repository.getMyProfile();
});

/// *******************
///   CUD PROVIDERS
/// *******************

final dispatcherMutationProvider = StateNotifierProvider<DispatcherMutationNotifier, AsyncValue<void>>(
      (ref) => DispatcherMutationNotifier(ref),
);



class DispatcherMutationNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  DispatcherMutationNotifier(this._ref) : super(const AsyncValue.data(null));

  DispatcherRepository get _repository => _ref.read(dispatcherRepositoryProvider);

  /// Result of the most recent `createDispatcher()` call - holds the
  /// `passwordResetLink` the form needs to show, since `state` above only
  /// carries loading/error/void for all CUD operations.
  DispatcherCreationResult? lastCreationResult;

  Future<void> createDispatcher(Dispatcher dispatcher) async {
    state = const AsyncValue.loading();
    try {
      lastCreationResult = await _repository.createDispatcher(dispatcher);

      // Invalidate to refresh data
      _ref.invalidate(dispatchersByStateProvider);

      state = const AsyncValue.data(null);
    } catch (e, st) {
      lastCreationResult = null;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateDispatcher(Dispatcher dispatcher) async {
    state = const AsyncValue.loading();

    try {
      await _repository.updateDispatcher(dispatcher);

      // Invalidate to refresh data
      _ref.invalidate(dispatchersProvider);
      _ref.invalidate(dispatcherByIdProvider(dispatcher.id));
      _ref.invalidate(dispatchersByStateProvider);

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateDispatcherState(String dispatcherId, DispatcherState newState) async {
    state = const AsyncValue.loading();

    try {
      final dispatcher = await _repository.getDispatcherById(dispatcherId);

      final updatedDispatcher = dispatcher.copyWith(state: newState);

      await _repository.updateDispatcher(updatedDispatcher);

      // Invalidate to refresh data
      _ref.invalidate(dispatchersProvider);
      _ref.invalidate(dispatcherByIdProvider(dispatcherId));
      _ref.invalidate(dispatchersByStateProvider);

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteDispatcher(String dispatcherId) async {
    state = const AsyncValue.loading();

    try {
      await _repository.deleteDispatcher(dispatcherId);

      // Invalidate to refresh data
      _ref.invalidate(dispatchersProvider);
      _ref.invalidate(dispatcherByIdProvider(dispatcherId));
      _ref.invalidate(dispatchersByStateProvider);

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    _ref.invalidate(dispatchersByStateProvider);
  }

  // Reset state to default
  void resetState() {
    state = const AsyncValue.data(null);
  }
}