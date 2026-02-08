import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:packlead/core/models/dispatcher_location.dart';
import 'package:packlead/core/utils/date_formatter.dart';
import 'package:packlead/core/utils/map_utils.dart';

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
          snippet: 'Última actualización: ${DateFormatter.formatRelativeTime(location.updatedAt)}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue,
        ),
      );
    }).toSet();

    final bounds = MapUtils.calculateBounds(DispatcherLocation.toLocations(locations));

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
}