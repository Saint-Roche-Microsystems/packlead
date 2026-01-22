import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/order_item_button.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/order_state_dialog.dart';
import 'package:packlead/features/orders/presentation/providers/orders_provider.dart';

class OrderBottomSheet extends ConsumerStatefulWidget {
  const OrderBottomSheet({super.key});

  @override
  ConsumerState<OrderBottomSheet> createState() => _OrferBottomSheetState();
}

class _OrferBottomSheetState extends ConsumerState<OrderBottomSheet> {
  Order? _selectedOrder;

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(defaultOrdersProvider);

    return ordersAsync.when(
      data: (orders) {
        if (_selectedOrder == null && orders.isNotEmpty) {
          _selectedOrder = orders.first;
        }

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
                            setState(() {
                              _selectedOrder = orders[index];
                            });
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (_selectedOrder != null)
                    ElevatedButton.icon(
                      onPressed: () async {
                        final String? newStatus = await showDialog(
                          context: context,
                          builder: (context) => OrderStateDialog(order: _selectedOrder!),
                        );

                        if (newStatus != null && _selectedOrder != null) {
                          try {
                            await ref.read(ordersRepositoryProvider).updateOrder(
                                  orderId: _selectedOrder!.id,
                                  state: newStatus,
                                );
                            ref.invalidate(defaultOrdersProvider);

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'El estado del pedido ${_selectedOrder!.id} se actualizó a "$newStatus".',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          } catch (error) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('No se pudo actualizar: $error'),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          }
                        }
                      },
                      icon: const Icon(Icons.update),
                      label: const Text('Actualizar Entrega'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                      ),
                    ),

                  const SizedBox(height: 28),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('No se pudieron cargar los pedidos: $error'),
        ),
      ),
    );
  }
}
