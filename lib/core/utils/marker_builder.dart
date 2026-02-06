import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:packlead/core/models/location.dart';

class MarkerBuilder {
  MarkerBuilder._();

  /// Marker for a selected location
  static Marker buildSelectedLocationMarker(LatLng location) {
    return Marker(
      markerId: const MarkerId('selected'),
      position: location,
      draggable: true,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
  }

  /// Marker for the current position with direction
  static Marker buildCurrentPositionMarker(
      Location location, {
        double? heading,
      }) {
    return Marker(
      markerId: const MarkerId('current'),
      position: location.toLatLng(),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      rotation: heading ?? 0,
      anchor: const Offset(0.5, 0.5),
    );
  }
}