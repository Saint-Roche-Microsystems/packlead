import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/orders/data/orders_api_client.dart';

class OrdersRepository {
  OrdersRepository({OrdersApiClient? apiClient})
      : _apiClient = apiClient ?? OrdersApiClient();

  static const List<String> _allStates = [
    'pending',
    'assigned',
    'in_route',
    'delivered',
    'cancelled',
  ];

  final OrdersApiClient _apiClient;

  Future<List<Order>> fetchOrders({
    String? state,
    String? dispatcherId,
    String? zone,
    int? limit,
  }) async {
    final filterCount = [state, dispatcherId, zone].where((value) => value != null).length;

    if (filterCount == 0) {
      final results = await Future.wait(
        _allStates.map(
          (currentState) => _apiClient.getOrders(
            state: currentState,
            limit: limit,
          ),
        ),
      );

      final combined = results.expand((orders) => orders).toList();
      combined.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return combined;
    }

    final orders = await _apiClient.getOrders(
      state: state,
      dispatcherId: dispatcherId,
      zone: zone,
      limit: limit,
    );

    orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return orders;
  }

  Future<Order> fetchOrder(String orderId) {
    return _apiClient.getOrder(orderId);
  }

  Future<Order> createOrder({
    required String client,
    required String phoneNumber,
    required String zone,
    required double latitude,
    required double longitude,
    String? dispatcherId,
    String? dispatcherName,
    String? address,
    String? state,
    DateTime? assignedAt,
    DateTime? deliveredAt,
  }) {
    final payload = <String, dynamic>{
      'client': client,
      'phoneNumber': phoneNumber,
      'zone': zone,
      'location': {
        'lat': latitude,
        'lng': longitude,
      },
      if (dispatcherId != null) 'dispatcherId': dispatcherId,
      if (dispatcherName != null) 'dispatcherName': dispatcherName,
      if (address != null) 'address': address,
      if (state != null) 'state': state,
      if (assignedAt != null) 'assignedAt': assignedAt.toIso8601String(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt.toIso8601String(),
    };

    return _apiClient.createOrder(payload);
  }

  Future<Order> updateOrder({
    required String orderId,
    String? state,
    String? dispatcherId,
    String? dispatcherName,
    double? latitude,
    double? longitude,
    String? address,
    DateTime? assignedAt,
    DateTime? deliveredAt,
  }) {
    final payload = <String, dynamic>{
      if (state != null) 'state': state,
      if (dispatcherId != null) 'dispatcherId': dispatcherId,
      if (dispatcherName != null) 'dispatcherName': dispatcherName,
      if (address != null) 'address': address,
      if (assignedAt != null) 'assignedAt': assignedAt.toIso8601String(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt.toIso8601String(),
      if (latitude != null && longitude != null)
        'location': {
          'lat': latitude,
          'lng': longitude,
        },
    };

    return _apiClient.updateOrder(orderId, payload);
  }

  Future<void> deleteOrder(String orderId) {
    return _apiClient.deleteOrder(orderId);
  }
}
