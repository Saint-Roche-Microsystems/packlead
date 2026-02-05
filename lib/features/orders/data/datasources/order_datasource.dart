import 'package:packlead/core/models/order.dart';

abstract class OrderDataSource {
  Future<List<Order>> getAllOrders();
  Future<List<Order>> getOrdersByDispatcher(String dispatcherId);
  Future<Order> createOrder(Order order);
  Future<void> deleteOrder(String id);
}