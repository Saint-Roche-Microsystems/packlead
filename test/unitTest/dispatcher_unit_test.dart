import 'package:flutter_test/flutter_test.dart';
import 'package:packlead/core/constants/dispatcher_state.dart';
import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/features/dispatcher/data/datasources/dispatcher_mock_datasource.dart';

void main() {
  late DispatcherMockDataSource dataSource;

  setUp(() {
    dataSource = DispatcherMockDataSource();
  });

  group('DispatcherMockDataSource - Unit Tests (AAA)', () {

    test('Debe retornar todos los dispatchers', () async {
      // ================= ARRANGE =================
      // DataSource ya inicializado en setUp()

      // ================= ACT =================
      final result = await dataSource.getAllDispatchers();

      // ================= ASSERT =================
      expect(result, isA<List<Dispatcher>>());
      expect(result.isNotEmpty, true);
    });

    test('2 Debe filtrar dispatchers por estado available', () async {
      // ================= ARRANGE =================
      const state = DispatcherState.available;

      // ================= ACT =================
      final result = await dataSource.getDispatchersByState(state);

      // ================= ASSERT =================
      expect(result.every((d) => d.state == state), true);
    });

    test(' Debe retornar dispatcher por ID existente', () async {
      // ================= ARRANGE =================
      final all = await dataSource.getAllDispatchers();
      final dispatcher = all.first;

      // ================= ACT =================
      final result = await dataSource.getDispatcherById(dispatcher.id);

      // ================= ASSERT =================
      expect(result.id, dispatcher.id);
      expect(result.name, dispatcher.name);
    });

    test('4️ Debe lanzar excepción si el dispatcher no existe', () async {
      // ================= ARRANGE =================
      const invalidId = 'id-inexistente';

      // ================= ACT & ASSERT =================
      await expectLater(
            () => dataSource.getDispatcherById(invalidId),
        throwsException,
      );
    });

    test('5️ Debe crear dispatcher con estado default available', () async {
      // ================= ARRANGE =================
      final newDispatcher = Dispatcher(
        id: '',
        name: 'Nuevo Dispatcher',
        email: 'nuevo@test.com',
        vehicle: 'Moto',
        licensePlate: 'ABC123',
        state: DispatcherState.inactive,
      );

      // ================= ACT =================
      final result = await dataSource.createDispatcher(newDispatcher);

      // ================= ASSERT =================
      expect(result.dispatcher.id.startsWith('disp-'), true);
      expect(result.dispatcher.state, DispatcherState.available);
    });

    test('6️ Debe actualizar dispatcher cambiando su estado a inactive', () async {
      // ================= ARRANGE =================
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

      // ================= ACT =================
      final result = await dataSource.updateDispatcher(updatedDispatcher);

      // ================= ASSERT =================
      expect(result.state, DispatcherState.inactive);
    });

    test('7️ Debe eliminar dispatcher correctamente', () async {
      // ================= ARRANGE =================
      final all = await dataSource.getAllDispatchers();
      final dispatcher = all.first;

      // ================= ACT =================
      await dataSource.deleteDispatcher(dispatcher.id);
      final updatedList = await dataSource.getAllDispatchers();

      // ================= ASSERT =================
      expect(updatedList.any((d) => d.id == dispatcher.id), false);
    });

  });
}
