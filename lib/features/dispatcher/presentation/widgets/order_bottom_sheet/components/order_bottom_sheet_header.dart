import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_home_provider.dart';

class OrderBottomSheetHeader extends ConsumerWidget {
  final String dispatcherId;

  const OrderBottomSheetHeader({super.key, required this.dispatcherId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeStateAsync = ref.watch(dispatcherHomeProvider);

    return homeStateAsync.when(
      data: (state) {
        final pendingCount = state.pendingOrders.length;
        final deliveredCount = state.deliveredOrders.length;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Título
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Órdenes de Hoy',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$pendingCount pendientes • $deliveredCount entregadas',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  ref.read(dispatcherHomeProvider.notifier)
                      .loadTodayOrders(dispatcherId);
                },
                tooltip: 'Actualizar',
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Órdenes de Hoy',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      error: (_, __) => const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Órdenes de Hoy',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
