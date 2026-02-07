import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/models/location.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/core/utils/map_utils.dart';

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
  return _getHQOrigin();
});

/// Hardcoded origin location.
Location _getHQOrigin() {
  return Location(
    lat: -0.218874,
    lng: -78.521186,
  );
}