import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:packlead/features/dispatcher/presentation/widgets/order_bottom_sheet/components/order_bottom_sheet_action_button.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/order_bottom_sheet/components/order_bottom_sheet_header.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/order_bottom_sheet/components/order_bottom_sheet_orders_list.dart';

class OrderBottomSheet extends ConsumerWidget {
  final String dispatcherId;

  const OrderBottomSheet({super.key, required this.dispatcherId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.32,
      maxChildSize: 0.85,
      snap: true,
      snapSizes: const [0.4, 0.85],
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Column(
            children: [

            SingleChildScrollView(
              controller: scrollController,
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  // HANDLE
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  OrderBottomSheetHeader(dispatcherId: dispatcherId),

                  const Divider(height: 1),
                ],
              ),
            ),

              // Orders List
              Expanded(
                child: OrderBottomSheetOrdersList(),
              ),

              const Divider(height: 1),

              // Action Button
              OrderBottomSheetActionButton(),
            ],
          ),
        );
      },
    );
  }
}
