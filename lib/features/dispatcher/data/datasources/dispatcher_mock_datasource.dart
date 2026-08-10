import 'package:packlead/core/constants/dispatcher_state.dart';
import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/features/dispatcher/data/datasources/dispatcher_datasource.dart';
import 'package:packlead/features/dispatcher/models/dispatcher_creation_result.dart';
import 'package:packlead/mocks/dispatcher_mock_data.dart';

class DispatcherMockDataSource implements DispatcherDatasource {
  DispatcherMockDataSource({String? currentUserId})
    : _currentUserId = currentUserId;

  final String? _currentUserId;
  final _dispatchers = DispatcherMockData().dispatchers;

  @override
  Future<List<Dispatcher>> getAllDispatchers() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return List.from(_dispatchers);
  }

  @override
  Future<List<Dispatcher>> getDispatchersByState(DispatcherState state) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return _dispatchers
        .where((dispatcher) => dispatcher.state == state)
        .toList();
  }

  @override
  Future<Dispatcher> getDispatcherById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return _dispatchers.firstWhere((dispatcher) => dispatcher.id == id);
    } catch (e) {
      throw Exception('Dispatcher con ID $id no encontrado');
    }
  }

  @override
  Future<Dispatcher> getMyProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (_currentUserId == null) {
      throw Exception('No hay un usuario autenticado');
    }

    return getDispatcherById(_currentUserId);
  }

  @override
  Future<DispatcherCreationResult> createDispatcher(
    Dispatcher dispatcher,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final newDispatcher = Dispatcher(
      id: 'disp-${DateTime.now().millisecondsSinceEpoch}',
      name: dispatcher.name,
      email: dispatcher.email,
      vehicle: dispatcher.vehicle,
      licensePlate: dispatcher.licensePlate,
      state: DispatcherState.available,
    );

    _dispatchers.add(newDispatcher);

    // The mock has no Firebase-backed invite flow, so there's no real link.
    return DispatcherCreationResult(
      dispatcher: newDispatcher,
      passwordResetLink: null,
    );
  }

  @override
  Future<Dispatcher> updateDispatcher(Dispatcher dispatcher) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _dispatchers.indexWhere((d) => d.id == dispatcher.id);

    if (index == -1) {
      throw Exception('Dispatcher con ID ${dispatcher.id} no encontrado');
    }

    _dispatchers[index] = dispatcher;
    return dispatcher;
  }

  @override
  Future<void> deleteDispatcher(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));

    _dispatchers.removeWhere((dispatcher) => dispatcher.id == id);
  }
}
