import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/features/admin/presentation/providers/live_tracking_provider.dart';
import 'package:packlead/features/admin/presentation/screens/multi_point_realtime_map.dart';

class AdminTrackingScreen extends ConsumerWidget {
  const AdminTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveLocationsAsync = ref.watch(liveTrackingProvider);

    return liveLocationsAsync.when(
      data: (locations) {
        if (locations.isEmpty) {
          return const Center(
            child: Text('No hay repartidores activos'),
          );
        }
       return MultiPointRealtimeMap(
          locations: locations,
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}