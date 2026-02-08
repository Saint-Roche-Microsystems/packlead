import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:packlead/core/models/dispatcher_location.dart';
import 'package:packlead/core/utils/date_formatter.dart';
import 'package:packlead/core/utils/map_utils.dart';
import 'package:packlead/core/utils/marker_builder.dart';

class MultiPointRealtimeMap extends StatefulWidget {
  final List<DispatcherLocation> locations;

  const MultiPointRealtimeMap({
    super.key,
    required this.locations,
  });

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
    for(final location in widget.locations) {
      final markerIcon = await _getOrCreateIcon(location.dispatcherId, location.name);

      final marker = Marker(
        // Include new lat/lng to force update
        markerId: MarkerId('${location.dispatcherId}_${location.lat.toStringAsFixed(6)}_${location.lng.toStringAsFixed(6)}'),
        position: LatLng(location.lat, location.lng),
        infoWindow: InfoWindow(
          title: location.name,
          snippet: 'Última actualización: ${DateFormatter.formatRelativeTime(location.updatedAt)}',
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

  Future<BitmapDescriptor> _getOrCreateIcon(String dispatcherId, String name) async {
    if (_iconCache.containsKey(dispatcherId)) {
      return _iconCache[dispatcherId]!;
    }

    if(_iconGenerationLocks.containsKey(dispatcherId)) {
      return await _iconGenerationLocks[dispatcherId]!;
    }

    // Generate new icon
    final iconFuture = MarkerBuilder.createMarkerIconInitials(name);
    _iconGenerationLocks[dispatcherId] = iconFuture;

    try {
      final icon = await iconFuture;
      _iconCache[dispatcherId] = icon;
      return icon;
    } finally {
      _iconGenerationLocks.remove(dispatcherId);
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

    final bounds = MapUtils.calculateBounds(DispatcherLocation.toLocations(widget.locations));

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.locations.first.lat, widget.locations.first.lng),
        zoom: 12,
      ),
      markers: _markers,
      onMapCreated: (controller) {
        _mapController = controller;
        if (widget.locations.length > 1) {
          controller.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, 50),
          );
        }
      },
    );
  }
}