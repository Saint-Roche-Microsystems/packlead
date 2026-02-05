import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/location.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/orders/data/datasources/order_datasource.dart';

class OrderMockDataSource implements OrderDataSource {
  final List<Order> _orders = [
    Order(
      id: 'order-1',
      dispatcherId: 'disp-1',
      clientName: 'Juan Pérez',
      clientPhoneNumber: '+593987654321',
      location: Location(lat: -0.1807, lng: -78.4678),
      address: 'Av. Amazonas N24-03',
      state: OrderState.pending,
      zone: 'Norte',
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
      createdAt: DateTime(2026, 2, 2, 9, 20),
    ),
  ];

  @override
  Future<List<Order>> getAllOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return List.from(_orders);
  }

  @override
  Future<List<Order>> getOrdersByDispatcher(String dispatcherId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return _orders
        .where((order) => order.dispatcherId == dispatcherId)
        .toList();
  }

  @override
  Future<Order> updateOrder(Order order) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _orders.indexWhere((o) => o.id == order.id);

    if (index == -1) {
      throw Exception('Orden con ID ${order.id} no encontrada');
    }

    _orders[index] = order;
    return order;
  }

  @override
  Future<Order> createOrder(Order order) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final newOrder = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      dispatcherId: order.dispatcherId,
      clientName: order.clientName,
      clientPhoneNumber: order.clientPhoneNumber,
      location: order.location,
      address: order.address,
      state: OrderState.pending,
      zone: order.zone,
      createdAt: DateTime.now(),
    );

    _orders.add(newOrder);
    return newOrder;
  }

  @override
  Future<void> deleteOrder(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));

    _orders.removeWhere((order) => order.id == id);
  }
}