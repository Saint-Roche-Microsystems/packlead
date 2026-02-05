import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/features/admin/presentation/providers/admin_orders_provider.dart';
import 'package:packlead/features/admin/presentation/screens/order_add_form_screen.dart';
import 'package:packlead/features/admin/presentation/widgets/order_item_list.dart';

class AdminOrderScreen extends ConsumerWidget {
  const AdminOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enrichedOrdersAsync = ref.watch(enrichedOrdersProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrderAddFormScreen(),
                  ),
                );
              },
              icon: Icon(Icons.add),
              label: const Text('Agregar pedido'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        Expanded(
          child: enrichedOrdersAsync.when(
            data: (enrichedOrders) {
              if (enrichedOrders.isEmpty) {
                return const Center(child: Text('No hay pedidos disponibles'));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: enrichedOrders.length,
                itemBuilder: (context, index) {
                  return OrderItemList(orderVM: enrichedOrders[index]);
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
          ),
        ),
      ],
    );
  }
}
