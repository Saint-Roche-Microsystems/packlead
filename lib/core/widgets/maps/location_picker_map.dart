import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:packlead/core/models/location.dart';
import 'package:packlead/core/widgets/maps/base_map.dart';
import 'package:packlead/core/widgets/snackbars.dart';


class LocationPickerMap extends StatefulWidget {
  final Location? initialLocation;
  final Function(Location) onLocationConfirmed;

  const LocationPickerMap({
    super.key,
    this.initialLocation,
    required this.onLocationConfirmed,
  });

  @override
  State<LocationPickerMap> createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  GoogleMapController? _mapController;
  LatLng? _selectedPosition;

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.initialLocation?.toLatLng();

    if (_selectedPosition == null) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // Use default location if permission is denied
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _setDefaultLocation();
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final currentLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _selectedPosition = currentLocation;
      });

      // Move the camera to current location
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation, 15),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _setDefaultLocation() {
    setState(() {
      _selectedPosition = const LatLng(-0.1807, -78.4678);
    });
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedPosition = position;
    });
  }

  void _onConfirmLocation() {
    if (_selectedPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        ErrorSnackBar(message: 'Debe seleccionar una ubicación en el mapa'),
      );
      return;
    }

    final location = Location(
      lat: _selectedPosition!.latitude,
      lng: _selectedPosition!.longitude,
    );

    widget.onLocationConfirmed(location);
    Navigator.pop(context);
  }

  Set<Marker> _buildMarkers() {
    if (_selectedPosition == null) return {};

    return {
      Marker(
        markerId: const MarkerId('selected_location'),
        position: _selectedPosition!,
        draggable: true,
        onDragEnd: (newPosition) {
          setState(() {
            _selectedPosition = newPosition;
          });
        },
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar ubicación'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _selectedPosition == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Stack(
        children: [
          BaseMap(
            initialPosition: _selectedPosition!,
            initialZoom: 15,
            markers: _buildMarkers(),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: _onMapTap,
            isInteractive: true,
            myLocationEnabled: false,
            showMyLocationButton: false,
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: _onConfirmLocation,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Confirmar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}