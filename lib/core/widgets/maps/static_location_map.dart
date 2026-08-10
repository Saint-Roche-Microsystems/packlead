import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:packlead/core/models/location.dart';
import 'package:packlead/core/widgets/maps/base_map.dart';

class StaticLocationMap extends StatelessWidget {
  final Location location;
  final double zoom;
  final double height;
  final BitmapDescriptor? markerIcon;
  final VoidCallback? onTap;

  const StaticLocationMap({
    super.key,
    required this.location,
    this.zoom = 15.0,
    this.height = 200.0,
    this.markerIcon,
    this.onTap,
  });

  Set<Marker> _buildMarkers() {
    return {
      Marker(
        markerId: const MarkerId('defined_location'),
        position: location.toLatLng(),
        icon: markerIcon ?? BitmapDescriptor.defaultMarker,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        absorbing: true,
        child: SizedBox(
          height: height,
          child: BaseMap(
            initialPosition: location.toLatLng(),
            initialZoom: zoom,
            markers: _buildMarkers(),
            isInteractive: false,
            showMyLocationButton: false,
            myLocationEnabled: false,
          ),
        ),
      ),
    );
  }
}
