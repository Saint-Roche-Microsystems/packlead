import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_home_provider.dart';
import 'package:packlead/features/dispatcher/presentation/state/dispatcher_home_state.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/dispatcher_order_list_item.dart';

class OrderBottomSheetOrdersList extends ConsumerWidget {
  final ScrollController scrollController;

  const OrderBottomSheetOrdersList({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeStateAsync = ref.watch(dispatcherHomeProvider);

    return homeStateAsync.when(
      data: (state) {
        if (state.todayOrders.isEmpty) {
          return _buildEmptyState();
        }

        // Sort: pending/shipped UP, delivered DOWN
        final sortedOrders = _sortOrders(state.todayOrders);

        return ListView.builder(
          controller: scrollController,
          itemCount: sortedOrders.length,
          padding: const EdgeInsets.only(bottom: 8),
          itemBuilder: (context, index) {
            final order = sortedOrders[index];
            final isSelected = state.selectedOrder?.id == order.id;
            final isEnabled = _isOrderSelectable(order, state);

            return DispatcherOrderListItem(
              order: order,
              isSelected: isSelected,
              isEnabled: isEnabled,
              onTap: () => _handleOrderTap(context, ref, order, state),
            );
          },
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => _buildErrorState(error),
    );
  }

  /// Estado vacío
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay órdenes para hoy',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Estado de error
  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar órdenes',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }



  // ========================================
  // HELPERS
  // ========================================

  /// Ordena las órdenes: pending/shipped arriba, delivered abajo
  List<Order> _sortOrders(List<Order> orders) {
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

    // Shipped primero (si existe), luego pending, finalmente delivered
    return [...shipped, ...pending, ...delivered];
  }

  // ========================================
  // HANDLERS DE EVENTOS
  // ========================================

  /// Maneja el tap en un item de orden
  void _handleOrderTap(
      BuildContext context,
      WidgetRef ref,
      Order order,
      DispatcherHomeState state,
      ) {
    // Si la orden ya está seleccionada, deseleccionar
    if (state.selectedOrder?.id == order.id) {
      ref.read(dispatcherHomeProvider.notifier).clearSelection();
      return;
    }

    // Seleccionar la orden
    ref.read(dispatcherHomeProvider.notifier).selectOrder(order);
  }

  /// Determina si una orden es seleccionable
  bool _isOrderSelectable(Order order, DispatcherHomeState state) {
    // Las órdenes delivered nunca son seleccionables
    if (order.state == OrderState.delivered) {
      return false;
    }

    // Si no hay shipped activa, todas las pending son seleccionables
    if (state.activeShippedOrder == null) {
      return true;
    }

    // Si hay shipped activa, solo esa es seleccionable
    return order.id == state.activeShippedOrder!.id;
  }
}
