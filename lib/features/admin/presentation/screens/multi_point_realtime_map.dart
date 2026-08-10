import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:packlead/core/utils/date_formatter.dart';
import 'package:packlead/core/utils/map_utils.dart';
import 'package:packlead/core/utils/marker_builder.dart';
import 'package:packlead/features/admin/viewmodels/admin_tracking_view_model.dart';

class MultiPointRealtimeMap extends StatefulWidget {
  final List<AdminTrackingViewModel> locations;

  const MultiPointRealtimeMap({super.key, required this.locations});

  @override
  State<MultiPointRealtimeMap> createState() => _MultiPointRealtimeMapState();
}

class _MultiPointRealtimeMapState extends State<MultiPointRealtimeMap> {
  Set<Marker> _markers = {};
  bool _isLoading = true;
  GoogleMapController? _mapController;
  final Map<String, BitmapDescriptor> _iconCache = {};
  final Map<String, Future<BitmapDescriptor>> _iconGenerationLocks = {};

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  @override
  void didUpdateWidget(MultiPointRealtimeMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.locations != widget.locations) {
      _updateMarkers();
    }
  }

  Future<void> _loadMarkers() async {
    if (_markers.isEmpty) {
      setState(() {
        _isLoading = true;
      });
    }

    await _updateMarkers();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateMarkers() async {
    final newMarkers = <Marker>{};

    // Iterate over each location and create/update markers
    for (final location in widget.locations) {
      final markerIcon = await _getOrCreateIcon(
        location.firebaseUid,
        location.name,
      );

      final snippetParts = [
        'Última actualización: ${DateFormatter.formatRelativeTime(location.updatedAt)}',
        if (location.vehicle != null) location.vehicle!,
        if (location.licensePlate != null) location.licensePlate!,
      ];

      final marker = Marker(
        // Include new lat/lng to force update
        markerId: MarkerId(
          '${location.firebaseUid}_${location.lat.toStringAsFixed(6)}_${location.lng.toStringAsFixed(6)}',
        ),
        position: LatLng(location.lat, location.lng),
        infoWindow: InfoWindow(
          title: location.name,
          snippet: snippetParts.join(' · '),
        ),
        icon: markerIcon,
        anchor: const Offset(0.5, 0.5),
      );

      newMarkers.add(marker);
    }

    if (mounted) {
      setState(() {
        _markers = newMarkers;
      });
    }
  }

  Future<BitmapDescriptor> _getOrCreateIcon(
    String firebaseUid,
    String name,
  ) async {
    if (_iconCache.containsKey(firebaseUid)) {
      return _iconCache[firebaseUid]!;
    }

    if (_iconGenerationLocks.containsKey(firebaseUid)) {
      return await _iconGenerationLocks[firebaseUid]!;
    }

    // Generate new icon
    final iconFuture = MarkerBuilder.createMarkerIconInitials(name);
    _iconGenerationLocks[firebaseUid] = iconFuture;

    try {
      final icon = await iconFuture;
      _iconCache[firebaseUid] = icon;
      return icon;
    } finally {
      _iconGenerationLocks.remove(firebaseUid);
    }
  }

  @override
  void dispose() {
    _iconCache.clear();
    _iconGenerationLocks.clear();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _markers.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    final bounds = MapUtils.calculateBounds(
      AdminTrackingViewModel.toLocations(widget.locations),
    );

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.locations.first.lat, widget.locations.first.lng),
        zoom: 12,
      ),
      markers: _markers,
      onMapCreated: (controller) {
        _mapController = controller;
        if (widget.locations.length > 1) {
          controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
        }
      },
    );
  }
}
