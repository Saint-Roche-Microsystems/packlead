import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/dispatcher/presentation/state/dispatcher_home_state.dart';

/// Sort orders by: pending/shipped UP, delivered DOWN
List<Order> sortOrders(List<Order> orders) {
  final pending = <Order>[];
  final shipped = <Order>[];
  final delivered = <Order>[];

  for (final order in orders) {
    switch (order.state) {
      case OrderState.pending:
        pending.add(order);
        break;
      case OrderState.shipped:
        shipped.add(order);
        break;
      case OrderState.delivered:
        delivered.add(order);
        break;
    }
  }

  return [...shipped, ...pending, ...delivered];
}

/// Check if an order is selectable based on the current state
bool isOrderSelectable(Order order, DispatcherHomeState state) {
  // Delivered orders NEVER are selectable
  if (order.state == OrderState.delivered) {
    return false;
  }

  // If not active shipped order, all pending are selectable
  if (state.activeShippedOrder == null) {
    return true;
  }

  // If there is ONE active shipped order, ONLY that one is  selectable
  return order.id == state.activeShippedOrder!.id;
}