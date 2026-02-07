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

  // Marker for destionation location
  static Marker buildDestinationMarker(LatLng location, String? clientName) {
    return Marker(
      markerId: const MarkerId('destination'),
      position: location,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
        title: 'Destino',
        snippet: clientName ?? 'Cliente',
      ),
    );
  }

  /// Marker for the headquarters location
  static Marker buildHqLocationMarker(LatLng location) {
    return Marker(
      markerId: const MarkerId('srmc_hq'),
      position: location,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: const InfoWindow(
        title: 'SRMC - HQ',
        snippet: 'Bodega',
      ),
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
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      rotation: heading ?? 0,
      anchor: const Offset(0.5, 0.5),
    );
  }
}