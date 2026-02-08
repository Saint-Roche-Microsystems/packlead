import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:packlead/core/models/dispatcher_location.dart';
import 'package:packlead/core/utils/date_formatter.dart';
import 'package:packlead/core/utils/map_utils.dart';
import 'package:packlead/core/utils/marker_builder.dart';

class MultiPointRealtimeMap extends ConsumerStatefulWidget {
  final List<DispatcherLocation> locations;

  const MultiPointRealtimeMap({
    super.key,
    required this.locations,
  });

  @override
  ConsumerState<MultiPointRealtimeMap> createState() => _MultiPointRealtimeMapState();
}

class _MultiPointRealtimeMapState extends ConsumerState<MultiPointRealtimeMap> {

  Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  @override
  void didUpdateWidget(MultiPointRealtimeMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.locations != widget.locations) {
      _loadMarkers();
    }
  }

  Future<void> _loadMarkers() async {
    if(_markers.isEmpty) {
      setState(() {
        _isLoading = true;
      });
    }

    final markerFutures = widget.locations.map((location) async {
      final markerIcon = await MarkerBuilder.createMarkerIconInitials(location.name);

      return Marker(
        markerId: MarkerId(location.dispatcherId),
        position: LatLng(location.lat, location.lng),
        infoWindow: InfoWindow(
          title: location.name,
          snippet: 'Última actualización: ${DateFormatter.formatRelativeTime(location.updatedAt)}',
        ),
        icon: markerIcon,
      );
    });

    final markers = await Future.wait(markerFutures);

    if (mounted) {
      setState(() {
        _markers = markers.toSet();
        _isLoading = false;
      });
    }
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
        if (widget.locations.length > 1) {
          controller.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, 50),
          );
        }
      },
    );
  }
}