import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/orders/data/datasources/order_api_datasource.dart';
import 'package:packlead/features/orders/data/datasources/order_datasource.dart';
import 'package:packlead/features/orders/data/repositories/order_repository.dart';
import 'package:packlead/features/orders/data/repositories/order_respository_imp.dart';
import 'package:packlead/services/api/api_config.dart';
import 'package:packlead/services/api/base/base_api_client.dart';
import 'package:packlead/services/api/clients/orders_api_client.dart';

/// *******************
/// CONFIG PROVIDERS
/// *******************

// API service related
final ordersBaseApiClientProvider = Provider<BaseApiClient>((ref) {
  return BaseApiClient(
    baseUrl: ApiConfig.ordersBaseUrl,
    connectTimeout: ApiConfig.connectTimeout,
    receiveTimeout: ApiConfig.receiveTimeout,
    headers: ApiConfig.defaultHeaders,
  );
});

final ordersApiClientProvider = Provider<OrdersApiClient>((ref) {
  final baseClient = ref.watch(ordersBaseApiClientProvider);
  return OrdersApiClient(baseClient);
});


// Datasource related
final orderDataSourceProvider = Provider<OrderDataSource>((ref) {
  // Dev ONY - use mock data
  //return OrderMockDataSource();

  // Use real API service
  final apiClient = ref.watch(ordersApiClientProvider);
  return OrderApiDataSource(apiClient);
});

// Repository related
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dataSource = ref.watch(orderDataSourceProvider);
  return OrderRepositoryImp(dataSource);
});

/// *******************
///   DATA PROVIDERS -> GET
/// *******************

final ordersProvider = FutureProvider<List<Order>>((ref) async {
  final repository = ref.watch(orderRepositoryProvider);
  return await repository.getAllOrders();
});

final ordersByDispatcherProvider = FutureProvider.family<List<Order>, String>(
      (ref, dispatcherId) async {
    final repository = ref.watch(orderRepositoryProvider);
    return await repository.getOrdersByDispatcher(dispatcherId);
  },
);

/// *******************
///   CUD PROVIDERS
/// *******************

final orderMutationProvider = Provider<OrderMutation>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return OrderMutation(repository, ref);
});


class OrderMutation {
  final OrderRepository _repository;
  final Ref _ref;

  OrderMutation(this._repository, this._ref);

  Future<Order> createOrder(Order order) async {
    final createdOrder = await _repository.createOrder(order);

    // Invalidate to refresh data
    _ref.invalidate(ordersProvider);

    return createdOrder;
  }

  Future<Order> updateOrder(Order order) async {
    final updatedOrder = await _repository.updateOrder(order);

    // Invalidate to refresh data
    _ref.invalidate(ordersProvider);

    return updatedOrder;
  }

  Future<void> deleteOrder(String orderId) async {
    await _repository.deleteOrder(orderId);

    // Invalidate to refresh data
    _ref.invalidate(ordersProvider);
  }
}