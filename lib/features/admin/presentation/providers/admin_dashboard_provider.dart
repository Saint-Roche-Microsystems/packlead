import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/config/service_mode.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/dispatcher_location.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/admin/presentation/providers/live_tracking_provider.dart';
import 'package:packlead/features/orders/presentation/providers/orders_provider.dart';

/// Dashboard State
class AdminDashboardState {
  final List<Order> todayOrders;
  final List<DispatcherLocation> onlineDispatchers;

  // Demo-only random KPI overrides used with MOCK data
  final int? _randomTotalOrders;
  final int? _randomPendingOrders;
  final int? _randomShippedOrders;
  final int? _randomDeliveredOrders;

  AdminDashboardState({
    required this.todayOrders,
    required this.onlineDispatchers,
  })  : _randomTotalOrders = null,
        _randomPendingOrders = null,
        _randomShippedOrders = null,
        _randomDeliveredOrders = null;

  AdminDashboardState._random({
    required this.onlineDispatchers,
    required int totalOrders,
    required int pendingOrders,
    required int shippedOrders,
    required int deliveredOrders,
  })  : todayOrders = const [],
        _randomTotalOrders = totalOrders,
        _randomPendingOrders = pendingOrders,
        _randomShippedOrders = shippedOrders,
        _randomDeliveredOrders = deliveredOrders;

  factory AdminDashboardState.randomMock(List<DispatcherLocation> onlineDispatchers) {
    final random = Random();
    final total = 6 + random.nextInt(25);

    var remaining = total - 3;
    final deliveredExtra = random.nextInt(remaining + 1);
    remaining -= deliveredExtra;
    final shippedExtra = random.nextInt(remaining + 1);
    remaining -= shippedExtra;
    final pendingExtra = remaining;

    return AdminDashboardState._random(
      onlineDispatchers: onlineDispatchers,
      totalOrders: total,
      pendingOrders: 5 + pendingExtra,
      shippedOrders: 5 + shippedExtra,
      deliveredOrders: 5 + deliveredExtra,
    );
  }

  // KPIs Helpers
  int get totalOrders => _randomTotalOrders ?? todayOrders.length;
  int get totalOnlineDispatchers => onlineDispatchers.length;

  int get pendingOrders => _randomPendingOrders ?? todayOrders
      .where((order) => order.state == OrderState.pending)
      .length;

  int get shippedOrders => _randomShippedOrders ?? todayOrders
      .where((order) => order.state == OrderState.shipped)
      .length;

  int get deliveredOrders => _randomDeliveredOrders ?? todayOrders
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
      if (AppServiceMode.isMock) {
        final onlineDispatchers = await _ref.read(liveTrackingProvider.future);
        state = AsyncValue.data(AdminDashboardState.randomMock(onlineDispatchers));
        return;
      }

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