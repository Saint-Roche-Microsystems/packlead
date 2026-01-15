import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/order_item_button.dart';
import 'package:packlead/features/orders/presentation/providers/mock_order_provider.dart';

class OrderBottomSheet extends ConsumerStatefulWidget {
  const OrderBottomSheet({super.key});

  @override
  ConsumerState<OrderBottomSheet> createState() => _OrferBottomSheetState();
}

class _OrferBottomSheetState extends ConsumerState<OrderBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(mockOrdersProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.15,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: orders.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  itemBuilder: (context, index) {
                    return OrderItemButton(
                      order: orders[index],
                      onTap: () {

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Seleccionó orden ORD-${orders[index].id}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: () {
                  /*TODO*/
                },
                icon: Icon(Icons.check_circle_outline),
                label: const Text('Confirmar Entrega'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                ),
              ),

              SizedBox(height: 24),

            ],
          ),
        );
      },
    );
  }
}
