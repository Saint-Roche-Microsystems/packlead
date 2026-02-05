import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/features/admin/presentation/providers/admin_orders_provider.dart';
import 'package:packlead/features/admin/presentation/screens/order_add_form_screen.dart';
import 'package:packlead/features/admin/presentation/widgets/order_item_list.dart';

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

        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pendientes'),
            Tab(text: 'En ruta'),
            Tab(text: 'Entregadas'),
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
    );
  }
}
