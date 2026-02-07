import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_home_provider.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/order_bottom_sheet.dart';

import 'package:packlead/navigation/routers/auth_router.dart';
import 'package:packlead/services/mock_services/mock_auth_service.dart';

class DispatcherHomeScreen extends ConsumerStatefulWidget {
  final String dispatcherId;

  const DispatcherHomeScreen({super.key, required this.dispatcherId});

  @override
  ConsumerState<DispatcherHomeScreen> createState() => _DispatcherHomeScreenState();
}

class _DispatcherHomeScreenState extends ConsumerState<DispatcherHomeScreen> {

  @override
  void initState() {
    super.initState();

    // fetch today's orders when screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dispatcherHomeProvider.notifier).loadTodayOrders(widget.dispatcherId);
    });
  }

  @override
  void dispose() {
    ref.read(dispatcherHomeProvider.notifier).reset();
    super.dispose();
  }

  void _logout(BuildContext context) {
    MockAuthService.logout();
    Navigator.pushReplacementNamed(context, AuthRouter.login);
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(dispatcherHomeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Packlead'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Salir',
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: homeState.when(
        data: (state) => _buildContent(context, state),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _buildError(error.toString()),
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar órdenes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(dispatcherHomeProvider.notifier).loadTodayOrders(widget.dispatcherId);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, dynamic state) {
    return Stack(
      children: [
        // MAP

        // BOTTOM SHEET
        const OrderBottomSheet(),
      ],
    );
  }
}