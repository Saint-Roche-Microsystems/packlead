import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/orders/data/datasources/order_datasource.dart';
import 'package:packlead/mocks/orders_mock_data.dart';

class OrderMockDataSource implements OrderDataSource {
  final _orders = OrdersMockData().orders;

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