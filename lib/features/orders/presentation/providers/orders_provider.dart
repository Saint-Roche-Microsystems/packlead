import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/orders/data/datasources/order_api_datasource.dart';
import 'package:packlead/features/orders/data/datasources/order_datasource.dart';
// ignore: unused_import
import 'package:packlead/features/orders/data/datasources/order_mock_datasource.dart';
import 'package:packlead/features/orders/data/repositories/order_repository.dart';
import 'package:packlead/features/orders/data/repositories/order_respository_imp.dart';
import 'package:packlead/features/orders/models/order_by_dispatcher_params.dart';
import 'package:packlead/services/api/api_config.dart';
import 'package:packlead/services/api/base/base_api_client.dart';
import 'package:packlead/services/api/clients/orders_api_client.dart';

/// *******************
/// CONFIG PROVIDERS
/// *******************

// API service related
final ordersBaseApiClientProvider = Provider<BaseApiClient>((ref) {
  return BaseApiClient(
    baseUrl: ApiConfig.apiBaseUrl,
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
  // Use real API service
  final apiClient = ref.watch(ordersApiClientProvider);
  return OrderApiDataSource(apiClient);

  // Dev only - use mock data (no backend required)
  // return OrderMockDataSource();
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

final orderByIdProvider = FutureProvider.family<Order, String>(
      (ref, orderId) async {
    final repository = ref.watch(orderRepositoryProvider);
    return await repository.getOrderById(orderId);
  },
);

final ordersByDispatcherProvider = FutureProvider.family<List<Order>, OrdersByDispatcherParams>(
      (ref, params) async {
    final repository = ref.watch(orderRepositoryProvider);
    return await repository.getOrdersByDispatcher(params.dispatcherId, params.forDate);
  },
);

final ordersByStateProvider = FutureProvider.family<List<Order>, OrderState>(
      (ref, state) async {
    final repository = ref.watch(orderRepositoryProvider);
    return await repository.getOrdersByState(state);
  },
);

final todayOrdersProvider = FutureProvider<List<Order>>((ref) async {
  final repository = ref.watch(orderRepositoryProvider);
  final today = DateTime.now();

  return await repository.getOrdersByDate(today);
});

final ordersByDateProvider = FutureProvider.family<List<Order>, DateTime>(
      (ref, date) async {
    final repository = ref.watch(orderRepositoryProvider);
    return await repository.getOrdersByDate(date);
  },
);

/// *******************
///   CUD PROVIDERS
/// *******************

final orderMutationProvider = StateNotifierProvider<OrderMutationNotifier, AsyncValue<void>>(
  (ref) => OrderMutationNotifier(ref),
);

class OrderMutationNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  OrderMutationNotifier(this._ref) : super(const AsyncValue.data(null));

  OrderRepository get _repository => _ref.read(orderRepositoryProvider);

  Future<void> createOrder(Order order) async {
    state = const AsyncValue.loading();

    try {
      await _repository.createOrder(order);

      // Invalidate to refresh data
      _ref.invalidate(ordersByStateProvider);

      state = const AsyncValue.data(null);
    } catch(error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateOrder(Order order) async {
    state = const AsyncValue.loading();

    try {
      await _repository.updateOrder(order);

      // Invalidate to refresh data
      _ref.invalidate(ordersProvider);
      _ref.invalidate(orderByIdProvider(order.id));
      _ref.invalidate(ordersByStateProvider);

      state = const AsyncValue.data(null);
    } catch(error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateOrderState({
    required String orderId,
    required OrderState newState,
  }) async {
    state = const AsyncValue.loading();

    try {
      final currentOrder = await _repository.getOrderById(orderId);

      final updatedOrder = currentOrder.copyWith(state: newState);

      await _repository.updateOrder(updatedOrder);

      // Invalidate to refresh data
      _ref.invalidate(ordersProvider);
      _ref.invalidate(orderByIdProvider(orderId));
      _ref.invalidate(ordersByStateProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteOrder(String orderId) async {
    state = const AsyncValue.loading();

    try {
      await _repository.deleteOrder(orderId);

      // Invalidate to refresh data
      _ref.invalidate(ordersProvider);
      _ref.invalidate(orderByIdProvider(orderId));
      _ref.invalidate(ordersByStateProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    _ref.invalidate(ordersByStateProvider);
  }

  // Reset state to default
  void resetState() {
    state = const AsyncValue.data(null);
  }
}