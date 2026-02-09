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

  /// Decode a polyline string from Google Maps Directions API into a list of Location objects
  static List<Location> decodePolyline(String encoded) {
    List<Location> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(Location(
        lat: lat / 1E5,
        lng: lng / 1E5,
      ));
    }

    return points;
  }
}