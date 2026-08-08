import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/models/dispatcher_location.dart';
import 'package:packlead/features/admin/viewmodels/admin_tracking_view_model.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_provider.dart';
import 'package:packlead/services/firebase/firebase_providers.dart';

/// Provider that listens to all dispatchers locations in real-time
final liveTrackingProvider = StreamProvider<List<DispatcherLocation>>((ref) {
  final locationService = ref.watch(dispatcherLocationServiceProvider);

  // Reactive Stream from RTDB
  return locationService.watchAllLocations();
});

/// Joins the live RTDB locations (keyed by Firebase UID) to the backend
/// `GET /dispatchers` results via `Dispatcher.firebaseUid`
final enrichedLiveLocationsProvider = Provider<AsyncValue<List<AdminTrackingViewModel>>>((ref) {
  final locationsAsync = ref.watch(liveTrackingProvider);
  final dispatchersAsync = ref.watch(dispatchersProvider);

  if (locationsAsync.isLoading || dispatchersAsync.isLoading) {
    return const AsyncValue.loading();
  }

  if (locationsAsync.hasError) {
    return AsyncValue.error(locationsAsync.error!, locationsAsync.stackTrace!);
  }

  if (dispatchersAsync.hasError) {
    return AsyncValue.error(dispatchersAsync.error!, dispatchersAsync.stackTrace!);
  }

  final locations = locationsAsync.value!;
  final dispatchers = dispatchersAsync.value!;

  final dispatcherByFirebaseUid = {
    for (final dispatcher in dispatchers)
      if (dispatcher.firebaseUid != null) dispatcher.firebaseUid!: dispatcher,
  };

  final enriched = locations.map((location) {
    final dispatcher = dispatcherByFirebaseUid[location.dispatcherId];
    return AdminTrackingViewModel.fromLocation(location, dispatcher);
  }).toList();

  return AsyncValue.data(enriched);
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