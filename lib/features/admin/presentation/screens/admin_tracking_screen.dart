import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/widgets/empty_screen.dart';
import 'package:packlead/core/widgets/error_screen.dart';
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
          return const EmptyScreen(
            icon: Icons.person_off_outlined,
            message: 'No hay repartidores activos',
          );
        }
       return MultiPointRealtimeMap(
          locations: locations,
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, _) => ErrorScreen(
          message: error.toString(),
          onRetry: () => ref.invalidate(liveTrackingProvider),
      ),
    );
  }
}