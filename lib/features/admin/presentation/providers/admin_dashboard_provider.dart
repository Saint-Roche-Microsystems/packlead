import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/dispatcher_location.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/admin/presentation/providers/live_tracking_provider.dart';
import 'package:packlead/features/orders/presentation/providers/orders_provider.dart';

/// Dashboard State
class AdminDashboardState {
  final List<Order> todayOrders;
  final List<DispatcherLocation> onlineDispatchers;

  AdminDashboardState({
    required this.todayOrders,
    required this.onlineDispatchers,
  });

  // KPIs Helpers
  int get totalOrders => todayOrders.length;
  int get totalOnlineDispatchers => onlineDispatchers.length;

  int get pendingOrders => todayOrders
      .where((order) => order.state == OrderState.pending)
      .length;

  int get shippedOrders => todayOrders
      .where((order) => order.state == OrderState.shipped)
      .length;

  int get deliveredOrders => todayOrders
      .where((order) => order.state == OrderState.delivered)
      .length;
}

/// Dashboard provider
final adminDashboardProvider = Provider<AsyncValue<AdminDashboardState>>((ref) {
  final todayOrdersAsync = ref.watch(todayOrdersProvider);
  final onlineDispatchersAsync = ref.watch(liveTrackingProvider);

  // Combine both AsyncValues
  return todayOrdersAsync.whenData((orders) {
    return onlineDispatchersAsync.whenData((dispatchers) {
      return AdminDashboardState(
        todayOrders: orders,
        onlineDispatchers: dispatchers,
      );
    }).when(
      data: (state) => AsyncValue.data(state),
      loading: () => const AsyncValue.loading(),
      error: (error, stack) => AsyncValue.error(error, stack),
    );
  }).when(
    data: (value) => value as AsyncValue<AdminDashboardState>,
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});