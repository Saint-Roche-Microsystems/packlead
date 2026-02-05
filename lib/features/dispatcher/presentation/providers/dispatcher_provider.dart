import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/features/dispatcher/data/datasources/dispatcher_datasource.dart';
import 'package:packlead/features/dispatcher/data/datasources/dispatcher_mock_datasource.dart';
import 'package:packlead/features/dispatcher/data/repositories/dispatcher_repository.dart';
import 'package:packlead/features/dispatcher/data/repositories/dispatcher_repository_imp.dart';

/// *******************
/// CONFIG PROVIDERS
/// *******************

final dispatcherDataSourceProvider = Provider<DispatcherDatasource>((ref) {
  // Dev ONY - use mock data
  return DispatcherMockDataSource();

  // Use real API service
  // final apiClient = ref.watch(apiClientProvider);
  // return DispatcherDatasource(apiClient);
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

final dispatchersAvailableProvider = FutureProvider<List<Dispatcher>>((ref) async {
  final repository = ref.watch(dispatcherRepositoryProvider);
  return await repository.getAvailableDispatchers();
});

/// *******************
///   CUD PROVIDERS
/// *******************

final dispatcherMutationProvider = Provider<DispatcherMutation>((ref) {
  final repository = ref.watch(dispatcherRepositoryProvider);
  return DispatcherMutation(repository, ref);
});


class DispatcherMutation {
  final DispatcherRepository _repository;
  final Ref _ref;

  DispatcherMutation(this._repository, this._ref);

  Future<Dispatcher> createDispatcher(Dispatcher dispatcher) async {
    final createdDispatcher = await _repository.createDispatcher(dispatcher);

    // Invalidate to refresh data
    _ref.invalidate(dispatchersProvider);

    return createdDispatcher;
  }

  Future<Dispatcher> updateDispatcher(Dispatcher dispatcher) async {
    final updatedOrder = await _repository.updateDispatcher(dispatcher);

    // Invalidate to refresh data
    _ref.invalidate(dispatchersProvider);

    return updatedOrder;
  }

  Future<void> deleteDispatcher(String dispatcherId) async {
    await _repository.deleteDispatcher(dispatcherId);

    // Invalidate to refresh data
    _ref.invalidate(dispatchersProvider);
  }
}