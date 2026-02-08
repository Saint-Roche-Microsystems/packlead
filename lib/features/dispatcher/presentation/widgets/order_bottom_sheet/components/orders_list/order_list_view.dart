import 'package:flutter/material.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/dispatcher_order_list_item.dart';

class OrderListView extends StatelessWidget {
  final List<Order> orders;
  final ScrollController scrollController;
  final String? selectedOrderId;
  final bool Function(Order) isOrderSelectable;
  final void Function(Order) onOrderTap;

  const OrderListView({
    super.key,
    required this.orders,
    required this.scrollController,
    this.selectedOrderId,
    required this.isOrderSelectable,
    required this.onOrderTap
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: orders.length,
      padding: const EdgeInsets.only(bottom: 8),
      itemBuilder: (context, index) {
        final order = orders[index];

        return DispatcherOrderListItem(
          order: order,
          isSelected: selectedOrderId == order.id,
          isEnabled: isOrderSelectable(order),
          onTap: () => onOrderTap(order),
        );
      },
    );
  }
}
