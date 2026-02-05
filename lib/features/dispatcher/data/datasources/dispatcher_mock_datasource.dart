import 'package:packlead/core/constants/dispatcher_state.dart';
import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/features/dispatcher/data/datasources/dispatcher_datasource.dart';


class DispatcherMockDataSource implements DispatcherDatasource {
  final List<Dispatcher> _dispatchers = [
    Dispatcher(
      id: 'disp-1',
      name: 'Carlos Méndez',
      email: 'carlos.mendez@delivery.com',
      vehicle: 'Moto Honda CG 150',
      licensePlate: 'PBX-1234',
      state: DispatcherState.assigned,
    ),
    Dispatcher(
      id: 'disp-2',
      name: 'Ana Rodríguez',
      email: 'ana.rodriguez@delivery.com',
      vehicle: 'Moto Yamaha FZ',
      licensePlate: 'PCH-5678',
      state: DispatcherState.available,
    ),
    Dispatcher(
      id: 'disp-3',
      name: 'Luis Torres',
      email: 'luis.torres@delivery.com',
      vehicle: 'Moto Suzuki GN',
      licensePlate: 'PGY-9012',
      state: DispatcherState.available,
    ),
    Dispatcher(
      id: 'disp-4',
      name: 'María Castillo',
      email: 'maria.castillo@delivery.com',
      vehicle: 'Moto Kawasaki Boxer',
      licensePlate: 'PIM-3456',
      state: DispatcherState.inactive,
    ),
    Dispatcher(
      id: 'disp-5',
      name: 'Jorge Sánchez',
      email: 'jorge.sanchez@delivery.com',
      vehicle: 'Moto Honda Wave',
      licensePlate: 'PLT-7890',
      state: DispatcherState.assigned,
    ),
  ];

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