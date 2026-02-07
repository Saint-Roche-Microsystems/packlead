import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/location.dart';
import 'package:packlead/core/models/order.dart';

class OrdersMockData {
  final List<Order> orders = [
    Order(
      id: 'order-1',
      dispatcherId: 'disp-1',
      clientName: 'Juan Pérez',
      clientPhoneNumber: '+593987654321',
      location: Location(lat: -0.1807, lng: -78.4678),
      address: 'Av. Amazonas N24-03',
      state: OrderState.pending,
      zone: 'Norte',
      deliveryDate: DateTime(2026, 2, 8),
      createdAt: DateTime(2026, 2, 1, 10, 30),
    ),
    Order(
      id: 'order-2',
      dispatcherId: 'disp-2',
      clientName: 'María González',
      clientPhoneNumber: '+593987654322',
      location: Location(lat: -0.2299, lng: -78.5249),
      address: 'Calle García Moreno 545',
      state: OrderState.shipped,
      zone: 'Centro',
      deliveryDate: DateTime(2026, 2, 14),
      createdAt: DateTime(2026, 2, 1, 11, 15),
    ),
    Order(
      id: 'order-3',
      dispatcherId: 'disp-1',
      clientName: 'Carlos Ruiz',
      clientPhoneNumber: '+593987654323',
      location: Location(lat: -0.3074, lng: -78.5594),
      address: null,
      state: OrderState.delivered,
      zone: 'Sur',
      deliveryDate: DateTime(2026, 2, 8),
      createdAt: DateTime(2026, 2, 1, 14, 45),
    ),
    Order(
      id: 'order-4',
      dispatcherId: null,
      clientName: 'Ana Torres',
      clientPhoneNumber: '+593987654324',
      location: Location(lat: -0.1458, lng: -78.4905),
      address: 'Av. Naciones Unidas E10-43',
      state: OrderState.pending,
      zone: 'Norte',
      deliveryDate: DateTime(2026, 2, 9),
      createdAt: DateTime(2026, 2, 2, 9, 20),
    ),
  ];
}