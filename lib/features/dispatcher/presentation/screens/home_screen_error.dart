import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/themes/index.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_home_provider.dart';

class HomeScreenError extends ConsumerWidget {
  final String errorMsg;
  final String dispatcherId;
  const HomeScreenError({
    super.key,
    required this.errorMsg,
    required this.dispatcherId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: SaintColors.error,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar órdenes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            errorMsg,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(dispatcherHomeProvider.notifier).loadTodayOrders(dispatcherId);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
