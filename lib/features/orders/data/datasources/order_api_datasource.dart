import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/core/utils/app_logger.dart';
import 'package:packlead/core/utils/date_formatter.dart';
import 'package:packlead/features/orders/data/datasources/order_datasource.dart';
import 'package:packlead/services/api/clients/orders_api_client.dart';

class OrderApiDataSource implements OrderDataSource {
  final OrdersApiClient _apiClient;

  OrderApiDataSource(this._apiClient);

  @override
  Future<List<Order>> getAllOrders() async {
    try {
      return await _apiClient.getOrders();
    } catch (e, st) {
      AppLogger.error(
        'Error al obtener todos los pedidos',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  @override
  Future<Order> getOrderById(String id) async {
    try {
      return await _apiClient.getOrder(id);
    } catch (e, st) {
      AppLogger.error(
        'Error al obtener pedido por ID',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  @override
  Future<List<Order>> getOrdersByDispatcher(
    String dispatcherId,
    DateTime forDate,
  ) async {
    try {
      return await _apiClient.getOrders(dispatcherId: dispatcherId);
    } catch (e, st) {
      AppLogger.error(
        'Error al obtener pedidos por repartidor',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  @override
  Future<List<Order>> getOrdersByState(OrderState state) async {
    try {
      return await _apiClient.getOrders(state: state.name);
    } catch (e, st) {
      AppLogger.error(
        'Error al obtener pedidos por estado',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  @override
  Future<List<Order>> getOrdersByDate(DateTime date) async {
    try {
      // Format date to YYYY-MM-DD
      final dateString = DateFormatter.formatDateUTC(date);

      return await _apiClient.getOrders(deliveryDate: dateString);
    } catch (e, st) {
      AppLogger.error(
        'Error al obtener pedidos por fecha',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  @override
  Future<Order> createOrder(Order order) async {
    try {
      final payload = order.toJson();
      return await _apiClient.createOrder(payload);
    } catch (e, st) {
      AppLogger.error('Error al crear pedido', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<Order> updateOrder(Order order) async {
    try {
      final payload = order.toJson();
      return await _apiClient.updateOrder(order.id, payload);
    } catch (e, st) {
      AppLogger.error('Error al actualizar pedido', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> deleteOrder(String id) async {
    try {
      await _apiClient.deleteOrder(id);
    } catch (e, st) {
      AppLogger.error('Error al eliminar pedido', error: e, stackTrace: st);
      rethrow;
    }
  }
}
