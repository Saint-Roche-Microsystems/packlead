import 'package:packlead/core/constants/dispatcher_state.dart';
import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/features/dispatcher/data/datasources/dispatcher_datasource.dart';
import 'package:packlead/mocks/dispatcher_mock_data.dart';


class DispatcherMockDataSource implements DispatcherDatasource {
  final _dispatchers = DispatcherMockData().dispatchers;

  @override
  Future<List<Dispatcher>> getAllDispatchers() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return List.from(_dispatchers);
  }

  @override
  Future<List<Dispatcher>> getAvailableDispatchers() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return _dispatchers
        .where((dispatcher) => dispatcher.state == DispatcherState.available)
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
  Future<Dispatcher> createDispatcher(Dispatcher dispatcher) async {
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
    return newDispatcher;
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