import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/features/admin/viewmodels/admin_orders_view_model.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_provider.dart';
import 'package:packlead/features/orders/presentation/providers/orders_provider.dart';

// Provider for list view & dtails for admin orders Screen
final enrichedOrdersByStateProvider = FutureProvider.family<List<AdminOrdersViewModel>, OrderState>((ref, state) async {
  // Await both base domain providers to show corresponding data
  final orders = await ref.watch(ordersByStateProvider(state).future);
  final dispatchers = await ref.watch(dispatchersProvider.future);

  // Create a map for dispatchers ----> easy access
  final dispatcherMap = {
    for (var dispatcher in dispatchers) dispatcher.id: dispatcher
  };

  // Create AdminOrdersViewModel (as list)
  return orders.map((order) {
    // Obtain the dispatcher for each order
    final dispatcher = order.dispatcherId != null
    ? dispatcherMap[order.dispatcherId]
        : null;

    return AdminOrdersViewModel.fromOrder(order, dispatcher);
  }).toList();
});