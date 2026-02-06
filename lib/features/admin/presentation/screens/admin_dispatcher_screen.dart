import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/constants/dispatcher_state.dart';
import 'package:packlead/features/admin/presentation/screens/dispatcher_add_form_screen.dart';
import 'package:packlead/features/admin/presentation/widgets/dispatcher_item_list.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_provider.dart';

class AdminDispatcherScreen extends ConsumerStatefulWidget {
  const AdminDispatcherScreen({super.key});

  @override
  ConsumerState<AdminDispatcherScreen> createState() => _AdminDispatcherScreenState();
}

class _AdminDispatcherScreenState extends ConsumerState<AdminDispatcherScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                    builder: (context) => const DispatcherAddFormScreen(),
                  ),
                );
              },
              icon: Icon(Icons.add),
              label: const Text('Agregar repartidor'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),

        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Activos'),
            Tab(text: 'Inactivos'),
          ],
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _DispatcherListByState(state: DispatcherState.available),
              _DispatcherListByState(state: DispatcherState.inactive),
            ],
          ),
        ),
      ],
    );
  }
}

class _DispatcherListByState extends ConsumerWidget {
  final DispatcherState state;

  const _DispatcherListByState({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dispatchersAsync = ref.watch(dispatchersByStateProvider(state));

    return dispatchersAsync.when(
      data: (dispatchers) {
        if (dispatchers.isEmpty) {
          return Center(child: Text('No hay repartidores ${state.label}s registrados'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: dispatchers.length,
          itemBuilder: (context, index) {
            return DispatcherItemList(dispatcher: dispatchers[index]);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('No se pudieron cargar los repartidores: $error'),
        ),
      ),
    );
  }
}