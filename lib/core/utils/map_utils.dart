import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:packlead/core/config/env_config.dart';
import 'package:packlead/core/utils/polyline_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:packlead/core/models/location.dart';
import 'package:http/http.dart' as http;

class MapUtils {
  MapUtils._();

  /// Open Google Maps with a query for the given location
  static Future<void> openInGoogleMaps(Location location) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=${location.lat},${location.lng}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  /// Fetch route points between origin and destination using Google Maps Directions API
  /// return Location domain objects
  static Future<List<Location>> getRoute({
    required Location origin,
    required Location destination,
    String travelMode = 'driving',
  }) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${origin.lat},${origin.lng}'
        '&destination=${destination.lat},${destination.lng}'
        '&mode=${travelMode.toLowerCase()}'
        '&key=${EnvConfig.googleMapsApiKey}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final polylinePoints = data['routes'][0]['overview_polyline']['points'];
          return PolylineBuilder.decodePolyline(polylinePoints);
        } else {
          throw Exception('Error in response: ${data['status']}');
        }
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  // Adjust camera to focus on a location with a specific zoom level
  static CameraUpdate focusOnLocation(
      Location location, {
        double zoom = 14.0,
      }) {
    return CameraUpdate.newLatLngZoom(
      location.toLatLng(),
      zoom,
    );
  }

  /// Adjust the camera to show multiple locations with appropriate zoom and padding
  static CameraUpdate focusOnMultipleLocations(
      List<Location> locations, {
        double padding = 80.0,
      }) {
    if (locations.isEmpty) {
      // If no locations, center aroound default coordinates
      return CameraUpdate.newLatLngZoom(
        const LatLng(-0.1807, -78.4678),
        12.0,
      );
    }

    if (locations.length == 1) {
      // If only one location, focus on it directly
      return focusOnLocation(locations.first);
    }

    // Calculate bounds to include all locations
    final bounds = calculateBounds(locations);

    return CameraUpdate.newLatLngBounds(bounds, padding);
  }

  /// Adjust the camera to show a complete route in the map
  static CameraUpdate focusOnRoute({
    required Location origin,
    required Location destination,
    List<Location>? routePoints,
    double padding = 80.0,
  }) {
    // If there's a route, focus on all the points
    if (routePoints != null && routePoints.isNotEmpty) {
      return focusOnMultipleLocations(routePoints, padding: padding);
    }

    // If no route is provided, focus between the origin and destination
    return focusOnMultipleLocations([origin, destination], padding: padding);
  }

  /// BOUNDS CALCULATION
  /// It finds the furthest points in the north, south, east, and west
  /// directions to create a bounding box that includes all locations.
  static LatLngBounds calculateBounds(List<Location> locations) {
    if (locations.isEmpty) {
      // Default bounds if no locations are provided
      const defaultPoint = LatLng(-0.1807, -78.4678);
      return LatLngBounds(
        southwest: defaultPoint,
        northeast: defaultPoint,
      );
    }

    if (locations.length == 1) {
      // If there is only one location, create a small bounds around it
      final point = locations.first.toLatLng();
      return LatLngBounds(
        southwest: LatLng(point.latitude - 0.01, point.longitude - 0.01),
        northeast: LatLng(point.latitude + 0.01, point.longitude + 0.01),
      );
    }

    // Find limits
    double minLat = locations.first.lat;
    double maxLat = locations.first.lat;
    double minLng = locations.first.lng;
    double maxLng = locations.first.lng;

    for (final location in locations) {
      if (location.lat < minLat) minLat = location.lat;
      if (location.lat > maxLat) maxLat = location.lat;
      if (location.lng < minLng) minLng = location.lng;
      if (location.lng > maxLng) maxLng = location.lng;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}