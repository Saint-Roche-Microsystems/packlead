import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:packlead/core/models/dispatcher_location.dart';

class MultiPointRealtimeMap extends ConsumerWidget {
  final List<DispatcherLocation> locations;

  const MultiPointRealtimeMap({
    super.key,
    required this.locations,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final markers = locations.map((location) {
      return Marker(
        markerId: MarkerId(location.dispatcherId),
        position: LatLng(location.lat, location.lng),
        infoWindow: InfoWindow(
          title: location.name,
          snippet: 'Última actualización: ${_formatTime(location.updatedAt)}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue,
        ),
      );
    }).toSet();

    final bounds = _calculateBounds(locations);

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(locations.first.lat, locations.first.lng),
        zoom: 12,
      ),
      markers: markers,
      onMapCreated: (controller) {
        if (locations.length > 1) {
          controller.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, 50),
          );
        }
      },
    );
  }

  LatLngBounds _calculateBounds(List<DispatcherLocation> locations) {
    double minLat = locations.first.lat;
    double maxLat = locations.first.lat;
    double minLng = locations.first.lng;
    double maxLng = locations.first.lng;

    for (var location in locations) {
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

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) return 'Hace ${difference.inSeconds}s';
    if (difference.inMinutes < 60) return 'Hace ${difference.inMinutes}m';
    return 'Hace ${difference.inHours}h';
  }
}