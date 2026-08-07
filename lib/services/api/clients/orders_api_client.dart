import 'package:packlead/core/constants/strings/errors.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/core/utils/app_logger.dart';
import 'package:packlead/services/api/base/api_exception.dart';
import 'package:packlead/services/api/base/base_api_client.dart';

/// OUTDATED ORDER MODEL
class OrdersApiClient {
  final BaseApiClient _client;

  OrdersApiClient(this._client);

  /// GET /orders with optional filters
  Future<List<Order>> getOrders({
    String? state,
    String? deliveryDate,
    String? dispatcherId,
    String? zone,
    int? limit,
  }) async {
    try {
      // Build Query Parameters
      final queryParameters = <String, dynamic>{};

      if (state != null) queryParameters['state'] = state;
      if (deliveryDate != null) queryParameters['deliveryDate'] = deliveryDate;
      if (dispatcherId != null) queryParameters['dispatcherId'] = dispatcherId;
      if (zone != null) queryParameters['zone'] = zone;
      if (limit != null) queryParameters['limit'] = limit.toString();

      final response = await _client.get<List<dynamic>>(
        '/orders',
        queryParameters: queryParameters,
      );

      // Parse response
      return _parseOrderList(response);
    } on ApiException {
      rethrow;
    } catch (e, st) {
      AppLogger.error(OrdersApiErrors.getOrders, error: e, stackTrace: st);
      throw ApiException(OrdersApiErrors.getOrders);
    }
  }

  /// GET /orders/:id
  Future<Order> getOrder(String orderId) async {
    if (orderId.isEmpty) {
      throw ArgumentError(OrdersApiErrors.orderIdRequired);
    }

    try {
      final response = await _client.get<Map<String, dynamic>>('/orders/$orderId');
      return _parseOrder(response);
    } on ApiException {
      rethrow;
    } catch (e, st) {
      AppLogger.error(OrdersApiErrors.getOrder, error: e, stackTrace: st);
      throw ApiException(OrdersApiErrors.getOrder);
    }
  }

  /// POST /orders
  Future<Order> createOrder(Map<String, dynamic> payload) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        '/orders',
        data: payload,
      );
      return _parseOrder(response);
    } on ApiException {
      rethrow;
    } catch (e, st) {
      AppLogger.error(OrdersApiErrors.createOrder, error: e, stackTrace: st);
      throw ApiException(OrdersApiErrors.createOrder);
    }
  }

  /// PUT /orders/:id
  Future<Order> updateOrder(String orderId, Map<String, dynamic> payload) async {
    if (orderId.isEmpty) {
      throw ArgumentError(OrdersApiErrors.orderIdRequired);
    }

    if (payload.isEmpty) {
      throw ArgumentError(OrdersApiErrors.payloadRequired);
    }

    try {
      final response = await _client.put<Map<String, dynamic>>(
        '/orders/$orderId',
        data: payload,
      );
      return _parseOrder(response);
    } on ApiException {
      rethrow;
    } catch (e, st) {
      AppLogger.error(OrdersApiErrors.updateOrder, error: e, stackTrace: st);
      throw ApiException(OrdersApiErrors.updateOrder);
    }
  }

  /// DELETE /orders/:id
  Future<void> deleteOrder(String orderId) async {
    if (orderId.isEmpty) {
      throw ArgumentError(OrdersApiErrors.orderIdRequired);
    }

    try {
      await _client.delete('/orders/$orderId');
    } on ApiException {
      rethrow;
    } catch (e, st) {
      AppLogger.error(OrdersApiErrors.deleteOrder, error: e, stackTrace: st);
      throw ApiException(OrdersApiErrors.deleteOrder);
    }
  }

  /// **************
  /// ** Parsers ***
  /// **************
  List<Order> _parseOrderList(List<dynamic> response) {
    return response
        .whereType<Map<String, dynamic>>()
        .map((json) => Order.fromJson(json))
        .toList();
  }

  Order _parseOrder(Map<String, dynamic> response) {
    return Order.fromJson(response);
  }
}
