import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/features/dispatcher/presentation/state/dispatcher_home_state.dart';
import 'package:packlead/features/orders/data/repositories/order_repository.dart';
import 'package:packlead/features/orders/models/order_by_dispatcher_params.dart';
import 'package:packlead/features/orders/presentation/providers/orders_provider.dart';


final dispatcherHomeProvider = StateNotifierProvider.autoDispose<
    DispatcherHomeNotifier,
    AsyncValue<DispatcherHomeState>
>((ref) {
  return DispatcherHomeNotifier(ref);
});

class DispatcherHomeNotifier extends StateNotifier<AsyncValue<DispatcherHomeState>> {
  final Ref _ref;

  DispatcherHomeNotifier(this._ref)
      : super(const AsyncValue.data(DispatcherHomeState()));

  OrderRepository get _orderRepository => _ref.read(orderRepositoryProvider);

  // Get orders for today and detect active shipped orders
  Future<void> loadTodayOrders(String dispatcherId) async {
    state = const AsyncValue.loading();

    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Use orders repository to obtain the orders from the backend
      final orders = await _orderRepository.getOrdersByDispatcher(
        dispatcherId,
        today,
      );

      // Search for active shipped order (should be only one)
      final shippedOrder = orders.firstWhere(
            (order) => order.state == OrderState.shipped,
        orElse: () => orders.first,
      );

      final activeShipped = shippedOrder.state == OrderState.shipped
          ? shippedOrder
          : null;

      // Build state when loading
      state = AsyncValue.data(
        DispatcherHomeState(
          todayOrders: orders,
          activeShippedOrder: activeShipped,
          selectedOrder: activeShipped,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Recarga las órdenes manteniendo el estado actual
  Future<void> refreshOrders(String dispatcherId) async {
    state.whenData((currentState) async {
      try {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        final orders = await _orderRepository.getOrdersByDispatcher(
          dispatcherId,
          today,
        );

        // Buscar shipped activa
        final shippedOrder = orders.firstWhere(
              (order) => order.state == OrderState.shipped,
          orElse: () => orders.first,
        );

        final activeShipped = shippedOrder.state == OrderState.shipped
            ? shippedOrder
            : null;

        state = AsyncValue.data(
          currentState.copyWith(
            todayOrders: orders,
            activeShippedOrder: activeShipped,
          ),
        );
      } catch (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      }
    });
  }

  // Order selection behaviour
  void selectOrder(Order order) {
    state.whenData((currentState) {
      // Do not allow the selection if there is an active shipping order
      // and its is not the same as the one we want to select
      if (currentState.activeShippedOrder != null &&
          currentState.activeShippedOrder!.id != order.id) {
        return;
      }

      // Delivered orders cannot be selected
      if (order.state == OrderState.delivered) {
        return;
      }

      state = AsyncValue.data(
        currentState.copyWith(selectedOrder: order),
      );
    });
  }

  /// Deselect the currently selected order
  void clearSelection() {
    state.whenData((currentState) {
      state = AsyncValue.data(
        currentState.copyWith(clearSelectedOrder: true),
      );
    });
  }

  // Change from pending ---> shipped
  Future<void> startDelivery(Order order) async {
    state.whenData((currentState) async {
      // Must be pending
      if (order.state != OrderState.pending) {
        return;
      }

      // Init process of updating an order state
      state = AsyncValue.data(
        currentState.copyWith(isUpdatingOrder: true),
      );

      try {
        // Use the repository to update the order state in the backend
        final updatedOrder = order.copyWith(state: OrderState.shipped);
        await _orderRepository.updateOrder(updatedOrder);

        // Invalidate providers related to the UI
        _ref.invalidate(ordersByDispatcherProvider(
          OrdersByDispatcherParams(
            dispatcherId: order.dispatcherId!,
            forDate: order.deliveryDate,
          ),
        ));

        // Update local state for inmediate UI feedback
        final updatedOrders = currentState.todayOrders.map((o) {
          return o.id == order.id ? updatedOrder : o;
        }).toList();

        state = AsyncValue.data(
          DispatcherHomeState(
            todayOrders: updatedOrders,
            selectedOrder: updatedOrder,
            activeShippedOrder: updatedOrder,
            isUpdatingOrder: false,
          ),
        );
      } catch (error, stackTrace) {
        state = AsyncValue.data(
          currentState.copyWith(isUpdatingOrder: false),
        );

        state = AsyncValue.error(error, stackTrace);
      }
    });
  }

  // Change from shipped ---> delivered
  Future<void> completeDelivery(Order order) async {
    state.whenData((currentState) async {
      // Must be shipped
      if (order.state != OrderState.shipped) {
        return;
      }

      // Init process of updating an order state
      state = AsyncValue.data(
        currentState.copyWith(isUpdatingOrder: true),
      );

      try {
        // Use the repository to update the order state in the backend
        final updatedOrder = order.copyWith(state: OrderState.delivered);
        await _orderRepository.updateOrder(updatedOrder);

        // Invalidate providers related to the UI
        _ref.invalidate(ordersByDispatcherProvider(
          OrdersByDispatcherParams(
            dispatcherId: order.dispatcherId!,
            forDate: order.deliveryDate,
          ),
        ));

        // Update local state for inmediate UI feedback
        final updatedOrders = currentState.todayOrders.map((o) {
          return o.id == order.id ? updatedOrder : o;
        }).toList();

        state = AsyncValue.data(
          DispatcherHomeState(
            todayOrders: updatedOrders,
            selectedOrder: null,
            activeShippedOrder: null,
            isUpdatingOrder: false,
          ),
        );
      } catch (error, stackTrace) {
        state = AsyncValue.data(
          currentState.copyWith(isUpdatingOrder: false),
        );

        state = AsyncValue.error(error, stackTrace);
      }
    });
  }

  /// Reset state to default values
  void reset() {
    state = const AsyncValue.data(DispatcherHomeState());
  }
}