import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/models/dispatcher_location.dart';
import 'package:packlead/services/firebase/firebase_providers.dart';

/// Provider that listens to all dispatchers locations in real-time
final liveTrackingProvider = StreamProvider<List<DispatcherLocation>>((ref) {
  final locationService = ref.watch(dispatcherLocationServiceProvider);

  // Reactive Stream from RTDB
  return locationService.watchAllLocations();
});

/// Provider to only get available dispatchers
final onlineDispatchersProvider = Provider<List<DispatcherLocation>>((ref) {
  final locationsAsync = ref.watch(liveTrackingProvider);

  return locationsAsync.when(
    data: (locations) => locations,
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Provider to count online dispatchers
final onlineDispatchersCountProvider = Provider<int>((ref) {
  return ref.watch(onlineDispatchersProvider).length;
});