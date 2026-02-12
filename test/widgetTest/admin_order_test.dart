import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:packlead/core/constants/dispatcher_state.dart';
import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/features/admin/presentation/screens/admin_dispatcher_screen.dart';
import 'package:packlead/features/admin/presentation/screens/forms/create_dispatcher_form.dart';
import 'package:packlead/features/dispatcher/data/repositories/dispatcher_repository.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_provider.dart';

class MockDispatcherRepository extends Mock implements DispatcherRepository {}

void main() {
  late MockDispatcherRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(DispatcherState.available);
  });

  setUp(() {
    mockRepository = MockDispatcherRepository();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        dispatcherRepositoryProvider.overrideWithValue(mockRepository),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: AdminDispatcherScreen(),
        ),
      ),
    );
  }

  group('AdminDispatcherScreen Widget Tests', () {

    testWidgets('Renderiza botón y tabs', (tester) async {
      when(() => mockRepository.getDispatchersByState(any()))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Agregar repartidor'), findsOneWidget);
      expect(find.text('Activos'), findsOneWidget);
      expect(find.text('Inactivos'), findsOneWidget);
    });

    testWidgets('Navega a CreateDispatcherForm', (tester) async {
      when(() => mockRepository.getDispatchersByState(any()))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Agregar repartidor'));
      await tester.pumpAndSettle();

      expect(find.byType(CreateDispatcherForm), findsOneWidget);
    });

    testWidgets('Muestra mensaje vacío', (tester) async {
      when(() => mockRepository.getDispatchersByState(any()))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('No hay repartidores'), findsOneWidget);
    });

    testWidgets('Muestra lista cuando hay datos', (tester) async {
      final fakeDispatchers = [
        Dispatcher(
          id: '1',
          name: 'Juan Pérez',
          email: 'juan@test.com',
          vehicle: 'Moto',
          licensePlate: 'ABC-123',
          state: DispatcherState.available,
        ),
      ];

      when(() => mockRepository.getDispatchersByState(any()))
          .thenAnswer((_) async => fakeDispatchers);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Muestra error', (tester) async {
      when(() => mockRepository.getDispatchersByState(any()))
          .thenThrow(Exception('Error de prueba'));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.textContaining('No se pudieron cargar los repartidores'),
        findsOneWidget,
      );
    });

  });
}
