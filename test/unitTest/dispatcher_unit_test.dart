import 'package:flutter_test/flutter_test.dart';
import 'package:packlead/core/constants/dispatcher_state.dart';
import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/features/dispatcher/data/datasources/dispatcher_mock_datasource.dart';

void main() {
  late DispatcherMockDataSource dataSource;

  setUp(() {
    dataSource = DispatcherMockDataSource();
  });

  group('DispatcherMockDataSource', () {

    test('Debe retornar todos los dispatchers', () async {
      final result = await dataSource.getAllDispatchers();

      expect(result, isA<List<Dispatcher>>());
      expect(result.isNotEmpty, true);
    });

    test('Debe filtrar dispatchers por estado available', () async {
      final result = await dataSource.getDispatchersByState(
        DispatcherState.available,
      );

      expect(result.every((d) => d.state == DispatcherState.available), true);
    });

    test('Debe retornar dispatcher por ID existente', () async {
      final all = await dataSource.getAllDispatchers();
      final dispatcher = all.first;

      final result = await dataSource.getDispatcherById(dispatcher.id);

      expect(result.id, dispatcher.id);
      expect(result.name, dispatcher.name);
    });

    test('Debe lanzar excepción si el dispatcher no existe', () async {
      expect(
            () => dataSource.getDispatcherById('id-inexistente'),
        throwsException,
      );
    });

    test('Debe crear dispatcher con estado default available', () async {
      final newDispatcher = Dispatcher(
        id: '',
        name: 'Nuevo Dispatcher',
        email: 'nuevo@test.com',
        vehicle: 'Moto',
        licensePlate: 'ABC123',
        state: DispatcherState.inactive, // se ignora al crear
      );

      final result = await dataSource.createDispatcher(newDispatcher);

      expect(result.id.startsWith('disp-'), true);
      expect(result.state, DispatcherState.available);

      final all = await dataSource.getAllDispatchers();
      expect(all.any((d) => d.id == result.id), true);
    });

    test('Debe actualizar dispatcher cambiando su estado a inactive', () async {
      final all = await dataSource.getAllDispatchers();
      final dispatcher = all.first;

      final updatedDispatcher = Dispatcher(
        id: dispatcher.id,
        name: dispatcher.name,
        email: dispatcher.email,
        vehicle: dispatcher.vehicle,
        licensePlate: dispatcher.licensePlate,
        state: DispatcherState.inactive,
      );

      final result = await dataSource.updateDispatcher(updatedDispatcher);

      expect(result.state, DispatcherState.inactive);

      final updated = await dataSource.getDispatcherById(dispatcher.id);
      expect(updated.state, DispatcherState.inactive);
    });

    test('Debe eliminar dispatcher correctamente', () async {
      final all = await dataSource.getAllDispatchers();
      final dispatcher = all.first;

      await dataSource.deleteDispatcher(dispatcher.id);

      final updatedList = await dataSource.getAllDispatchers();
      expect(updatedList.any((d) => d.id == dispatcher.id), false);
    });

  });
}
