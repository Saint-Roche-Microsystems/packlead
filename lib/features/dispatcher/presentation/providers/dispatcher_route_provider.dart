import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/constants/srmc_hq.dart';
import 'package:packlead/core/models/location.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/core/utils/map_utils.dart';
import 'package:packlead/services/location/location_tracking_service.dart';

/// Hardcoded origin location.
Location _getHQOrigin() {
  return SRMCHQ;
}

final routeProvider = FutureProvider.family<List<Location>, Order>(
      (ref, order) async {
    final origin = _getHQOrigin();

    final route = await MapUtils.getRoute(
      origin: origin,
      destination: order.location,
    );

    return route;
  },
);

final dispatcherCurrentLocationProvider = StateProvider<Location?>((ref) {
  // Initially set to NULL until we get the actual location from the device's GPS.
  return null;
});

final locationTrackingServiceProvider = Provider.autoDispose<LocationTrackingService>((ref) {
  // The service has implemented a lifecycle
  // onLocationUpdate only calls every 5 seconds and if the distance difference
  // is about 10 meters. ONLY when this conditions are met, the location is updated
  // for UI usage and to send it to the backend for real-time tracking.
  final service = LocationTrackingService(
    onLocationUpdate: (location) {
      // Update current dispatcher provider with new location
      ref.read(dispatcherCurrentLocationProvider.notifier).state = location;

      // await _sendLocationToBackend(location);
    },
    onError: (error) {
      debugPrint('Error de ubicación: $error');
    },
  );

  // Refresh when the provider is disposed (log out or app closed)
  ref.onDispose(() {
    service.dispose();
  });

  ref.keepAlive();

  return service;
});

// TODO: Send location to backend
// Future<void> _sendLocationToBackend(Location location) async {}