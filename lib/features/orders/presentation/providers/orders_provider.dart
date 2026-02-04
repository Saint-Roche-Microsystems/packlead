import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/orders/data/orders_repository.dart';

class OrdersQuery {
  const OrdersQuery({
    this.state,
    this.dispatcherId,
    this.zone,
    this.limit,
  });

  final String? state;
  final String? dispatcherId;
  final String? zone;
  final int? limit;
}

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepository();
});

final ordersProvider = FutureProvider.family<List<Order>, OrdersQuery>((ref, query) {
  final repository = ref.watch(ordersRepositoryProvider);

  return repository.fetchOrders(
    state: query.state,
    dispatcherId: query.dispatcherId,
    zone: query.zone,
    limit: query.limit,
  );
});

final defaultOrdersProvider = FutureProvider<List<Order>>((ref) {
  return ref.watch(ordersRepositoryProvider).fetchOrders();
});

final orderStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final orders = await ref.watch(defaultOrdersProvider.future);
  final stats = <String, int>{};

  for (final order in orders) {
    stats.update(order.state.name, (value) => value + 1, ifAbsent: () => 1);
  }

  return stats;
});
