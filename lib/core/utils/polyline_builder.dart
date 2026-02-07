import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:packlead/core/models/location.dart';


class PolylineBuilder {
  PolylineBuilder._();

  /// Creates a route polyline from a list of Location points
  static Polyline buildRoutePolyline(
      List<Location> routePoints, {
        String polylineId = 'route',
        Color color = Colors.blue,
        int width = 5,
      }) {
    if (routePoints.isEmpty) {
      return Polyline(
        polylineId: PolylineId(polylineId),
        points: const [],
      );
    }

    // Convert Location to LatLng to create polyline points
    final points = routePoints.map((loc) => loc.toLatLng()).toList();

    return Polyline(
      polylineId: PolylineId(polylineId),
      points: points,
      color: color,
      width: width,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
      geodesic: true,
    );
  }

  /// Wrapper that returns a Set of polylines for a route
  static Set<Polyline> buildRoutePolylineSet(
      List<Location> routePoints, {
        String polylineId = 'route',
        Color color = Colors.blue,
        int width = 5,
      }) {
    if (routePoints.isEmpty) {
      return {};
    }

    return {
      buildRoutePolyline(
        routePoints,
        polylineId: polylineId,
        color: color,
        width: width,
      ),
    };
  }
}