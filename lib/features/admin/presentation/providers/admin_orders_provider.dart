import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/admin/viewmodels/admin_orders_view_model.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_provider.dart';
import 'package:packlead/features/orders/presentation/providers/orders_provider2.dart';

// Provider for list view & dtails for admin orders Screen
final enrichedOrdersProvider = FutureProvider<List<AdminOrdersViewModel>>((ref) async {
  // Watch base domain providers
  final ordersAsync = ref.watch(ordersProvider);
  final dispatchersAsync = ref.watch(dispatchersProvider);

  // Retreive data
  final orders = ordersAsync.requireValue;
  final dispatchers = dispatchersAsync.requireValue;

  // Create a map for dispatchers ----> easy access
  final dispatcherMap = {
    for (var d in dispatchers) d.id: d
  };

  // Create AdminOrdersViewModel (as list)
  return orders.map((Order order) {
    // Obtain the dispatcher for each order
    final dispatcher = order.dispatcherId != null
        ? dispatcherMap[order.dispatcherId]
        : null;

    return AdminOrdersViewModel.fromOrder(order, dispatcher);
  }).toList();
});

// Provider to create Orders
final adminOrderFormProvider = StateNotifierProvider<AdminOrderFormNotifier, AsyncValue<void>>(
  (ref) => AdminOrderFormNotifier(ref),
);

class AdminOrderFormNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  AdminOrderFormNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> createOrder(Order order) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(orderRepositoryProvider);
      await repository.createOrder(order);

      ref.invalidate(ordersProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}