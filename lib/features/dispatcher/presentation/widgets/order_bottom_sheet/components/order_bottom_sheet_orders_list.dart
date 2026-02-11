import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/widgets/empty_screen.dart';
import 'package:packlead/core/widgets/error_screen.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_home_provider.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/order_bottom_sheet/components/order_list_view.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/order_bottom_sheet/utils/order_list_helpers.dart';

class OrderBottomSheetOrdersList extends ConsumerWidget {

  const OrderBottomSheetOrdersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeStateAsync = ref.watch(dispatcherHomeProvider);

    return homeStateAsync.when(
      data: (state) {
        if (state.todayOrders.isEmpty) {
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
             child: EmptyScreen(
                 icon: Icons.receipt_long,
                 message: 'No tienes órdenes para hoy'
             ),
          );
        }

        // Sort: pending/shipped UP, delivered DOWN
        final sortedOrders = sortOrders(state.todayOrders);

        return OrderListView(
          orders: sortedOrders,
          selectedOrderId: state.selectedOrder?.id,
          isOrderSelectable:(order) => isOrderSelectable(order, state),
          onOrderTap: (order) {
            // Deselect if previously selected
            if (state.selectedOrder?.id == order.id) {
              ref.read(dispatcherHomeProvider.notifier).clearSelection();
              return;
            }

            // Select the order
            ref.read(dispatcherHomeProvider.notifier).selectOrder(order);
          },
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => ErrorScreen(
        title: 'Ocurrió un error al cargar tus órdenes',
        message: error.toString(),
        onRetry: () => ref.invalidate(dispatcherHomeProvider),
      ),
    );
  }
}
