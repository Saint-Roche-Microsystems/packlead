import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/widgets/error_screen.dart';
import 'package:packlead/features/admin/presentation/providers/admin_orders_provider.dart';
import 'package:packlead/features/admin/presentation/screens/forms/create_order_form.dart';
import 'package:packlead/features/admin/presentation/widgets/order_item_list.dart';
import 'package:packlead/features/orders/presentation/providers/orders_provider.dart';

class AdminOrderScreen extends ConsumerStatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  ConsumerState<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends ConsumerState<AdminOrderScreen>
    with SingleTickerProviderStateMixin {
    late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
                    builder: (context) => const CreateOrderForm(),
                  ),
                );
              },
              icon: Icon(Icons.add),
              label: const Text('Crear pedido'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),

        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pendientes'),
            Tab(text: 'En ruta'),
            Tab(text: 'Entregados'),
          ],
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _OrderListByState(state: OrderState.pending),
              _OrderListByState(state: OrderState.shipped),
              _OrderListByState(state: OrderState.delivered),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrderListByState extends ConsumerWidget {
  final OrderState state;

  const _OrderListByState({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enrichedOrdersAsync = ref.watch(enrichedOrdersByStateProvider(state));

    return enrichedOrdersAsync.when(
      data: (enrichedOrders) {
        if (enrichedOrders.isEmpty) {
          return Center(child: Text('No hay pedidos ${state.label} registrados'));
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(orderMutationProvider.notifier).refresh(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: enrichedOrders.length,
            itemBuilder: (context, index) {
              return OrderItemList(orderVM: enrichedOrders[index]);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorScreen(
          title: 'No se pudieron cargar los pedidos',
          message: error.toString(),
          onRetry: () => ref.read(orderMutationProvider.notifier).refresh(),
      ),
    );
  }
}
