import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:packlead/core/constants/dispatcher_state.dart';
import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/features/dispatcher/data/repositories/dispatcher_repository.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_provider.dart';
import 'package:packlead/features/dispatcher/presentation/screens/dispatcher_home_screen.dart';
import 'package:packlead/features/orders/data/repositories/order_repository.dart';
import 'package:packlead/features/orders/presentation/providers/orders_provider.dart';

class MockDispatcherRepository extends Mock implements DispatcherRepository {}

class MockOrderRepository extends Mock implements OrderRepository {}

// NOTE: this screen renders a GoogleMap once the profile AND today's orders
// both resolve successfully, which needs a real platform channel and isn't
// exercised here. These tests cover the states reachable without it:
// profile loading/error and orders-loading error.
void main() {
  group('DispatcherHomeScreen Widget Tests', () {
    late MockDispatcherRepository mockDispatcherRepository;
    late MockOrderRepository mockOrderRepository;

    final dispatcher = Dispatcher(
      id: 'disp-1',
      name: 'Juan Pérez',
      email: 'juan@test.com',
      vehicle: 'Moto',
      licensePlate: 'ABC-123',
      state: DispatcherState.available,
    );

    setUp(() {
      mockDispatcherRepository = MockDispatcherRepository();
      mockOrderRepository = MockOrderRepository();
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          dispatcherRepositoryProvider.overrideWithValue(
            mockDispatcherRepository,
          ),
          orderRepositoryProvider.overrideWithValue(mockOrderRepository),
        ],
        child: const MaterialApp(
          home: DispatcherHomeScreen(
            dispatcherId: 'firebase-uid-1',
            dispatcherEmail: 'juan@test.com',
          ),
        ),
      );
    }

    testWidgets('Muestra loading mientras se carga el perfil del dispatcher', (
      tester,
    ) async {
      final completer = Completer<Dispatcher>();
      when(
        () => mockDispatcherRepository.getMyProfile(),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Packlead'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Avoid a pending timer/future leaking into the next test.
      completer.complete(dispatcher);
      await tester.pumpAndSettle();
    });

    testWidgets('Muestra error cuando falla la carga del perfil', (
      tester,
    ) async {
      when(
        () => mockDispatcherRepository.getMyProfile(),
      ).thenThrow(Exception('Error de prueba'));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Error al cargar tu perfil'), findsOneWidget);
    });

    testWidgets('Muestra el botón de cerrar sesión en el AppBar', (
      tester,
    ) async {
      when(
        () => mockDispatcherRepository.getMyProfile(),
      ).thenThrow(Exception('Error de prueba'));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.logout), findsOneWidget);
      expect(find.byTooltip('Salir'), findsOneWidget);
    });

    testWidgets('Muestra error cuando falla la carga de pedidos del día', (
      tester,
    ) async {
      when(
        () => mockDispatcherRepository.getMyProfile(),
      ).thenAnswer((_) async => dispatcher);
      when(
        () => mockOrderRepository.getOrdersByDispatcher(any(), any()),
      ).thenThrow(Exception('Error de prueba'));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Error al cargar tus órdenes'), findsOneWidget);
    });
  });
}
