import 'package:flutter_test/flutter_test.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/core/models/location.dart';

void main() {
  group('Order Model - Unit Tests (AAA)', () {
    late Location location;
    late DateTime deliveryDate;
    late DateTime createdAt;

    setUp(() {
      location = Location(lat: -0.18, lng: -78.48);
      deliveryDate = DateTime(2026, 2, 10);
      createdAt = DateTime(2026, 2, 1);
    });

    test('1️ Constructor create debe asignar estado pending e id vacío', () {
      // =============== ARRANGE ===============
      final order = Order.create(
        clientName: 'Carlos',
        clientPhoneNumber: '0999999999',
        location: location,
        zone: 'Zona 1',
        deliveryDate: deliveryDate,
      );

      // =============== ACT ===============
      final result = order;

      // =============== ASSERT ===============
      expect(result.id, '');
      expect(result.state, OrderState.pending);
    });

    test('2️ toJson debe serializar correctamente', () {
      // =============== ARRANGE ===============
      final order = Order(
        id: 'ORD-1',
        dispatcherId: 'disp-1',
        clientName: 'Carlos',
        clientPhoneNumber: '0999999999',
        location: location,
        address: 'Centro',
        state: OrderState.shipped,
        zone: 'Zona 1',
        deliveryDate: deliveryDate,
        createdAt: createdAt,
      );

      // =============== ACT ===============
      final json = order.toJson();

      // =============== ASSERT ===============
      expect(json['id'], 'ORD-1');
      expect(json['state'], 'shipped');
      expect(json['location']['lat'], location.lat);
    });

    test('3️ fromJson debe deserializar correctamente', () {
      // =============== ARRANGE ===============
      final json = {
        'id': 'ORD-1',
        'dispatcherId': 'disp-1',
        'clientName': 'Carlos',
        'clientPhoneNumber': '0999999999',
        'location': {'lat': -0.18, 'lng': -78.48},
        'address': 'Centro',
        'state': 'delivered',
        'zone': 'Zona 1',
        'deliveryDate': deliveryDate.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      };

      // =============== ACT ===============
      final order = Order.fromJson(json);

      // =============== ASSERT ===============
      expect(order.id, 'ORD-1');
      expect(order.state, OrderState.delivered);
      expect(order.location.lat, -0.18);
    });

    test('4️ copyWith debe modificar solo los campos enviados', () {
      // =============== ARRANGE ===============
      final order = Order(
        id: 'ORD-1',
        dispatcherId: null,
        clientName: 'Carlos',
        clientPhoneNumber: '0999999999',
        location: location,
        address: null,
        state: OrderState.pending,
        zone: 'Zona 1',
        deliveryDate: deliveryDate,
        createdAt: createdAt,
      );

      // =============== ACT ===============
      final updated = order.copyWith(state: OrderState.delivered);

      // =============== ASSERT ===============
      expect(updated.state, OrderState.delivered);
      expect(updated.clientName, order.clientName);
    });

    test('5️ operator == debe comparar correctamente dos órdenes iguales', () {
      // =============== ARRANGE ===============
      final order1 = Order(
        id: 'ORD-1',
        dispatcherId: null,
        clientName: 'Carlos',
        clientPhoneNumber: '0999999999',
        location: location,
        address: null,
        state: OrderState.pending,
        zone: 'Zona 1',
        deliveryDate: deliveryDate,
        createdAt: createdAt,
      );

      final order2 = order1.copyWith();

      // =============== ACT ===============
      final isEqual = order1 == order2;

      // =============== ASSERT ===============
      expect(isEqual, true);
    });
  });

  group('Location Model - Unit Tests (AAA)', () {
    test('6️ toJson debe serializar Location correctamente', () {
      // =============== ARRANGE ===============
      final location = Location(lat: -0.18, lng: -78.48);

      // =============== ACT ===============
      final json = location.toJson();

      // =============== ASSERT ===============
      expect(json['lat'], -0.18);
      expect(json['lng'], -78.48);
    });

    test('7️ fromJson debe deserializar Location correctamente', () {
      // =============== ARRANGE ===============
      final json = {'lat': -0.18, 'lng': -78.48};

      // =============== ACT ===============
      final location = Location.fromJson(json);

      // =============== ASSERT ===============
      expect(location.lat, -0.18);
      expect(location.lng, -78.48);
    });

    test('8️ operator == debe comparar Locations correctamente', () {
      // =============== ARRANGE ===============
      final loc1 = Location(lat: 1.0, lng: 2.0);
      final loc2 = Location(lat: 1.0, lng: 2.0);

      // =============== ACT ===============
      final isEqual = loc1 == loc2;

      // =============== ASSERT ===============
      expect(isEqual, true);
    });
  });
}
