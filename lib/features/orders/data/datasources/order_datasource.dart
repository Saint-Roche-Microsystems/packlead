import 'package:packlead/core/models/order.dart';

abstract class OrderDataSource {
  Future<List<Order>> getAllOrders();
  Future<Order> getOrderById(String id);
  Future<List<Order>> getOrdersByDispatcher(String dispatcherId);
  Future<Order> createOrder(Order order);
  Future<Order> updateOrder(Order order);
  Future<void> deleteOrder(String id);
}