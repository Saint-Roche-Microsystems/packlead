import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final LatLng? currentPosition;
  final bool isLoading;
  final Function(GoogleMapController) onMapCreated;

  const MapWidget({
    super.key,
    required this.currentPosition,
    required this.isLoading,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: currentPosition ?? const LatLng(-0.1807, -78.4678),
        zoom: 15,
      ),
      onMapCreated: onMapCreated,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      mapType: MapType.normal,
      zoomControlsEnabled: false,
    );
  }
}