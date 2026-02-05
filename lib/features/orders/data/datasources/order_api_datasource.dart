import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/orders/data/datasources/order_datasource.dart';
import 'package:packlead/services/api/clients/orders_api_client.dart';

class OrderApiDataSource implements OrderDataSource {
  final OrdersApiClient _apiClient;

  OrderApiDataSource(this._apiClient);

  @override
  Future<List<Order>> getAllOrders() async {
    try {
      return await _apiClient.getOrders();
    } catch (e) {
      throw Exception('Error al obtener todas las órdenes: $e');
    }
  }

  @override
  Future<List<Order>> getOrdersByDispatcher(String dispatcherId) async {
    try {
      return await _apiClient.getOrders(dispatcherId: dispatcherId);
    } catch (e) {
      throw Exception('Error al obtener órdenes por dispatcher: $e');
    }
  }

  @override
  Future<Order> createOrder(Order order) async {
    try {
      final payload = order.toJson();
      return await _apiClient.createOrder(payload);
    } catch (e) {
      throw Exception('Error al crear orden: $e');
    }
  }

  @override
  Future<Order> updateOrder(Order order) async {
    try {
      final payload = order.toJson();
      return await _apiClient.updateOrder(order.id, payload);
    } catch (e) {
      throw Exception('Error al actualizar orden: $e');
    }
  }

  @override
  Future<void> deleteOrder(String id) async {
    try {
      await _apiClient.deleteOrder(id);
    } catch (e) {
      throw Exception('Error al eliminar orden: $e');
    }
  }
}