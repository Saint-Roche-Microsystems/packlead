import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/dispatcher_location.dart';
import 'package:packlead/core/models/location.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/admin/presentation/providers/live_tracking_provider.dart';
import 'package:packlead/features/admin/presentation/screens/admin_home_screen.dart';
import 'package:packlead/features/admin/presentation/screens/admin_order_screen.dart';
import 'package:packlead/features/admin/presentation/screens/forms/create_order_form.dart';
import 'package:packlead/features/dispatcher/data/repositories/dispatcher_repository.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_provider.dart';
import 'package:packlead/features/orders/data/repositories/order_repository.dart';
import 'package:packlead/features/orders/presentation/providers/orders_provider.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

class MockDispatcherRepository extends Mock implements DispatcherRepository {}

Order buildOrder({
  required String id,
  required OrderState state,
  String zone = 'Zona 1',
}) {
  return Order(
    id: id,
    dispatcherId: null,
    clientName: 'Carlos',
    clientPhoneNumber: '0999999999',
    location: Location(lat: -0.18, lng: -78.48),
    address: 'Centro',
    state: state,
    zone: zone,
    deliveryDate: DateTime(2026, 2, 10),
    createdAt: DateTime(2026, 2, 1),
  );
}

void main() {
  group('AdminOrderScreen Widget Tests', () {
    late MockOrderRepository mockOrderRepository;
    late MockDispatcherRepository mockDispatcherRepository;

    setUpAll(() {
      registerFallbackValue(OrderState.pending);
    });

    setUp(() {
      mockOrderRepository = MockOrderRepository();
      mockDispatcherRepository = MockDispatcherRepository();

      when(() => mockDispatcherRepository.getAllDispatchers())
          .thenAnswer((_) async => []);
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          orderRepositoryProvider.overrideWithValue(mockOrderRepository),
          dispatcherRepositoryProvider.overrideWithValue(mockDispatcherRepository),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: AdminOrderScreen(),
          ),
        ),
      );
    }

    testWidgets('Renderiza botón y tabs por estado', (tester) async {
      when(() => mockOrderRepository.getOrdersByState(any()))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Crear pedido'), findsOneWidget);
      expect(find.text('Pendientes'), findsOneWidget);
      expect(find.text('En ruta'), findsOneWidget);
      expect(find.text('Entregados'), findsOneWidget);
    });

    testWidgets('Navega a CreateOrderForm', (tester) async {
      when(() => mockOrderRepository.getOrdersByState(any()))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Crear pedido'));
      await tester.pumpAndSettle();

      expect(find.byType(CreateOrderForm), findsOneWidget);
    });

    testWidgets('Muestra mensaje vacío en la pestaña activa', (tester) async {
      when(() => mockOrderRepository.getOrdersByState(any()))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('No hay pedidos'), findsOneWidget);
    });

    testWidgets('Muestra lista de pedidos pendientes cuando hay datos', (tester) async {
      when(() => mockOrderRepository.getOrdersByState(OrderState.pending))
          .thenAnswer((_) async => [buildOrder(id: 'ORD-1', state: OrderState.pending)]);
      when(() => mockOrderRepository.getOrdersByState(OrderState.shipped))
          .thenAnswer((_) async => []);
      when(() => mockOrderRepository.getOrdersByState(OrderState.delivered))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('ORD-1'), findsOneWidget);
      expect(find.text('Zona: Zona 1'), findsOneWidget);
    });

    testWidgets('Muestra error cuando falla la carga de pedidos', (tester) async {
      when(() => mockOrderRepository.getOrdersByState(any()))
          .thenThrow(Exception('Error de prueba'));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('No se pudieron cargar los pedidos'), findsOneWidget);
    });
  });

  group('AdminHomeScreen Widget Tests', () {
    late MockOrderRepository mockOrderRepository;

    setUpAll(() {
      // AdminDashboardNotifier reads AppServiceMode (LOCAL_SERVICE) directly,
      // so dotenv must be initialized even though we override its dependant providers.
      dotenv.testLoad(fileInput: 'LOCAL_SERVICE=API');
    });

    setUp(() {
      mockOrderRepository = MockOrderRepository();
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          orderRepositoryProvider.overrideWithValue(mockOrderRepository),
          liveTrackingProvider.overrideWith((ref) => Stream.value(<DispatcherLocation>[])),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: AdminHomeScreen(),
          ),
        ),
      );
    }

    testWidgets('Muestra KPIs y gráfico cuando no hay pedidos', (tester) async {
      when(() => mockOrderRepository.getOrdersByDate(any())).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Pedidos del día'), findsOneWidget);
      expect(find.text('Repartidores activos'), findsOneWidget);
      expect(find.text('Progreso del Día'), findsOneWidget);
      expect(find.text('0'), findsNWidgets(2));
      expect(find.textContaining('No hay pedidos registrados'), findsOneWidget);
    });

    testWidgets('Muestra el conteo correcto de pedidos del día por estado', (tester) async {
      when(() => mockOrderRepository.getOrdersByDate(any())).thenAnswer(
        (_) async => [
          buildOrder(id: 'ORD-1', state: OrderState.pending),
          buildOrder(id: 'ORD-2', state: OrderState.shipped),
          buildOrder(id: 'ORD-3', state: OrderState.delivered),
        ],
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget); // total orders
      expect(find.text('0'), findsOneWidget); // online dispatchers
    });

    testWidgets('Muestra error cuando falla la carga del dashboard', (tester) async {
      when(() => mockOrderRepository.getOrdersByDate(any()))
          .thenThrow(Exception('Error de prueba'));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Oops! Ocurrió un error al obtener los datos del dashboard'),
        findsOneWidget,
      );
    });
  });
}
