import 'package:packlead/core/models/order.dart';
import 'package:packlead/core/constants/order_state.dart';

class DispatcherHomeState {
  final List<Order> todayOrders;
  final Order? selectedOrder;
  final Order? activeShippedOrder; // Only one at a time
  final bool isUpdatingOrder; // for loading in action button

  const DispatcherHomeState({
    this.todayOrders = const [],
    this.selectedOrder,
    this.activeShippedOrder,
    this.isUpdatingOrder = false,
  });

  // HELPERS

  /// Indica si hay una orden seleccionada
  bool get hasSelection => selectedOrder != null;

  /// Can only select an order if the is NO active shipped order
  bool get canSelectOrders => activeShippedOrder == null;

  // Get current order state if there's a selected order
  OrderState? get selectedOrderState => selectedOrder?.state;

  bool get isSelectedOrderPending =>
      selectedOrder != null && selectedOrder!.state == OrderState.pending;

  bool get isSelectedOrderShipped =>
      selectedOrder != null && selectedOrder!.state == OrderState.shipped;

  List<Order> get pendingOrders =>
      todayOrders.where((o) => o.state != OrderState.delivered).toList();

  List<Order> get deliveredOrders =>
      todayOrders.where((o) => o.state == OrderState.delivered).toList();

  // UTILITIES
  DispatcherHomeState copyWith({
    List<Order>? todayOrders,
    Order? selectedOrder,
    Order? activeShippedOrder,
    bool? isUpdatingOrder,
    bool clearSelectedOrder = false,
    bool clearActiveShippedOrder = false,
  }) {
    return DispatcherHomeState(
      todayOrders: todayOrders ?? this.todayOrders,
      selectedOrder: clearSelectedOrder
          ? null
          : (selectedOrder ?? this.selectedOrder),
      activeShippedOrder: clearActiveShippedOrder
          ? null
          : (activeShippedOrder ?? this.activeShippedOrder),
      isUpdatingOrder: isUpdatingOrder ?? this.isUpdatingOrder,
    );
  }

  @override
  String toString() {
    return 'DispatcherHomeState('
        'todayOrders: ${todayOrders.length}, '
        'selectedOrder: ${selectedOrder?.id}, '
        'activeShippedOrder: ${activeShippedOrder?.id}, '
        'isUpdatingOrder: $isUpdatingOrder'
        ')';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DispatcherHomeState &&
          runtimeType == other.runtimeType &&
          todayOrders == other.todayOrders &&
          selectedOrder == other.selectedOrder &&
          activeShippedOrder == other.activeShippedOrder &&
          isUpdatingOrder == other.isUpdatingOrder;

  @override
  int get hashCode =>
      todayOrders.hashCode ^
      selectedOrder.hashCode ^
      activeShippedOrder.hashCode ^
      isUpdatingOrder.hashCode;
}
