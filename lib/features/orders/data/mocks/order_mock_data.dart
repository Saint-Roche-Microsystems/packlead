import 'package:packlead/core/models/location.dart';
import 'package:packlead/core/models/order.dart';

class OrderMockData {
  static final List<Order> orders = [
    Order(
      id: 'ORD-001',
      dispatcherId: 'DISP-001',
      client: 'Juan Pérez',
      phoneNumber: '+51 987 654 321',
      location: Location(lat: -12.0464, lng: -77.0428),
      state: 'pending',
      zone: 'Miraflores',
      dispatcherName: 'Carlos Rodríguez',
    ),
    Order(
      id: 'ORD-002',
      dispatcherId: 'DISP-002',
      client: 'María García',
      phoneNumber: '+51 987 123 456',
      location: Location(lat: -12.0564, lng: -77.0328),
      state: 'in_route',
      zone: 'San Isidro',
      dispatcherName: 'Ana López',
    ),
    Order(
      id: 'ORD-003',
      dispatcherId: 'DISP-003',
      client: 'Roberto Sánchez',
      phoneNumber: '+51 987 789 012',
      location: Location(lat: -12.0664, lng: -77.0228),
      state: 'delivered',
      zone: 'Surco',
      dispatcherName: 'Luis Torres',
    ),
  ];

  static const List<String> orderStates = [
    'pending',
    'assigned',
    'in_route',
    'delivered',
    'cancelled',
  ];

  static const List<String> zones = [
    'Miraflores',
    'San Isidro',
    'Surco',
    'Barranco',
    'La Molina',
    'San Borja',
  ];

  static const List<String> dispatcherNames = [
    'Carlos Rodríguez',
    'Ana López',
    'Luis Torres',
    'Marta Jiménez',
    'Pedro Gómez',
  ];

  static List<Order> generateOrders({int count = 10}) {
    return List.generate(count, (index) {
      final stateIndex = index % orderStates.length;
      final zoneIndex = index % zones.length;
      final dispatcherIndex = index % dispatcherNames.length;

      return Order(
        id: 'ORD-${(index + 100).toString().padLeft(3, '0')}',
        dispatcherId: 'DISP-${(index + 1).toString().padLeft(3, '0')}',
        client: 'Cliente ${index + 1}',
        phoneNumber: '+51 987 ${(100 + index).toString().padLeft(3, '0')} ${(200 + index).toString().padLeft(3, '0')}',
        location: Location(
          lat: -12.0464 + (index * 0.002),
          lng: -77.0428 + (index * 0.002),
        ),
        state: orderStates[stateIndex],
        zone: zones[zoneIndex],
        dispatcherName: dispatcherNames[dispatcherIndex],
      );
    });
  }

  static List<Order> getOrdersWithUpdates(int updateCount) {
    final updatedOrders = List<Order>.from(orders);

    if (updateCount % 5 == 0 && updatedOrders.isNotEmpty) {
      final randomIndex = updateCount % updatedOrders.length;
      final currentOrder = updatedOrders[randomIndex];
      final currentStateIndex = orderStates.indexOf(currentOrder.state);
      final nextStateIndex = (currentStateIndex + 1) % orderStates.length;

      updatedOrders[randomIndex] = Order(
        id: currentOrder.id,
        dispatcherId: currentOrder.dispatcherId,
        client: currentOrder.client,
        phoneNumber: currentOrder.phoneNumber,
        location: currentOrder.location,
        state: orderStates[nextStateIndex],
        zone: currentOrder.zone,
        dispatcherName: currentOrder.dispatcherName,
      );
    }

    return updatedOrders;
  }
}