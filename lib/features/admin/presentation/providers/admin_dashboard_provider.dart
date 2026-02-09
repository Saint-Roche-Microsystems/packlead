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

/// Dashboard Notifier
class AdminDashboardNotifier extends StateNotifier<AsyncValue<AdminDashboardState>> {
  final Ref _ref;

  AdminDashboardNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadDashboard();

    // Listen actively for both providers
    _ref.listen(todayOrdersProvider, (previous, next) {
      _loadDashboard();
    });

    _ref.listen(liveTrackingProvider, (previous, next) {
      _loadDashboard();
    });
  }

  Future<void> _loadDashboard() async {
    state = const AsyncValue.loading();

    try {
      // Load orders & dispatchers providers at the same time
      final results = await Future.wait([
        _ref.read(todayOrdersProvider.future),
        _ref.read(liveTrackingProvider.future),
      ]);

      final todayOrders = results[0] as List<Order>;
      final onlineDispatchers = results[1] as List<DispatcherLocation>;

      state = AsyncValue.data(
        AdminDashboardState(
          todayOrders: todayOrders,
          onlineDispatchers: onlineDispatchers,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Refresh dashboard data
  Future<void> refresh() async {
    _ref.invalidate(todayOrdersProvider);
    _ref.invalidate(liveTrackingProvider);

    await _loadDashboard();
  }
}

/// Dashboard provider
final adminDashboardProvider = StateNotifierProvider<
    AdminDashboardNotifier, AsyncValue<AdminDashboardState>
>((ref) {
  return AdminDashboardNotifier(ref);
});